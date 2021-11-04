import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fatec_chat/login.dart';
import 'package:fatec_chat/mensagem.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController txtMensagemCtrl = TextEditingController();

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
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firestore
                    .collection('mensagens')
                    .where('deleted', isEqualTo: false)
                    .orderBy('data', descending: true)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (_, index) {
                      return Mensagem(
                        MensagemModel.fromMap(
                          snapshot.data!.docs[index].data(),
                        ),
                      );
                    },
                    reverse: true,
                  );
                }),
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: txtMensagemCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      MensagemModel m = new MensagemModel(
                          auth.currentUser!.uid,
                          auth.currentUser!.displayName,
                          txtMensagemCtrl.text,
                          Timestamp.now());
                      await firestore.collection('mensagens').add(m.toMap());
                      txtMensagemCtrl.clear();
                    },
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class Mensagem extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final MensagemModel model;

  Mensagem(this.model);

  EdgeInsets getMarginByUid() {
    if (model.uid! == auth.currentUser!.uid)
      return EdgeInsets.fromLTRB(100, 10, 20, 5);
    else
      return EdgeInsets.fromLTRB(20, 10, 100, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getMarginByUid(),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: model.uid! == auth.currentUser!.uid
            ? Colors.green[200]
            : Colors.blue[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.nome!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(
            height: 4,
          ),
          Text(model.mensagem!),
          SizedBox(
            height: 6,
          ),
          Text(
            model.data!.toDate().toString(),
            style: TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
