class FinanceCategory {
  final int? id;
  final String name;
  final int type;
  final String? icon;

  FinanceCategory({this.id, required this.name, required this.type, this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
    };
  }

  factory FinanceCategory.fromMap(Map<String, dynamic> map) {
    return FinanceCategory(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      icon: map['icon'],
    );
  }
}
