import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';

class UserData {
  String id = '';
  String type = '';
  List<String> turma = [];
  String matricula = '';
  String name = '';
  String username = '';
  String valid = '';
  List<Grupos> grupos = [];

  static final UserData shared = UserData._internal();

  factory UserData() {
    return shared;
  }

  UserData._internal();
}

class Grupos extends Equatable {
  String nome = '';
  String queue = '';
  List<String> tipoGrupo = [];
  List<String> turma = [];

  @override
  List<Object?> get props => [nome, queue, tipoGrupo, turma];
}

class ContactData extends Equatable {
  String id = '';
  String type = '';
  List<String> turma = [];
  String name = '';
  String username = '';
  List<EstruturaMensagem> messages = [];

  @override
  List<Object?> get props => [id, type, turma, name, username, messages];
}