import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skinn/main.dart';
import 'package:skinn/screens/camera_screen.dart';
import 'package:skinn/screens/records_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the current user from Firebase
    final User? user = FirebaseAuth.instance.currentUser;
    // Use display name if available, otherwise fallback to "User"
    final String userName = user?.displayName ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFFD8F3C9), // Light green background from image
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              color: const Color(0xFFACACC1), // Greyish color from image
              child: Text(
                '$userName Logged In',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Circular Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: InkWell(
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
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Logo Image
                    Image.asset(
                      'assets/images/logo.png',
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Action Cards (Square boxes with black borders)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionCard(
                          context: context,
                          imagePath: 'assets/images/camera_icon.png',
                          label: 'Scan your face',
                          iconData: Icons.camera_alt_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(cameras: cameras),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 25),
                        _buildActionCard(
                          context: context,
                          imagePath: 'assets/images/folder_icon.png',
                          label: 'See Record',
                          iconData: Icons.folder_open,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecordsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 70),
                    
                    // Log Out Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              // Go back to the very first screen (Welcome Screen)
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFACACC1),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'LOG OUT',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    String? imagePath,
    required String label,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(0), // Sharp corners like in image
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 60,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
