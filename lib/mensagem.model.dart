import 'package:cloud_firestore/cloud_firestore.dart';

class MensagemModel {
  String? uid;
  String? nome;
  String? mensagem;
  Timestamp? data;
  bool deleted = false;

  MensagemModel(this.uid, this.nome, this.mensagem, this.data);

  MensagemModel.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.nome = map['nome'];
    this.mensagem = map['mensagem'];
    this.data = map['data'] as Timestamp;
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": this.uid,
      "nome": this.nome,
      "mensagem": this.mensagem,
      "data": new Timestamp.now(),
      "deleted": false,
    };
  }
}
