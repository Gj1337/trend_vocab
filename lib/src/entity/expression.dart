final class Expression {
  final String name;
  final String image;
  final String audio;
  final List<String> examples;

  Expression({
    required this.name,
    required this.image,
    required this.audio,
    required this.examples,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expression &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image &&
          audio == other.audio;

  @override
  int get hashCode =>
      name.hashCode ^
      image.hashCode ^
      audio.hashCode ^
      Object.hashAll(examples);

  @override
  String toString() =>
      'Expression{'
      'name: $name, '
      'image: $image, '
      'audio: $audio, '
      'examples: $examples'
      '}';
}
