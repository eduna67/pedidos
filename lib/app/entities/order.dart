import 'dart:convert';

import 'package:selects_api/app/entities/order_item.dart';
import 'package:selects_api/app/entities/user.dart';

class Order {
  final int id;
  final User usuario;
  final String? idTransacao;
  final String? cpfCliente;
  final String enderecoEntrega;
  final String statusPedido = 'PENDENTE';
  final List<OrderItem> items;
  Order({
    required this.id,
    required this.usuario,
    this.idTransacao,
    this.cpfCliente,
    required this.enderecoEntrega,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario.toMap(),
      'idTransacao': idTransacao,
      'cpfCliente': cpfCliente,
      'enderecoEntrega': enderecoEntrega,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toInt() ?? 0,
      usuario: User.fromMap(map['usuario']),
      idTransacao: map['idTransacao'],
      cpfCliente: map['cpfCliente'],
      enderecoEntrega: map['enderecoEntrega'] ?? '',
      items: List<OrderItem>.from(map['items']?.map((x) => OrderItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
 }
