import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'homescreen.dart';


void main() {
  runApp(const MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyNotes',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4938F5),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to Home Screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF9F8FF),
              Color(0xFFF0EFFF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main splash screen content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated notes logo from note.json
                    Lottie.asset(
                      'assets/note.json',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),

                    const SizedBox(height: 10),

                    // MyNotes app name
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'My',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Notes',
                            style: TextStyle(
                              color: Color(0xFF4938F5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Capture Ideas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF45445A),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Organize Your Thoughts',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF45445A),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Loading indicator
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF4938F5),
                        ),
                        backgroundColor: Color(0xFFDCD8FF),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom progress bar
              Positioned(
                bottom: 22,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 130,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCD8FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 65,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4938F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
