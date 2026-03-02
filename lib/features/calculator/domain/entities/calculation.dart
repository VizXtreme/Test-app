class Calculation {
  final String expression;
  final String result;
  final DateTime timestamp;

  Calculation({
    required this.expression,
    required this.result,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => '$expression = $result';
}
