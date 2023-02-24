import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firemitch/pages/forgot_password_page.dart';
import 'package:firemitch/pages/helper.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // constroller for email and password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // shows AlertDialog with message
  void showCustomDialog(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: Text(text));
      },
    );
  }

  Future<void> signIn() async {
    String? email = _emailController.text.trim();
    String? password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      // loading screen with some animation
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return const Center(
      //         child: CircularProgressIndicator(color: Colors.pinkAccent));
      //   },
      // );

      // sign in the user
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        showCustomDialog(e.message ?? "WTF u doin bro???\nSTOP :o");

        // Navigator.of(context).pop();
      }

      // pop the loading screen
      // Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
              content: Text("Email or password is misssing."));
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Colors.pinkAccent,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // hello text
                Text(
                  "Hello again!",
                  style: GoogleFonts.montserrat(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // good to see u text
                const Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 30),

                // mail
                CustomInputField(
                  controller: _emailController,
                  hintText: "Email",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  formatter: null,
                ),
                const SizedBox(height: 10),

                // password
                CustomInputField(
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  formatter: null,
                ),
                const SizedBox(height: 10),

                // forgot password row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const ForgotPasswordPage();
                            }),
                          );
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.pinkAccent[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // signin button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // register row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not a member?",
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Text(
                        " Register now",
                        style: TextStyle(
                          color: Colors.pinkAccent[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
