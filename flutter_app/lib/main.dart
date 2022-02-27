import 'package:flutter/material.dart';
import 'package:tcc_ifsc/screens/Login/Login.dart';
import 'Enums/SelectedLoginEnum.dart';

void main() {
  runApp(TccIfsc());
}

class TccIfsc extends StatelessWidget {
  const TccIfsc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          accentColor: Colors.blueAccent[700],
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('TCC App')),
        body: const LoginWidget(),
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({ Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {

    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        primary: Colors.green,
        minimumSize: const Size.fromHeight(50)
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget> [
          ElevatedButton(style: style,
              onPressed: () => _openLoginScreen(context, SelectedLoginUser.student),
              child: const Text('Estudantes'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: () => _openLoginScreen(context, SelectedLoginUser.teacher),
            child: const Text('Professores'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: () => _openLoginScreen(context, SelectedLoginUser.parents),
            child: const Text('Pais'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: () => _openLoginScreen(context, SelectedLoginUser.school),
            child: const Text('Escola'),
          ),

        ],
      ),
    );
  }

  void _openLoginScreen(BuildContext context, SelectedLoginUser loginUser) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login(loginUser: loginUser,);
      }));
  }
}
