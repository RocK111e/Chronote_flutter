// lib/page/signup_page.dart

import 'package:flutter/material.dart';
import '../firebase/auth.dart'; // Ensure this path is correct
import '../firebase/analytics.dart'; // Ensure this path is correct

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Firebase service
  final AuthService _authService = AuthService();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // State
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_isLoading) return;

    // Validate fields
    if (!_formKey.currentState!.validate()) {
      analytics.logEvent(name: 'signup_validation_failed');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Call Firebase signup
    final errorMessage = await _authService.signUpWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (errorMessage == null) {
      analytics.logEvent(name: 'signup_passed');
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() {
        _errorMessage = errorMessage;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 750,
            maxWidth: 350,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                const SizedBox(height: 80.0),
                _buildHeader(),
                const SizedBox(height: 48.0),
                _buildFormFields(),
                const SizedBox(height: 24.0),
                _buildSignUpButton(),
                const SizedBox(height: 24.0),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(
          Icons.book_outlined,
          size: 80.0,
          color: Colors.blue,
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Chronote',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Create your digital diary account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.grey[400]),
              hintText: 'your@email.com',
              hintStyle: TextStyle(color: Colors.grey[700]),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email.';
              }
              final emailRegex = RegExp(r'^.+@.+$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Enter a valid email address.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.grey[400]),
              hintText: '••••••••',
              hintStyle: TextStyle(color: Colors.grey[700]),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password.';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _repeatPasswordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Repeat password',
              labelStyle: TextStyle(color: Colors.grey[400]),
              hintText: '••••••••',
              hintStyle: TextStyle(color: Colors.grey[700]),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please repeat your password.';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          _buildErrorMessage(),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink();
    return Text(
      _errorMessage!,
      style: const TextStyle(color: Colors.red, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            )
          : const Text(
              'Sign Up',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.grey[400]),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: const Text(
            'Login',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
