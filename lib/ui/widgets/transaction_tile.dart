import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback onDelete;

  const TransactionTile({required this.transaction, required this.onDelete});

  IconData _getIconData(String? iconString) {
    switch(iconString) {
      case 'attach_money': return Icons.attach_money;
      case 'trending_up': return Icons.trending_up;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'home': return Icons.home;
      case 'receipt': return Icons.receipt;
      case 'directions_car': return Icons.directions_car;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGelir = transaction['category_type'] == 1;
    final amountColor = isGelir ? Colors.green[700] : Colors.red[700];
    final amountPrefix = isGelir ? '+' : '-';
    
    final date = DateTime.parse(transaction['date']);
    final formattedDate = DateFormat('dd.MM.yyyy').format(date);
    final iconData = _getIconData(transaction['category_icon']);

    return Dismissible(
      key: Key(transaction['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isGelir ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: amountColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['category_name'],
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$formattedDate${transaction['note'] != null && transaction['note'].isNotEmpty ? ' • ${transaction['note']}' : ''}',
                    style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              '$amountPrefix ₺${transaction['amount'].toStringAsFixed(2)}',
              style: GoogleFonts.inter(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
