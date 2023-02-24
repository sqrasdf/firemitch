import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helper.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // constroller for email and password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  // shows AlertDialog with message
  void showCustomDialog(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: Text(text));
      },
    );
  }

  // signs up a new user with all details
  void signUp() async {
    String? firstName = _firstNameController.text.trim();
    String? lastName = _lastNameController.text.trim();
    String? age = _ageController.text;
    String? email = _emailController.text.trim();
    String? password = _passwordController.text.trim();
    String? password2 = _passwordController2.text.trim();

    // checking if all fields have some value
    if (firstName.isEmpty) {
      showCustomDialog("First name is not given.\nPlease type it in.");
      return;
    }
    if (lastName.isEmpty) {
      showCustomDialog("Last name is not given.\nPlease type it in.");
      return;
    }
    if (age.isEmpty) {
      showCustomDialog("Age is not given.\nPlease type it in.");
      return;
    }
    if (email.isEmpty) {
      showCustomDialog("Email name is not given.\nPlease type it in.");
      return;
    }
    if (password.isEmpty) {
      showCustomDialog("Password is not given.\nPlease type it in.");
      return;
    }
    if (password2.isEmpty) {
      showCustomDialog(
          "Password confirmation is not given.\nPlease type it in.");
      return;
    }

    // checking if passwords are the same
    if (password != password2) {
      showCustomDialog("Passwords are not identical. Plase type them again.");
    }

    // checking if password is at least 6 chars long
    if (password.length < 6) {
      showCustomDialog(
          "Password needs to be at least 6 characters long.\nNow it's  short like ur pp.");
    }

    // creating new user
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showCustomDialog("${e.message}");
    }

    // adding user details
    try {
      addUserDetails(firstName, lastName, email, int.parse(age));
    } on FirebaseAuthException catch (e) {
      showCustomDialog("${e.message}");
    }
  }

  // adding user details
  Future addUserDetails(
      String firstName, String lastName, String email, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      "first name": firstName,
      "last name": lastName,
      "email": email,
      "age": age,
    });
  }

  // freeing memory of those controllers i guess
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
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
                const SizedBox(height: 25),

                // hello text
                Text(
                  "Hello there",
                  style: GoogleFonts.montserrat(
                      fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // good to see u text
                const Text(
                  "Register below with your details!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 30),

                // first name
                CustomInputField(
                  controller: _firstNameController,
                  hintText: "First name",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  formatter: null,
                ),
                const SizedBox(height: 10),

                // last name
                CustomInputField(
                  controller: _lastNameController,
                  hintText: "Last name",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  formatter: null,
                ),
                const SizedBox(height: 10),

                // age
                CustomInputField(
                  controller: _ageController,
                  hintText: "Age",
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 10),

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

                // password2
                CustomInputField(
                  controller: _passwordController2,
                  hintText: "Confirm password",
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  formatter: null,
                ),
                const SizedBox(height: 10),

                // signin button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Up",
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
                      "I am a member!",
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        " Log in",
                        style: TextStyle(
                          color: Colors.pinkAccent[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
