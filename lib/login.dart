import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genshin_app/home.dart';
import 'package:genshin_app/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In',
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
              height: 10,
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
            ElevatedButton(
              onPressed: () async {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Empty Input"),
                    ),
                  );
                  return;
                }

                try {
                  await _firebaseAuth
                      .signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  )
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Sign In Succeed"),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  });
                } catch (e) {
                  log(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sign In Failed"),
                    ),
                  );
                }
              },
              child: const Text("Sign In"),
            ),
            const Divider(
              height: 10,
              color: Colors.transparent,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Don't have an account yet? ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "Sign Up",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
