import 'package:trend_vocab/src/entity/expression.dart';

final class Quiz {
  final Expression expression;
  final List<String> possibleVariants;

  Quiz({required this.expression, required this.possibleVariants});
}
