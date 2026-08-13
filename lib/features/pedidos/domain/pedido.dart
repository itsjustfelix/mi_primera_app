import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mi_primera_app/core/json.dart';
import 'package:mi_primera_app/features/pedidos/domain/direccion.dart';
import 'package:mi_primera_app/features/pedidos/domain/estado_pedido.dart';

part 'pedido.freezed.dart';

@freezed
abstract class Pedido with _$Pedido {
  const factory Pedido({
    required String id,
    required String cliente,
    required Direccion direccion,
    required DateTime creadoEn,
    required EstadoPedido estado,
    @Default(<String>[]) List<String> platos,
    String? notas,
  }) = _Pedido;

  const Pedido._();

  factory Pedido.desdeJson(Map<String, dynamic> json) => Pedido(
    id: leerTexto(json, 'id'),
    cliente: leerTexto(json, 'cliente'),
    direccion: Direccion.desdeJson(leerMapa(json, 'direccion')),
    creadoEn: leerFecha(json, 'creadoEn'),
    estado: EstadoPedido.desdeJson(leerMapa(json, 'estado')),
    platos: leerTextos(json, 'platos'),
    notas: leerTextoOpcional(json, 'notas'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'cliente': cliente,
    'direccion': direccion.toJson(),
    'creadoEn': creadoEn.toUtc().toIso8601String(),
    'estado': estado.toJson(),
    'platos': platos,
    if (notas != null) 'notas': notas,
  };

  bool get tieneNota => notas != null;
  bool get sePuedeCancelar => estado.sePuedeCancelar;
  Duration antiguedad(DateTime ahora) => ahora.difference(creadoEn);
  bool tardoMasDe(DateTime ahora, Duration limite) =>
      antiguedad(ahora) > limite;
}
