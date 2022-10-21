import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:genshin_app/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: TextField(
                controller: _retypePasswordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  hintText: "Retype Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty ||
                    _retypePasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Empty Input"),
                    ),
                  );
                  return;
                }

                if (_passwordController.text.toString() !=
                    _retypePasswordController.text.toString()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords Do Not Match, Please Retype"),
                    ),
                  );
                  return;
                }

                if (_passwordController.text.toString().length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password At Least 6 Character Length"),
                    ),
                  );
                  return;
                }

                try {
                  log(_emailController.text);
                  log(_passwordController.text);
                  await _firebaseAuth
                      .createUserWithEmailAndPassword(
                          email: _emailController.text.toString(),
                          password: _passwordController.text.toString())
                      .then(
                    (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Sign Up Succeed"),
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                  );
                } catch (e) {
                  log(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sign Up Failed"),
                    ),
                  );
                }
              },
              child: const Text("Sign Up"),
            ),
            const Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Have an account already? ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "Sign In",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
