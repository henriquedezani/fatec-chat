import 'package:fatec_chat/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _formKey = GlobalKey<FormState>();

  String? email, senha;

  Future _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await auth.signInWithEmailAndPassword(email: email!, password: senha!);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => ChatPage()), (route) => false);
      } on FirebaseAuthException catch (ex) {
        print(ex.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
                onSaved: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Senha",
                ),
                obscureText: true,
                onSaved: (value) => senha = value,
                validator: (value) {
                  if (value!.length < 6)
                    return "Senha deve conter no mínimo 6 caracteres";
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _login(context),
                  child: Text("Entrar"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => RegisterPage()));
                },
                child: Text("Não tem cadastro, clique aqui."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
