import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';
import '../database/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _obscurePassword = true;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final existingUsers = await _dbHelper.getAllUsers();
      final alreadyExists = existingUsers.any((u) => u.email == email);

      if (alreadyExists) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Text("Erreur"),
            content: Text("Cet email est déjà utilisé."),
          ),
        );
        return;
      }

      final newUser = User(
        username: username,
        email: email,
        password: password,
      );
      await _dbHelper.insertUser(newUser);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      Navigator.pushReplacementNamed(context, '/first');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Créer un compte",
          style: GoogleFonts.poppins(color: Color(0xFF1B4B65)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B4B65)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Nom d'utilisateur",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return "Nom d'utilisateur trop court";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      !RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                    return "Email invalide";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Mot de passe trop court (min 6 caractères)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4B65),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "S'inscrire",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: Text(
                    "Déjà un compte ? Connectez-vous",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(0xFF1B4B65),
                      fontWeight: FontWeight.w500,
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
