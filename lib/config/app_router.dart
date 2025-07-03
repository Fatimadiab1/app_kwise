// lib/config/app_router.dart

import 'package:flutter/material.dart';
import '../main.dart'; // Pour AccueilPage
import '../pages/firstpage.dart';
import '../pages/login.dart';
import '../pages/register.dart';
import '../pages/historiquepage.dart';
import '../pages/quiz_page.dart';

class AppRouter {
  // 1️⃣ Déclaration des routes comme constantes
  static const String accueil = '/';
  static const String first = '/first';
  static const String login = '/login';
  static const String register = '/register';
  static const String historique = '/historique';
  static const String quiz = '/quiz';

  // 2️⃣ Fonction pour générer les routes
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case accueil:
        return MaterialPageRoute(builder: (_) => const AccueilPage());
      case first:
        return MaterialPageRoute(builder: (_) => const FirstPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case historique:
        return MaterialPageRoute(builder: (_) => const HistoriquePage());
      case quiz:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => QuizPage(
            category: args['category']!,
            difficulty: args['difficulty']!,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page introuvable'),
            ),
          ),
        );
    }
  }
}
