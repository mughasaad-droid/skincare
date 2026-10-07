import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:skinn/constants.dart';
import 'package:skinn/screens/result_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Use the front camera for face scanning if available
    final frontCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _saveToFirestore(String issue, String type, String tone) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('records').add({
        'userId': user.uid,
        'issue': issue,
        'skin_type': type,
        'skin_tone': tone,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _analyzeFace() async {
    try {
      setState(() => _isProcessing = true);

      // Take picture
      final image = await _controller.takePicture();
      final imageBytes = await image.readAsBytes();

      // Initialize Gemini Model
      final model = GenerativeModel(
        model: 'gemini-3.1-flash-lite', // Using the latest 2026 stable lite model
        apiKey: AppConstants.geminiApiKey,
      );

      // Prepare Prompt
      const prompt = 'Analyze this face image and detect if there is Acne, Redness, Mild Acne, or Dullness. '
          'Also identify the person\'s Skin Type (e.g., oily, dry, sensitive, normal) and Skin Tone (e.g., Fair, Light, Medium, Dark). '
          'Return the result ONLY as a JSON object with these exact keys: "issue" (the most prominent skin concern), "skin_type", and "skin_tone". '
          'If multiple issues are present, pick the most significant one. Do not include markdown or extra text.';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      // Call Gemini API
      final response = await model.generateContent(content);
      final responseText = response.text;

      if (responseText != null) {
        // Clean JSON response (remove markdown if any)
        final cleanJson = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
        final data = jsonDecode(cleanJson);

        final issue = data['issue'] ?? 'No major issue';
        final type = data['skin_type'] ?? 'Unknown';
        final tone = data['skin_tone'] ?? 'Unknown';

        // Save to Firebase
        await _saveToFirestore(issue, type, tone);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                issue: issue,
                skinType: type,
                skinTone: tone,
              ),
            ),
          );
        }
      } else {
        throw Exception('AI returned empty response');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing skin: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Face'),
        backgroundColor: const Color(0xFFACACC1),
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Camera Preview
                Center(child: CameraPreview(_controller)),
                
                // Overlay for face
                Center(
                  child: Container(
                    width: 280,
                    height: 380,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                
                // Loading Overlay
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 20),
                          Text(
                            'Analyzing Skin...',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Scan Button
                if (!_isProcessing)
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _analyzeFace,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFACACC1),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'SCAN',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
