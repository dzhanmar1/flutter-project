import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceCard extends StatelessWidget {
  final double bakiye;
  final double gelir;
  final double gider;

  const BalanceCard({
    required this.bakiye,
    required this.gelir,
    required this.gider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF283593), Color(0xFF3F51B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3F51B5).withOpacity(0.4),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Toplam Bakiye',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            '₺${bakiye.toStringAsFixed(2)}',
            style: GoogleFonts.inter(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniCard('Gelirler', gelir, Icons.arrow_downward, Colors.greenAccent),
              _buildMiniCard('Giderler', gider, Icons.arrow_upward, Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(String title, double amount, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            Text(
              '₺${amount.toStringAsFixed(2)}',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
