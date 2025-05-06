import 'package:trend_vocab/src/entity/expression.dart';

abstract final class ExpressionFromJsonMapper {
  static Expression call(Map<String, dynamic> json) => Expression(
    name: json['name'] as String,
    image: json['image'] as String,
    audio: json['audio'] as String,
    examples:
        (json['examples'] as List<dynamic>)
            .map((element) => element as String)
            .toList(),
  );

  Map<String, dynamic> toJson() => throw UnimplementedError();
}
