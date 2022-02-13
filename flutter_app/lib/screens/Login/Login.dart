import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tcc_ifsc/Enums/SelectedLoginEnum.dart';
import 'package:tcc_ifsc/components/Editor.dart';
import 'package:tcc_ifsc/models/ApiImpl.dart';

const _tituloAppBar = 'Login Screen';
const _rotuloCampoUserName = 'Nome de Usuário';
const _rotuloCampoPassword = 'Senha';
const _textLoginButton = 'Entrar';

class Login extends StatefulWidget {
  final SelectedLoginUser loginUser;
  Login({Key? key, required this.loginUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Editor(controller: _controllerUsername, rotulo: _rotuloCampoUserName ),
            Editor(controller: _controllerPassword, rotulo: _rotuloCampoPassword ),

            ElevatedButton(
              onPressed: () => _login(context),
              child: Text(_textLoginButton),
            ),
          ],
        ),
      ),

    );
  }

  void _login(BuildContext context) {

    final String? username = _controllerUsername.text;
    final String? password = _controllerPassword.text;

    switch(widget.loginUser) {
      case SelectedLoginUser.parents:
        ApiImpl().parentsLogin(username!, password!);
        break;
      case SelectedLoginUser.school:
        break;
      case SelectedLoginUser.teacher:
        ApiImpl().teacherLogin(username!, password!);
        break;
      case SelectedLoginUser.student:
        ApiImpl().studentLogin(username!, password!);
        break;
    }

    // ApiImpl().login()
    //
    // final transferenciaCriada = Transferencia(value!,numberAccount!);
    // debugPrint('$transferenciaCriada');
    // Navigator.pop(context, transferenciaCriada);
  }

}