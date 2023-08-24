import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ulesson_auth_firebase/auth/presentation/sign_in_page.dart';
import 'package:ulesson_auth_firebase/auth/repository/auth.dart';
import 'package:ulesson_auth_firebase/home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() async {
    await _checkUser();
    super.didChangeDependencies();
  }

  _checkUser() async {
    final auth = Auth();
    bool isSignedIn = await auth.isUserSignedIn();
    if (!mounted) return;
    if (isSignedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
