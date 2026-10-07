import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';
import 'package:skinn/screens/welcome_screen.dart';
import 'package:skinn/screens/splash_screen.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize cameras
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error: ${e.code}\nError Message: ${e.description}');
  }
  
  runApp(const SkinnApp());
}

class SkinnApp extends StatelessWidget {
  const SkinnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skinn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD8F3C9)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
