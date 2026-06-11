import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/category.dart';
import '../widgets/finance_inherited_widget.dart';

class CategoriesScreen extends StatelessWidget {
  IconData _getIconData(String? iconString) {
    switch(iconString) {
      case 'attach_money': return Icons.attach_money;
      case 'trending_up': return Icons.trending_up;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'home': return Icons.home;
      case 'receipt': return Icons.receipt;
      case 'directions_car': return Icons.directions_car;
      case 'fastfood': return Icons.fastfood;
      case 'local_hospital': return Icons.local_hospital;
      case 'school': return Icons.school;
      default: return Icons.category;
    }
  }

  void _showAddCategoryDialog(BuildContext context, financeState) {
    final nameController = TextEditingController();
    int type = 0;
    String selectedIcon = 'category';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Yeni Kategori', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Kategori Adı'),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          label: Text('Gider'),
                          selected: type == 0,
                          onSelected: (val) => setState(() => type = 0),
                        ),
                        ChoiceChip(
                          label: Text('Gelir'),
                          selected: type == 1,
                          onSelected: (val) => setState(() => type = 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: ['attach_money', 'shopping_cart', 'home', 'receipt', 'directions_car', 'fastfood', 'local_hospital', 'school', 'category'].map((icon) {
                        return ChoiceChip(
                          label: Icon(_getIconData(icon), size: 20),
                          selected: selectedIcon == icon,
                          onSelected: (val) => setState(() => selectedIcon = icon),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty) {
                      await financeState.addCategory(nameController.text, type, selectedIcon);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Ekle'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final financeState = FinanceProvider.of(context);

    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text('Kategoriler', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Color(0xFF3F51B5)),
            onPressed: () => _showAddCategoryDialog(context, financeState),
          )
        ],
      ),
      body: ValueListenableBuilder<List<FinanceCategory>>(
        valueListenable: financeState.categoriesNotifier,
        builder: (context, categories, child) {
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final c = categories[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(_getIconData(c.icon), color: c.type == 1 ? Colors.green : Colors.redAccent),
                  title: Text(c.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  subtitle: Text(c.type == 1 ? 'Gelir' : 'Gider', style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 12)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      String? error = await financeState.deleteCategory(c.id!);
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
