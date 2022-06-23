import '../Helpers/Strings.dart';

class ParseTipoUsuario {

  String parseUser(String user) {
    switch(user) {
      case Strings.userStudent:
        return Strings.userStudentParsed;
      case Strings.userTeachingDirection:
        return Strings.userTeachingDirectionParsed;
      case Strings.userParents:
        return Strings.userParentsParsed;
      case Strings.userTeacher:
        return Strings.userTeacherParsed;
      case Strings.userPedagogicalSector:
        return Strings.userPedagogicalSectorParsed;
      default:
        return "";
    }
  }
}