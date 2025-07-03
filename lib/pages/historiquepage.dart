import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/historique.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  List<Historique> historiqueList = [];

  @override
  void initState() {
    super.initState();
    _loadHistorique();
  }

  Future<void> _loadHistorique() async {
    final data = await DatabaseHelper().getHistorique();
    setState(() {
      historiqueList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF5FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1B4B65)),
        title: Text(
          "Historique des parties",
          style: GoogleFonts.poppins(
            color: const Color(0xFF1B4B65),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: historiqueList.isEmpty
          ? const Center(
              child: Text(
                "Aucun historique trouvé.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historiqueList.length,
              itemBuilder: (context, index) {
                final h = historiqueList[index];
                final percent = h.score / 10;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_graph, color: Color(0xFF5FACD3)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${h.category} - ${h.difficulty}",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B4B65),
                              ),
                            ),
                          ),
                          Text(
                            "${h.score}/10",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: h.score >= 7
                                  ? Colors.green
                                  : h.score >= 4
                                      ? const Color(0xFF5FACD3)
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          h.score >= 7
                              ? Colors.green
                              : h.score >= 4
                                  ? const Color(0xFF5FACD3)
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            h.date,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
