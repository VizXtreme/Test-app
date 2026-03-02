import '../../domain/entities/calculation.dart';
import '../../domain/repositories/calculator_repository.dart';
import '../datasources/calculator_datasource.dart';

class CalculatorRepositoryImpl implements CalculatorRepository {
  final CalculatorDataSource _dataSource;
  final List<Calculation> _history = [];

  CalculatorRepositoryImpl(this._dataSource);

  @override
  Calculation calculate(String expression) {
    final result = _dataSource.calculate(expression);
    final calculation = Calculation(expression: expression, result: result);
    if (_history.length >= 50) {
      _history.removeAt(0);
    }
    _history.add(calculation);
    return calculation;
  }

  @override
  void clearHistory() {
    _history.clear();
  }

  @override
  List<Calculation> getHistory() {
    return List.unmodifiable(_history.reversed);
  }
}
