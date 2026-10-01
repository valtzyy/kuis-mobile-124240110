import 'package:flutter/material.dart';
import 'package:kuis_mobile/root.dart';
import 'package:kuis_mobile/models/data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  void login() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username == account.username && password == account.password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Root(
            username: username,
            displayName: account.displayName,
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF1A1A1A),
          content: Text(
            "Login Berhasil! Selamat datang.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Login Gagal. Username atau Password Salah"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Logo / Brand from repository link-gambar.txt
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    "https://play-lh.googleusercontent.com/bB_cyOTbQfFmV4IaeqTIFJVc1Wm4UdQwQai8GjthG4uaXrTHNZTKsMtg9_9058GeZGLgoJzIasYYdFkSvdyQ",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFED1D24),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            "UNI\nQLO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Selamat Datang di UNIQLO",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Selamat Berbelanja",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 48),

                // Username Field
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Masukkan username",
                    prefixIcon: const Icon(Icons.person_outline,
                        color: Color(0xFF1A1A1A)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF1A1A1A), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F8F8),
                  ),
                ),

                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Masukkan password",
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: Color(0xFF1A1A1A)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF1A1A1A), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F8F8),
                  ),
                ),

                const SizedBox(height: 28),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "MASUK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Hint credentials
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "Demo Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Username: Novaldo",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "Password: 110",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
