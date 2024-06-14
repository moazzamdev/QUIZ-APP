class QuizInfo {
  final String title;
  final String quizId;
  int score;
  bool isCompleted = false;
  final String level = 'level3';

  QuizInfo(
      {required this.title,
      required this.quizId,
      required this.score,
      required this.isCompleted});
}

List<QuizInfo> quizzes = [
  QuizInfo(title: 'Quiz 1', quizId: 'quiz20', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 2', quizId: 'quiz21', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 3', quizId: 'quiz22', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 4', quizId: 'quiz23', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 5', quizId: 'quiz24', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 6', quizId: 'quiz25', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 7', quizId: 'quiz26', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 8', quizId: 'quiz27', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 9', quizId: 'quiz28', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 10', quizId: 'quiz29', score: 0, isCompleted: false),
];
