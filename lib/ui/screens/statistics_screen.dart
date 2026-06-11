import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/finance_inherited_widget.dart';
import '../widgets/native_pie_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final List<String> _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  String _formatMonth(DateTime date) {
    return '${_months[date.month - 1]} ${date.year}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final financeState = FinanceProvider.of(context);

    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(financeState),
            Expanded(
              child: _buildChartAndLegend(financeState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(financeState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.grey[800]),
                onPressed: () => financeState.changeMonth(-1),
              ),
              ValueListenableBuilder<DateTime>(
                valueListenable: financeState.selectedMonth,
                builder: (context, date, child) {
                  return Text(
                    _formatMonth(date),
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.grey[800]),
                onPressed: () => financeState.changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Aylık Gider Dağılımı', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildChartAndLegend(financeState) {
    return ValueListenableBuilder<Map<String, double>>(
      valueListenable: financeState.categoryExpenses,
      builder: (context, expenses, child) {
        if (expenses.isEmpty) {
          return Center(
            child: Text(
              'Bu ay için gider bulunmuyor.',
              style: GoogleFonts.inter(color: Colors.grey[500]),
            ),
          );
        }

        double total = expenses.values.fold(0, (sum, val) => sum + val);

        return Column(
          children: [
            SizedBox(height: 20),
            NativePieChart(data: expenses),
            SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  String key = expenses.keys.elementAt(index);
                  double value = expenses[key]!;
                  double percentage = (value / total) * 100;
                  
                  List<Color> colors = [
                    Colors.redAccent, Colors.blueAccent, Colors.orangeAccent, 
                    Colors.purpleAccent, Colors.teal, Colors.pinkAccent,
                    Colors.amber, Colors.cyan
                  ];
                  Color color = colors[index % colors.length];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 16, height: 16,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(key, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        Text('₺${value.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 16),
                        Text('${percentage.toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
