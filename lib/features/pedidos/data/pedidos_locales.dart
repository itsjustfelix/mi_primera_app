import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:mi_primera_app/core/json.dart';
import 'package:mi_primera_app/features/pedidos/domain/estado_pedido.dart';
import 'package:mi_primera_app/features/pedidos/domain/pedido.dart';
import 'package:mi_primera_app/features/pedidos/domain/pedidos_repository.dart';

typedef LectorDeAssets = Future<String> Function(String ruta);

class PedidosLocales implements PedidosRepository {
  PedidosLocales({
    LectorDeAssets? lector,
    this.ruta = 'assets/data/pedidos.json',
  }) : _lector = lector ?? rootBundle.loadString;

  final LectorDeAssets _lector;
  final String ruta;

  List<Pedido>? _cache;

  @override
  Future<Pedido?> obtenerPorId(String id) async {
    for (final pedido in await obtenerTodos()) {
      if (pedido.id == id) return pedido;
    }
    return null;
  }

  @override
  Future<List<Pedido>> obtenerTodos() async {
    final guardado = _cache;
    if (guardado != null) return guardado;

    final crudo = await _lector(ruta);
    final decodificado = jsonDecode(crudo);

    if (decodificado is! List) {
      throw const CampoInvalido(
        "(raiz)",
        "elrchivo wdebe de contener una lista",
        null,
      );
    }

    return _cache = decodificado
        .map((e) => Pedido.desdeJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Map<String, int>> contarPorEstado() async {
    final conteo = <String, int>{};
    for (final pedido in await obtenerTodos()) {
      final etiqueta = pedido.estado.etiqueta;
      conteo[etiqueta] = (conteo[etiqueta] ?? 0) + 1;
    }
    return conteo;
  }
}
