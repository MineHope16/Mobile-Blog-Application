import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zidioblogapp/screens/home/home_screen.dart';
import 'package:zidioblogapp/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (auth.currentUser == null){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const LoginScreen()),);
      }

      else{
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const HomeScreen()));
      }

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", height: 500),
            const SizedBox(height: 15),
            const Text(
              "Abhishek's BlogApp",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

