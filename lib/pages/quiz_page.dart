import 'package:flutter/material.dart';
import '../database/questions.dart';
import '../database/db_helper.dart';
import '../models/historique.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_router.dart';

class QuizPage extends StatefulWidget {
  final String category;
  final String difficulty;

  const QuizPage({super.key, required this.category, required this.difficulty});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int currentIndex = 0;
  int score = 0;
  List<Map<String, dynamic>> currentQuestions = [];
  String? selectedAnswer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadQuestions();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadQuestions() {
    final categoryData = questionsData[widget.category];
    final difficultyData = categoryData?[widget.difficulty];

    if (difficultyData != null) {
      currentQuestions = List<Map<String, dynamic>>.from(difficultyData);
      currentQuestions.shuffle();
    }
  }

  void _answerQuestion(String selected) {
    if (selectedAnswer != null) return;

    final correctAnswer = currentQuestions[currentIndex]['answer'];
    setState(() {
      selectedAnswer = selected;
      if (selected == correctAnswer) score++;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < currentQuestions.length - 1) {
        setState(() {
          currentIndex++;
          selectedAnswer = null;
          _fadeController.reset();
          _fadeController.forward();
        });
      } else {
        _saveAndShowResult();
      }
    });
  }

  void _saveAndShowResult() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);

    try {
      final historique = Historique(
        category: widget.category,
        difficulty: widget.difficulty,
        score: score,
        date: formattedDate,
      );

      await DatabaseHelper().insertHistorique(historique);
    } catch (e) {
      print("Erreur d'enregistrement dans l'historique : $e");
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Score :",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tu as obtenu $score / ${currentQuestions.length}",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: score / currentQuestions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.home, color: Color(0xFF1B4B65)),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName(AppRouter.first)),
            label: Text(
              "Retour à l'accueil",
              style: GoogleFonts.poppins(color: Color(0xFF1B4B65)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${widget.category} - ${widget.difficulty}"),
        ),
        body: const Center(child: Text("Aucune question disponible.")),
      );
    }

    final question = currentQuestions[currentIndex];
    final answers = List<String>.from(question['options']);
    final correctAnswer = question['answer'];

    return Scaffold(
      backgroundColor: const Color(0xFFECF5FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF1B4B65)),
        elevation: 1,
        title: Text(
          "${widget.category} - ${widget.difficulty}",
          style: GoogleFonts.poppins(color: const Color(0xFF1B4B65)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (currentIndex + 1) / currentQuestions.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF5FACD3),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Question ${currentIndex + 1} / ${currentQuestions.length}",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B4B65),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                question['question'],
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ...answers.map((option) {
                Color? bgColor;
                Color? txtColor = Colors.black;

                if (selectedAnswer != null) {
                  if (option == correctAnswer) {
                    bgColor = Colors.green[300];
                    txtColor = Colors.white;
                  } else if (option == selectedAnswer) {
                    bgColor = Colors.red[300];
                    txtColor = Colors.white;
                  } else {
                    bgColor = Colors.grey[200];
                  }
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor ?? Colors.white,
                      foregroundColor: txtColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF1B4B65)),
                      ),
                    ),
                    child: Text(
                      option,
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
