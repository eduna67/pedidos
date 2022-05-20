import 'dart:convert';

import 'package:selects_api/app/core/entities/order_item.dart';
import 'package:selects_api/app/core/entities/user.dart';

class Order {
  final int id;
  final User user;
  final String? id_transacao;
  final String? cpf_cliente;
  final String endereco_entrega;
  final String status_pedido = 'PENDENTE';
  final List<OrderItem> items;
  Order({
    required this.id,
    required this.user,
    this.id_transacao,
    this.cpf_cliente,
    required this.endereco_entrega,
    required this.items,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'id_transacao': id_transacao,
      'cpf_cliente': cpf_cliente,
      'endereco_entrega': endereco_entrega,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toInt() ?? 0,
      user: User.fromMap(map['user']),
      id_transacao: map['id_transacao'],
      cpf_cliente: map['cpf_cliente'],
      endereco_entrega: map['endereco_entrega'] ?? '',
      items: List<OrderItem>.from(map['items']?.map((x) => OrderItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
 }
