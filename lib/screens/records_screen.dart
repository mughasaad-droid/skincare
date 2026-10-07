import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  Future<void> _clearRecords(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final collection = await FirebaseFirestore.instance
          .collection('records')
          .where('userId', isEqualTo: user.uid)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in collection.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All records cleared successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFFD8F3C9), // Light green background
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              color: const Color(0xFFACACC1), // Greyish header
              child: const Text(
                'RECORDS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('records')
                    .where('userId', isEqualTo: user?.uid)
                    // Removing orderBy temporarily to check if index is the issue
                    .snapshots(),
                builder: (context, snapshot) {
                  int totalRecords = snapshot.hasData ? snapshot.data!.docs.length : 0;

                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      // Top Row: Back Button and Total Badge
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            
                            // Total Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFACACC1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Total: $totalRecords',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      // User Record Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            'Record of $userName',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Records List
                      Expanded(
                        child: snapshot.hasError
                            ? Center(child: Text('Error: ${snapshot.error}'))
                            : snapshot.connectionState == ConnectionState.waiting
                                ? const Center(child: CircularProgressIndicator())
                                : (totalRecords == 0)
                                    ? const Center(child: Text('No records found.'))
                                    : ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    itemCount: totalRecords,
                                    itemBuilder: (context, index) {
                                      final record = snapshot.data!.docs[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 25),
                                        child: Row(
                                          children: [
                                            // Black Semi-circle
                                            Container(
                                              width: 70,
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF1A1A1A),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(50),
                                                  bottomRight: Radius.circular(50),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            // Result Box
                                            Expanded(
                                              child: Container(
                                                height: 100,
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.black, width: 3),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '${record['issue']} detected',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      ),
                      
                      // Clear Records Button
                      if (totalRecords > 0)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () => _clearRecords(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            ),
                            child: const Text(
                              'CLEAR RECORDS',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
