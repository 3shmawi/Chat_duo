import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirebaseView extends StatefulWidget {
  const TestFirebaseView({super.key});

  @override
  State<TestFirebaseView> createState() => _TestFirebaseViewState();
}

class _TestFirebaseViewState extends State<TestFirebaseView> {
  final _firebase = FirebaseFirestore.instance;

  final testCtrl = TextEditingController();

  _sendAtFireStore() async {
    if (testCtrl.text.isEmpty) {
      return;
    }
    await _firebase.collection("Test_Firebase").doc("#").set({
      'text': testCtrl.text,
    }, SetOptions(merge: true));
    testCtrl.clear();
    setState(() {});
  }

  Future<String> _getFromFireStore() async {
    final response = await _firebase.collection("Test_Firebase").doc("#").get();
    if (response.exists) {
      return response.data()!['text'];
    } else {
      return 'Document does not exist';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: testCtrl,
                onChanged: (text) {
                  setState(() {
                    testCtrl.text = text;
                  });
                }),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _sendAtFireStore,
              child: const Text('Send to Firestore'),
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: _getFromFireStore(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.data != null) {
                  return Text('Data: ${snapshot.data}');
                }

                return const Text('Loading...');
              },
            ),
          ],
        ),
      ),
    );
  }
}
