class QuizInfo {
  final String title;
  final String quizId;
  int score;
  bool isCompleted = false;
  final String level = 'level2';

  QuizInfo(
      {required this.title,
      required this.quizId,
      required this.score,
      required this.isCompleted});
}

List<QuizInfo> quizzes = [
  QuizInfo(title: 'Quiz 1', quizId: 'quiz10', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 2', quizId: 'quiz11', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 3', quizId: 'quiz12', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 4', quizId: 'quiz13', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 5', quizId: 'quiz14', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 6', quizId: 'quiz15', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 7', quizId: 'quiz16', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 8', quizId: 'quiz17', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 9', quizId: 'quiz18', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 10', quizId: 'quiz19', score: 0, isCompleted: false),
];
