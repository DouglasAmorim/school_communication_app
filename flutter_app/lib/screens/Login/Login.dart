import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tcc_ifsc/Enums/SelectedLoginEnum.dart';
import 'package:tcc_ifsc/components/Editor.dart';
import 'package:tcc_ifsc/models/ApiImplementations/ApiImpl.dart';
import 'package:tcc_ifsc/models/Users/Estudante.dart';
import 'package:tcc_ifsc/models/Users/Parents.dart';
import 'package:tcc_ifsc/models/Users/Professor.dart';
import 'package:tcc_ifsc/screens/Dashboard/ParentsDashboard.dart';
import 'package:tcc_ifsc/screens/Dashboard/StudentsDashboard.dart';
import 'package:tcc_ifsc/screens/Dashboard/TeacherDashboard.dart';

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

    // TODO: Tratar Retorno da API
    switch(widget.loginUser) {
      case SelectedLoginUser.parents:
        Future<Parents> parents = ApiImpl().parentsLogin(username!, password!).then((value) {
          _openParentDashboard(context, value);
          return value;
        }, onError: (e) {
          return e;
        });

        break;
      case SelectedLoginUser.school:
        break;
      case SelectedLoginUser.teacher:
        Future<Professor> teacher = ApiImpl().teacherLogin(username!, password!).then((value) {
          _openDashboard(context, value);
          return value;
        }, onError: (e) {
          return e;
        });
        break;
      case SelectedLoginUser.student:
        Future<Estudante> student = ApiImpl().studentLogin(username!, password!).then((value) {
          _openStudentDashboard(context, value);
          return value;
        }, onError: (e) {
          return e;
        });
        break;
    }
  }

  void _openDashboard(BuildContext context, Professor teacher) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TeacherDashboard(teacher: teacher,);
    }));
  }

  void _openStudentDashboard(BuildContext context, Estudante estudante) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StudentsDashboard(estudante: estudante,);
    }));
  }

  void _openParentDashboard(BuildContext context, Parents parents) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ParentsDashboard(parents: parents,);
    }));
  }

}