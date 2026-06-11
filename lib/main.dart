import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/finance_state.dart';
import 'ui/widgets/finance_inherited_widget.dart';
import 'ui/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  final FinanceState financeState = FinanceState();

  @override
  Widget build(BuildContext context) {
    return FinanceProvider(
      financeState: financeState,
      child: MaterialApp(
        title: 'Kişisel Finans',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
