import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/category.dart';
import '../widgets/finance_inherited_widget.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  int _selectedType = 0; // 0 for Gider, 1 for Gelir
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  FinanceCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF3F51B5),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
    final financeState = FinanceProvider.of(context);

    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text('İşlem Ekle', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() { _selectedType = 0; _selectedCategory = null; }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _selectedType == 0 ? Colors.redAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text('Giderler', style: GoogleFonts.inter(
                            color: _selectedType == 0 ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() { _selectedType = 1; _selectedCategory = null; }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _selectedType == 1 ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text('Gelirler', style: GoogleFonts.inter(
                            color: _selectedType == 1 ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildInputField(
              controller: _amountController,
              label: 'Tutar',
              icon: Icons.attach_money,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            ValueListenableBuilder<List<FinanceCategory>>(
              valueListenable: financeState.categoriesNotifier,
              builder: (context, categories, child) {
                final filteredCategories = categories.where((c) => c.type == _selectedType).toList();
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<FinanceCategory>(
                      isExpanded: true,
                      hint: Text('Kategori', style: GoogleFonts.inter(color: Colors.grey[600])),
                      value: _selectedCategory,
                      items: filteredCategories.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Row(
                            children: [
                              Icon(_getIconData(c.icon), color: Colors.grey[600], size: 20),
                              SizedBox(width: 12),
                              Text(c.name, style: GoogleFonts.inter(fontSize: 16)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                    SizedBox(width: 12),
                    Text(
                      DateFormat('dd.MM.yyyy').format(_selectedDate),
                      style: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: _noteController,
              label: 'Not (Opsiyonel)',
              icon: Icons.note,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Color(0xFF3F51B5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () => _saveTransaction(financeState),
              child: Text('Kaydet', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600])),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String label, required IconData icon, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  void _saveTransaction(financeState) async {
    final amountText = _amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(amountText);
    
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lütfen geçerli bir tutar girin.')));
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lütfen bir kategori seçin.')));
      return;
    }

    await financeState.addTransaction(
      amount,
      _selectedCategory!.id!,
      _selectedDate.toIso8601String(),
      _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    Navigator.pop(context);
  }
}
