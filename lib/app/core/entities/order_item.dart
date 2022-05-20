import 'dart:convert';

class OrderItem {
  final int id;
  final String quantidade;
  final int pedido_id;
  final int produto_id;

  OrderItem({
    required this.id,
    required this.quantidade,
    required this.pedido_id,
    required this.produto_id,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantidade': quantidade,
      'pedido_id': pedido_id,
      'produto_id': produto_id,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id']?.toInt() ?? 0,
      quantidade: map['quantidade'] ?? '',
      pedido_id: map['pedido_id']?.toInt() ?? 0,
      produto_id: map['produto_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) => OrderItem.fromMap(json.decode(source));
}
