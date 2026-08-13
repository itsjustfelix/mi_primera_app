import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_primera_app/core/json.dart';
import 'package:mi_primera_app/features/pedidos/domain/direccion.dart';
import 'package:mi_primera_app/features/pedidos/domain/estado_pedido.dart';
import 'package:mi_primera_app/features/pedidos/domain/pedido.dart';

Pedido ejemplo({EstadoPedido? estado, List<String>? platos, String? notas}) =>
    Pedido(
      id: "pedido-123",
      cliente: "Felix",
      direccion: Direccion(calle: "Calle 123", barrio: "Barrio 456"),
      creadoEn: DateTime.utc(2026, 8, 13, 14, 0),
      estado: estado ?? Recibido(DateTime.utc(2026, 8, 13, 14, 0)),
      platos: platos ?? ["Salchipapa", "Perro"],
      notas: notas,
    );

void main() {
  group('serialización', () {
    test('un pedido sobrevive la ida y vuelta a JSON sin perder nada', () {
      final original = ejemplo(
        estado: EnCamino('Carlos Diaz', 'ABC-123'),
        platos: const ['Pizza margarita', 'Jugo de mora'],
        notas: 'Sin cebolla en la pizza.',
      );

      final texto = jsonEncode(original.toJson());
      final vuelta = Pedido.desdeJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );

      expect(vuelta, equals(original));
    });

    test('un pedido sin la clave notas se lee con notas nula', () {
      final json = ejemplo().toJson()..remove('notas');
      expect(Pedido.desdeJson(json).notas, isNull);
    });

    test('un pedido sin cliente dice QUÉ campo falló, no solo que falló', () {
      final json = ejemplo().toJson()..remove('cliente');

      expect(
        () => Pedido.desdeJson(json),
        throwsA(
          isA<CampoInvalido>().having((e) => e.campo, 'campo', 'cliente'),
        ),
      );
    });

    test('una fecha que no es ISO 8601 se rechaza', () {
      final json = ejemplo().toJson()..['creadoEn'] = '13 de agosto';
      expect(() => Pedido.desdeJson(json), throwsA(isA<CampoInvalido>()));
    });

    test('la hora se conserva en UTC y no se corre cinco horas', () {
      final json = ejemplo().toJson();
      expect(json['creadoEn'], '2026-08-13T14:00:00.000Z');
    });
  });

  group('igualdad', () {
    test('dos pedidos con los mismos datos son iguales', () {
      expect(ejemplo(), equals(ejemplo()));
    });

    test('dos pedidos con los mismos datos comparten hashCode', () {
      expect(ejemplo().hashCode, equals(ejemplo().hashCode));
      expect({ejemplo(), ejemplo()}.length, 1);
    });

    test('dos pedidos con platos distintos NO son iguales', () {
      expect(
        ejemplo(platos: const ['Pizza']),
        isNot(equals(ejemplo(platos: const ['Sushi']))),
      );
    });

    test('copyWith cambia solo lo que se le pasa', () {
      final original = ejemplo();
      final copia = original.copyWith(cliente: 'Otro cliente');

      expect(copia.cliente, 'Otro cliente');
      expect(copia.id, original.id);
      expect(copia.creadoEn, original.creadoEn);
    });
  });

  group('reglas de negocio', () {
    test('un pedido en camino no se puede cancelar', () {
      expect(
        ejemplo(estado: EnCamino('Carlos Diaz', 'ABC-123')).sePuedeCancelar,
        isFalse,
      );
    });

    test('un pedido recién recibido sí se puede cancelar', () {
      expect(
        ejemplo(
          estado: Recibido(DateTime.utc(2026, 8, 13, 14, 0)),
        ).sePuedeCancelar,
        isTrue,
      );
    });

    test('un pedido de hace más de 2 horas tardó más del límite', () {
      final ahora = DateTime.utc(2026, 8, 13, 16, 30);
      expect(ejemplo().tardoMasDe(ahora, const Duration(hours: 2)), isTrue);
    });
  });
}
