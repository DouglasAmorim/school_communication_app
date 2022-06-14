import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Home/Home.dart';

class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Entre com seu e-mail",
                    enabledBorder: OutlineInputBorder(
                        borderRadius:  BorderRadius.circular(10.0),
                    ),
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Entre com seu Email";
                    } else if (!value.contains('@')) {
                      return "Por favor, entre com um email valido";
                    }
                    return null;
                  },
                ),
            ),

            Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Entre com a Senha",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Entre com a Senha';
                    } else if (value.length < 6) {
                      return 'Senha tem que ter mais de 6 caracteres!';
                    }
                    return null;
                  },
                ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: isLoading ? CircularProgressIndicator()
              : ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      loginFirebase();
                    }
                  },
                  child: Text('Entrar'),
            ),
            )]))));
  }

  void loginFirebase() {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((result) {
          isLoading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home(uid: result.user!.uid)),
          );
    }).catchError( (error) {
      showDialog(
          context: context,
          builder: (BuildContext contect) {
            return AlertDialog(
              title: Text("Erro"),
              content: Text(error.toString()),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"))
              ],
            );
          });
    });
  }
}

