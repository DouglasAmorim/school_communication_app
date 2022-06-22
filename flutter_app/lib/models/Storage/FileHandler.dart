import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';
import 'package:tcc_ifsc/models/EstruturaNoticia.dart';

class FileHandler {
  FileHandler._privateConstructor();
  static final FileHandler instance = FileHandler._privateConstructor();

  static File? _file;
  static final _fileName = 'message_file.txt';
  static Set<EstruturaMensagem> _messageSet = {};

  static File? _fileNoticia;
  static final _fileNoticiaName = 'noticia_file.txt';
  static Set<EstruturaNoticia> _noticiaeSet = {};

  // Get the data file
  Future<File> get file async {
    if (_file != null) return _file!;

    _file = await _initFile(_fileName);
    return _file!;
  }

  // Get the data file
  Future<File> get fileNotica async {
    if (_fileNoticia != null) return _fileNoticia!;

    _fileNoticia = await _initFile(_fileNoticiaName);
    return _fileNoticia!;
  }

  // Inititalize file
  Future<File> _initFile(String name) async {
    final _directory = await getApplicationDocumentsDirectory();
    final _path = _directory.path;
    return File('$_path/$name');
  }

  Future<void> writeNoticia(EstruturaNoticia message) async {
    final List<EstruturaNoticia> messages = await readNoticia();
    messages.add(message);

    final File fl = await fileNotica;

    final _estruturaListMap = messages.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(_estruturaListMap));
  }

  Future<List<EstruturaNoticia>> readNoticia() async {
    final File fl = await fileNotica;
    fl.create(recursive: true);

    final _content = await fl.readAsString();

    final List<dynamic> _jsonData = jsonDecode(_content);
    final List<EstruturaNoticia> _messages = _jsonData.map((e) => EstruturaNoticia.fromJSON(e as Map<String, dynamic>),).toList();

    return _messages;
  }

  Future<void> writeMessages(EstruturaMensagem message) async {
    final List<EstruturaMensagem> messages = await readMessages();
    messages.add(message);

    final File fl = await file;

    final _estruturaListMap = messages.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(_estruturaListMap));
  }

  Future<List<EstruturaMensagem>> readMessages() async {
    final File fl = await file;
    fl.createSync(recursive: true);

    final _content = await fl.readAsString();

    final List<dynamic> _jsonData = jsonDecode(_content);
    final List<EstruturaMensagem> _messages = _jsonData.map((e) => EstruturaMensagem.fromJSON(e as Map<String, dynamic>),).toList();

    return _messages;
  }

  Future<void> deleteMessages(EstruturaMensagem message) async {
    final File fl = await file;

    _messageSet.removeWhere((e) => e == message);
    final _messageListMap = _messageSet.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(_messageListMap));
  }

  Future<void> updateMessage({
    required int id,
    required EstruturaMensagem updatedMessage,
  }) async {
    _messageSet.removeWhere((e) => (e.message == updatedMessage.message)
        && (e.receiverId == updatedMessage.receiverId)
        && (e.senderId == updatedMessage.senderId));
    await writeMessages(updatedMessage);
  }
}