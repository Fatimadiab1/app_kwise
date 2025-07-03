import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kwise/config/app_router.dart'; //

void main() {
  runApp(const KwiseApp());
}

class KwiseApp extends StatelessWidget {
  const KwiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kwise - Accueil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFCAEBFF),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: AppRouter.accueil,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Color(0xFF1B4B65), size: 36),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF1B4B65), size: 36),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Bienvenue sur Kwise",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Connecte-toi pour suivre tes scores et progresser !",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text("Connexion"),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, AppRouter.login); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B4B65),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.person_add),
                          label: const Text("Inscription"),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, AppRouter.register); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5FACD3),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icon.png', width: 180, height: 180),
              const SizedBox(height: 30),
              const Text(
                "Cerveau prêt ? Le jeu commence.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B4B65),
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Commencer sans compte ?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Tu peux jouer sans te connecter,\nmais tes scores ne seront pas sauvegardés.",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow),
                              label: const Text("Jouer sans compte"),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, AppRouter.first); 
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5FACD3),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text("Connexion"),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, AppRouter.login); 
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B4B65),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, AppRouter.register); 
                              },
                              child: const Text("Créer un compte"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                splashColor: Colors.purple.withAlpha(76),
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color(0xFF5FACD3),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(76),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    child: Text(
                      "Commencer le quiz",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
