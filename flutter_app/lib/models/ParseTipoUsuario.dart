class ParseTipoUsuario {

  String parseUser(String user) {
    switch(user) {
      case "Student":
        return "Estudante";
      case "School":
        return "Escola";
      case "Parents":
        return "Responsavel";
      case "Teacher":
        return "Professor";
      default:
        return "";
    }
  }
}