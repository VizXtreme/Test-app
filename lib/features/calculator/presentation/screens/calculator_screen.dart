import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/calculator_controller.dart';
import '../widgets/calculator_button.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surface,
                colorScheme.surfaceContainerHighest.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            children: [
              _buildDisplay(context, state, notifier),
              Expanded(child: _buildKeypad(context, state, notifier)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay(
    BuildContext context,
    CalculatorState state,
    CalculatorNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -300) {
          notifier.toggleHistory();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  ),
                );
              },
              child: Text(
                state.displayValue,
                key: ValueKey(state.displayValue),
                style: theme.textTheme.displayLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.expression.isNotEmpty &&
                state.expression != state.displayValue) ...[
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: 0.7,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  state.expression,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            if (state.showHistory && state.history.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  reverse: true,
                  itemCount: state.history.length > 5
                      ? 5
                      : state.history.length,
                  itemBuilder: (context, index) {
                    final calc = state.history[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '${calc.expression} = ${calc.result}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(
    BuildContext context,
    CalculatorState state,
    CalculatorNotifier notifier,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  label: 'C',
                  onPressed: notifier.clear,
                  backgroundColor: colorScheme.tertiaryContainer,
                  foregroundColor: colorScheme.onTertiaryContainer,
                ),
                CalculatorButton(
                  label: 'CE',
                  onPressed: notifier.clearEntry,
                  backgroundColor: colorScheme.tertiaryContainer,
                  foregroundColor: colorScheme.onTertiaryContainer,
                ),
                CalculatorButton(
                  label: '⌫',
                  onPressed: notifier.deleteLast,
                  backgroundColor: colorScheme.tertiaryContainer,
                  foregroundColor: colorScheme.onTertiaryContainer,
                ),
                CalculatorButton(
                  label: '÷',
                  onPressed: () => notifier.appendOperator('÷'),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  label: '7',
                  onPressed: () => notifier.appendDigit('7'),
                ),
                CalculatorButton(
                  label: '8',
                  onPressed: () => notifier.appendDigit('8'),
                ),
                CalculatorButton(
                  label: '9',
                  onPressed: () => notifier.appendDigit('9'),
                ),
                CalculatorButton(
                  label: '×',
                  onPressed: () => notifier.appendOperator('×'),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  label: '4',
                  onPressed: () => notifier.appendDigit('4'),
                ),
                CalculatorButton(
                  label: '5',
                  onPressed: () => notifier.appendDigit('5'),
                ),
                CalculatorButton(
                  label: '6',
                  onPressed: () => notifier.appendDigit('6'),
                ),
                CalculatorButton(
                  label: '-',
                  onPressed: () => notifier.appendOperator('-'),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  label: '1',
                  onPressed: () => notifier.appendDigit('1'),
                ),
                CalculatorButton(
                  label: '2',
                  onPressed: () => notifier.appendDigit('2'),
                ),
                CalculatorButton(
                  label: '3',
                  onPressed: () => notifier.appendDigit('3'),
                ),
                CalculatorButton(
                  label: '+',
                  onPressed: () => notifier.appendOperator('+'),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  label: '.',
                  onPressed: () => notifier.appendDigit('.'),
                ),
                CalculatorButton(
                  label: '0',
                  onPressed: () => notifier.appendDigit('0'),
                ),
                CalculatorButton(
                  label: '=',
                  onPressed: notifier.calculate,
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
