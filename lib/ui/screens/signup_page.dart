// lib/ui/screens/signup_page.dart

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/services/auth_service.dart';
import 'package:plant_care/ui/screens/signin_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _passCtrl  = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _attemptRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await AuthService.instance.register(
      email: _emailCtrl.text.trim(),
      name:  _nameCtrl.text.trim(),
      pass:  _passCtrl.text,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: const SignIn(),
          type: PageTransitionType.bottomToTop,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already registered')),
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
                Image.asset('assets/images/signup.png'),
                const SizedBox(height: 16),
                const Text('Sign Up',
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
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
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
                    onPressed: _attemptRegister,
                    child: const Text('Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: const SignIn(),
                        type: PageTransitionType.bottomToTop,
                      ),
                    ),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Have an Account? ',
                          style: TextStyle(color: Constants.blackColor)),
                      TextSpan(
                          text: 'Login',
                          style: TextStyle(color: Constants.primaryColor)),
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
