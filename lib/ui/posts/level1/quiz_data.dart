class QuizInfo {
  final String title;
  final String quizId;
  int score;
  bool isCompleted = false;
  final String level = 'level1';

  QuizInfo(
      {required this.title,
      required this.quizId,
      required this.score,
      required this.isCompleted});
}

List<QuizInfo> quizzes = [
  QuizInfo(title: 'Quiz 1', quizId: 'quiz101', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 2', quizId: 'quiz1', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 3', quizId: 'quiz2', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 4', quizId: 'quiz3', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 5', quizId: 'quiz4', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 6', quizId: 'quiz5', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 7', quizId: 'quiz6', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 8', quizId: 'quiz7', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 9', quizId: 'quiz8', score: 0, isCompleted: false),
  QuizInfo(title: 'Quiz 10', quizId: 'quiz9', score: 0, isCompleted: false),
];
