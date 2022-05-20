import 'dart:convert';

class OrderItem {
  final int id;
  final String quantidade;
  final int produtoId;
  OrderItem({
    required this.id,
    required this.quantidade,
    required this.produtoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantidade': quantidade,
      'produtoId': produtoId,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id']?.toInt() ?? 0,
      quantidade: map['quantidade'] ?? '',
      produtoId: map['produtoId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) => OrderItem.fromMap(json.decode(source));
}
