sealed class QuizControllerException implements Exception {}

class QuizNotInitializedException implements QuizControllerException {}

class QuizListIsEmptyException implements QuizControllerException {}
