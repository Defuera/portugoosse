//
// class Exercise {
//   Exercise({
//     required this.word,
//     required this.phrase,
//   });
//
//   final String word;
//   final String phrase;
//
//   factory Exercise.fromJson(Map<String, dynamic> json) {
//     return Exercise(
//       word: json['word'],
//       phrase: json['phrase'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'word': word,
//       'phrase': phrase,
//     };
//   }
//
// }

typedef Exercises = Map<String, String>;