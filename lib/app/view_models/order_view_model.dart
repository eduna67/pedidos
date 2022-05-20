
import 'order_item_view_model.dart';

class OrderViewModel {
  final int usuarioId;
  final String? transacaoId;
  final String? cpf_cliente;
  final String endereco_entrega;
  final String status_pedido = 'PENDENTE';
  final List<OrderItemViewModel> items;
}