class CalculatorDataSource {
  double _evalExpression(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

    return _parseExpression(expression);
  }

  double _parseExpression(String expr) {
    expr = expr.replaceAll(' ', '');

    if (expr.isEmpty) return 0;

    double result = 0;
    String currentNum = '';
    String? lastOp;
    List<double> numbers = [];
    List<String> operators = [];

    for (int i = 0; i < expr.length; i++) {
      String char = expr[i];

      if (_isDigit(char) || char == '.') {
        currentNum += char;
      } else if (_isOperator(char)) {
        if (currentNum.isNotEmpty) {
          numbers.add(double.tryParse(currentNum) ?? 0);
          currentNum = '';
        }
        if (char == '-' && (i == 0 || _isOperator(expr[i - 1]))) {
          currentNum += char;
        } else {
          operators.add(char);
        }
      }
    }

    if (currentNum.isNotEmpty) {
      numbers.add(double.tryParse(currentNum) ?? 0);
    }

    if (numbers.isEmpty) return 0;
    if (numbers.length == 1) return numbers[0];

    result = numbers[0];
    for (int i = 0; i < operators.length && i + 1 < numbers.length; i++) {
      switch (operators[i]) {
        case '+':
          result += numbers[i + 1];
          break;
        case '-':
          result -= numbers[i + 1];
          break;
        case '*':
          result *= numbers[i + 1];
          break;
        case '/':
          if (numbers[i + 1] != 0) {
            result /= numbers[i + 1];
          }
          break;
      }
    }

    return result;
  }

  bool _isDigit(String char) {
    return char.contains(RegExp(r'[0-9]'));
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '*' || char == '/';
  }

  String calculate(String expression) {
    if (expression.isEmpty) return '0';

    try {
      final result = _evalExpression(expression);
      if (result == result.truncate()) {
        return result.truncate().toString();
      }
      return result
          .toStringAsFixed(8)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    } catch (e) {
      return 'Error';
    }
  }
}
