import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

class CalculateUseCase {
  final CalculatorRepository repository;

  CalculateUseCase(this.repository);

  Calculation execute(String expression) {
    return repository.calculate(expression);
  }

  List<Calculation> getHistory() {
    return repository.getHistory();
  }

  void clearHistory() {
    repository.clearHistory();
  }
}
