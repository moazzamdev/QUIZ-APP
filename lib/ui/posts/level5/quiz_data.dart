class QuizInfo {
  final String title;
  final String quizId;
  int score;
  bool isCompleted = false;
  final String level = 'level5';

  QuizInfo(
      {required this.title,
      required this.quizId,
      required this.score,
      required this.isCompleted});
}

List<QuizInfo> quizzes = [
  QuizInfo(title: 'Quiz 1', quizId: 'quiz40', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 2', quizId: 'quiz41', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 3', quizId: 'quiz42', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 4', quizId: 'quiz43', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 5', quizId: 'quiz44', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 6', quizId: 'quiz45', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 7', quizId: 'quiz46', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 8', quizId: 'quiz47', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 9', quizId: 'quiz48', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 10', quizId: 'quiz49', score: 0, isCompleted: false),
];
