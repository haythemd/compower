import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/userService.dart'; // Import UserService

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController(); // New controller for displayName

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService(); // Create instance of UserService

  bool _isLoading = false;
  String? _errorMessage;

  // Method to register the user using email and password
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Register the user
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // After successful registration, create a user in Firestore using UserService
        await _userService.createOrUpdateUser(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          displayName: _displayNameController.text.trim(),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );

        // Navigate to home page
        await Navigator.of(context).pushReplacementNamed('home');

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            _errorMessage = 'The password provided is too weak.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            _errorMessage = 'The account already exists for that email.';
          });
        } else {
          setState(() {
            _errorMessage = e.message;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(labelText: 'Display Name'), // New field for displayName
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your display name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 16.0),
              ],
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
