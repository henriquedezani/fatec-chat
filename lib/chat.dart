import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fatec_chat/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future _logout(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          actions: [
            TextButton(
              onPressed: () => _logout(context),
              child: Text("SAIR", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: firestore
              .collection('users')
              .doc(auth.currentUser?.uid)
              .snapshots(),
          builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text(data['apelido']);
          },
        ));
  }
}
