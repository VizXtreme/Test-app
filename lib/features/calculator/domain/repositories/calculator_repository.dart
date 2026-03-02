import '../entities/calculation.dart';

abstract class CalculatorRepository {
  Calculation calculate(String expression);
  void clearHistory();
  List<Calculation> getHistory();
}
