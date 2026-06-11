import 'package:flutter/material.dart';
import '../../services/finance_state.dart';

class FinanceProvider extends InheritedWidget {
  final FinanceState financeState;

  const FinanceProvider({
    Key? key,
    required this.financeState,
    required Widget child,
  }) : super(key: key, child: child);

  static FinanceState of(BuildContext context) {
    final FinanceProvider? result = context.dependOnInheritedWidgetOfExactType<FinanceProvider>();
    assert(result != null, 'No FinanceProvider found in context');
    return result!.financeState;
  }

  @override
  bool updateShouldNotify(FinanceProvider oldWidget) => false;
}
