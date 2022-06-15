import 'package:flutter/cupertino.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';

class UserData {
  String id = '';
  String type = '';
  String turma = ''; // TODO: Trocar por um vetor ?
  String matricula = '';
  String name = '';
  String username = '';

  static final UserData shared = UserData._internal();

  factory UserData() {
    return shared;
  }

  UserData._internal();
}