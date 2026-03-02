import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/calculator_datasource.dart';
import '../../data/repositories/calculator_repository_impl.dart';
import '../../domain/entities/calculation.dart';
import '../../domain/repositories/calculator_repository.dart';

final calculatorDataSourceProvider = Provider<CalculatorDataSource>((ref) {
  return CalculatorDataSource();
});

final calculatorRepositoryProvider = Provider<CalculatorRepository>((ref) {
  final dataSource = ref.watch(calculatorDataSourceProvider);
  return CalculatorRepositoryImpl(dataSource);
});

class CalculatorState {
  final String expression;
  final String displayValue;
  final List<Calculation> history;
  final bool showHistory;

  const CalculatorState({
    this.expression = '',
    this.displayValue = '0',
    this.history = const [],
    this.showHistory = false,
  });

  CalculatorState copyWith({
    String? expression,
    String? displayValue,
    List<Calculation>? history,
    bool? showHistory,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      displayValue: displayValue ?? this.displayValue,
      history: history ?? this.history,
      showHistory: showHistory ?? this.showHistory,
    );
  }
}

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  final CalculatorRepository _repository;

  CalculatorNotifier(this._repository) : super(const CalculatorState());

  void appendDigit(String digit) {
    String newExpression = state.expression;

    if (state.displayValue == '0' && digit != '.') {
      newExpression = digit;
    } else if (state.displayValue == 'Error') {
      newExpression = digit;
    } else {
      newExpression = state.expression + digit;
    }

    state = state.copyWith(
      expression: newExpression,
      displayValue: newExpression,
    );
  }

  void appendOperator(String operator) {
    String newExpression = state.expression;

    if (state.displayValue == 'Error') {
      return;
    }

    if (newExpression.isNotEmpty) {
      final lastChar = newExpression[newExpression.length - 1];
      if (lastChar == '+' ||
          lastChar == '-' ||
          lastChar == '×' ||
          lastChar == '÷') {
        newExpression = newExpression.substring(0, newExpression.length - 1);
      }
    }

    newExpression = newExpression + operator;

    state = state.copyWith(
      expression: newExpression,
      displayValue: newExpression,
    );
  }

  void calculate() {
    if (state.expression.isEmpty || state.displayValue == 'Error') {
      return;
    }

    final calculation = _repository.calculate(state.expression);
    state = state.copyWith(
      displayValue: calculation.result,
      history: _repository.getHistory(),
    );
  }

  void clear() {
    state = state.copyWith(expression: '', displayValue: '0');
  }

  void clearEntry() {
    state = state.copyWith(expression: '', displayValue: '0');
  }

  void toggleHistory() {
    state = state.copyWith(
      showHistory: !state.showHistory,
      history: _repository.getHistory(),
    );
  }

  void clearHistory() {
    _repository.clearHistory();
    state = state.copyWith(history: []);
  }

  void deleteLast() {
    if (state.expression.isNotEmpty) {
      final newExpression = state.expression.substring(
        0,
        state.expression.length - 1,
      );
      state = state.copyWith(
        expression: newExpression,
        displayValue: newExpression.isEmpty ? '0' : newExpression,
      );
    }
  }
}

final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
      final repository = ref.watch(calculatorRepositoryProvider);
      return CalculatorNotifier(repository);
    });
