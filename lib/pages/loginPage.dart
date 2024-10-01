import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child:  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: Colors.blue),height: 800,width: 500, padding: EdgeInsets.all(18), child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFormField(controller: _emailController,),
          TextFormField(controller: _passwordController,),
          ElevatedButton(onPressed: ()=>{}, child: Text("Press me"))
        ],
      ),) ,),
    );
  }
}
