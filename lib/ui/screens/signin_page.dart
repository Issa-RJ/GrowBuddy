// lib/ui/screens/signin_page.dart

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/services/auth_service.dart';
import 'package:plant_care/ui/root_page.dart';
import 'package:plant_care/ui/screens/signup_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final user = await AuthService.instance.login(
      email: _emailCtrl.text.trim(),
      pass:  _passCtrl.text,
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: RootPage(),               // removed const
          type: PageTransitionType.bottomToTop,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/signin.png'),
                const SizedBox(height: 16),
                const Text('Sign In',
                    style:
                    TextStyle(fontSize: 35, fontWeight: FontWeight.w700)),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter Email',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password is required';
                    }
                    if (v.length < 6) {
                      return 'Min 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _attemptLogin,
                    child: const Text('Sign In',
                        style:
                        TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: SignUp(),            // removed const
                        type: PageTransitionType.bottomToTop,
                      ),
                    ),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'New to Planty? ',
                          style: TextStyle(color: Constants.blackColor)),
                      TextSpan(
                          text: 'Register',
                          style:
                          TextStyle(color: Constants.primaryColor)),
                    ])),
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
