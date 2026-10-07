import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String issue;
  final String skinType;
  final String skinTone;

  const ResultScreen({
    super.key,
    required this.issue,
    required this.skinType,
    required this.skinTone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8F3C9), // Light green background
      body: SafeArea(
        child: Column(
          children: [
            // Results Header Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              color: const Color(0xFFACACC1), // Greyish color from image
              child: const Text(
                'RESULTS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Circular Back Button
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFACACC1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Detection Result Text (Red, Bold, Italic)
                    Center(
                      child: Text(
                        '$issue detected!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Data Box for Skin Type and Tone
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Skin type:', skinType),
                            const SizedBox(height: 25),
                            _buildInfoRow('Skin tone:', skinTone),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
