import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_admin/authentication/screens/authentication_screen.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/home/screens/home_screen.dart';
import 'package:foodpanda_admin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final ap = context.read<AuthenticationProvider>();

    super.initState();

    Timer(const Duration(seconds: 2), () async {
      if (!ap.isSignedIn) {
        Navigator.pushReplacementNamed(context, AuthenticationScreen.routeName);
      } else {
        await ap.getUserDataFromSharedPreferences();

        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scheme.primary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash.png'),
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
