import 'package:mi_primera_app/features/pedidos/domain/pedido.dart';

abstract class PedidosRepository {
  Future<List<Pedido>> obtenerTodos();
  Future<Pedido?> obtenerPorId(String id);
}
