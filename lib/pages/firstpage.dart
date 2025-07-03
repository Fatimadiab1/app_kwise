import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_router.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String username = "Invité";

  final List<Map<String, dynamic>> categories = [
    {"title": "Culture générale", "image": "assets/images/culture.png"},
    {"title": "Divertissement", "image": "assets/images/divertissement.png"},
    {"title": "Éducatif", "image": "assets/images/educatif.png"},
    {"title": "Thèmes modernes", "image": "assets/images/moderne.png"},
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');
    if (name != null) {
      setState(() => username = name);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, AppRouter.accueil);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 245, 254),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildUserCard(),
                const SizedBox(height: 24),
                Text(
                  "Choisis une catégorie",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildFullWidthCategory(
                        title: category["title"]!,
                        image: category["image"]!,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                _buildHistoriqueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B4B65)),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          "Kwise",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B4B65),
          ),
        ),
        TextButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout, color: Colors.red),
          label: Text(
            "Déconnexion",
            style: GoogleFonts.poppins(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF1B4B65),
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Bonjour $username ",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthCategory({
    required String title,
    required String image,
  }) {
    return GestureDetector(
      onTap: () => _showDifficultyDialog(context, title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        height: 100,
        child: Row(
          children: [
            Image.asset(image, width: 70, height: 70),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B4B65),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoriqueButton() {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, AppRouter.historique);
      },
      icon: const Icon(Icons.history, color: Color(0xFF1B4B65)),
      label: Text(
        "Historique",
        style: GoogleFonts.poppins(color: Color(0xFF1B4B65)),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF1B4B65)),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFF9FBFD),
        title: Text(
          "Choisis un niveau",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF1B4B65),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLevelButton("Facile", 1, category),
            _buildLevelButton("Moyen", 2, category),
            _buildLevelButton("Difficile", 3, category),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelButton(String label, int flames, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFECF5FE),
          foregroundColor: const Color(0xFF1B4B65),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            AppRouter.quiz,
            arguments: {
              'category': category,
              'difficulty': label,
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(
                flames,
                (_) => const Icon(Icons.whatshot, color: Colors.orange, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
