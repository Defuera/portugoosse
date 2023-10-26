String? retrieveUserText([List<String>? args]) {
  if (args != null) {
    final arguments = List<String>.from(args);
    final text = arguments.reduce((acc, word) => "$acc $word");
    return text;
  } else {
    return null;
  }
}
