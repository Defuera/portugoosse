

extension MarkdownExtension on Map<String, String> {
  // key is word, value is phrase
  // add bold to word in phrase and return phrase as markdown
  String get toMarkdown => """Word: **${keys.first}**
  
Translate: ${values.first}""";
}