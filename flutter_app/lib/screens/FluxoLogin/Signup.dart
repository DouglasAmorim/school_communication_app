import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'EmailLogin.dart';
import 'EmailSignup.dart';

class SignUp extends StatelessWidget {
  final String title = "Cadastrar";

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(this.title),
    ),
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget> [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Comunica IFSC",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'Roboto')),
        ),

        Padding(
            padding: EdgeInsets.all(10.0),
            child: SignInButton(
              Buttons.Email,
              text: "Cadastre-se com E-mail",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailSignUp()),
                );
              },
            )),

        Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              child: Text( "Entre Usando seu Email",
                style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.green
                ),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailLogIn()),
                );
              },
            ),
        )

      ],),
    ),

  );
  }
}