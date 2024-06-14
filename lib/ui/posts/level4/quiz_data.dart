class QuizInfo {
  final String title;
  final String quizId;
  int score;
  bool isCompleted = false;
  final String level = 'level4';

  QuizInfo(
      {required this.title,
      required this.quizId,
      required this.score,
      required this.isCompleted});
}

List<QuizInfo> quizzes = [
  QuizInfo(title: 'Quiz 1', quizId: 'quiz30', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 2', quizId: 'quiz31', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 3', quizId: 'quiz32', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 4', quizId: 'quiz33', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 5', quizId: 'quiz34', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 6', quizId: 'quiz35', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 7', quizId: 'quiz36', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 8', quizId: 'quiz37', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 9', quizId: 'quiz38', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 10', quizId: 'quiz39', score: 0, isCompleted: false),
];
