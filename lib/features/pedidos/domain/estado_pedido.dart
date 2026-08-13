import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mi_primera_app/core/json.dart';

part 'estado_pedido.freezed.dart';

@freezed
sealed class EstadoPedido with _$EstadoPedido {
  const factory EstadoPedido.recibido(DateTime horaRecibido) = Recibido;
  const factory EstadoPedido.preparando(String tiempoEstimado) = Preparando;
  const factory EstadoPedido.enCamino(String repartidor, String placaVehiculo) =
      EnCamino;
  const factory EstadoPedido.entregado(DateTime horaEntrega) = Entregado;
  const factory EstadoPedido.cancelado(String motivo) = Cancelado;

  factory EstadoPedido.desdeJson(Map<String, dynamic> json) {
    final tipo = leerTexto(json, 'tipo');
    return switch (tipo) {
      'recibido' => Recibido(leerFecha(json, 'horaRecibido')),
      'preparando' => Preparando(leerTexto(json, 'tiempoEstimado')),
      'en_camino' => EnCamino(
        leerTexto(json, 'repartidor'),
        leerTexto(json, 'placaVehiculo'),
      ),
      'entregado' => Entregado(leerFecha(json, 'horaEntrega')),
      'cancelado' => Cancelado(leerTexto(json, 'motivo')),
      _ => throw CampoInvalido('estado.tipo', 'no es un estado conocido', tipo),
    };
  }
}

extension EstadoPedidoReglas on EstadoPedido {
  bool get sePuedeCancelar => switch (this) {
    Recibido() || Preparando() => true,
    EnCamino() || Entregado() || Cancelado() => false,
  };

  String get etiqueta => switch (this) {
    Recibido() => 'Recibido',
    Preparando(:final tiempoEstimado) => 'Preparando · $tiempoEstimado',
    EnCamino(:final repartidor, :final placaVehiculo) =>
      'En camino · $repartidor ($placaVehiculo)',
    Entregado() => 'Entregado',
    Cancelado(:final motivo) => 'Cancelado: $motivo',
  };

  Map<String, dynamic> toJson() => switch (this) {
    Recibido(:final horaRecibido) => {
      'tipo': 'recibido',
      'horaRecibido': horaRecibido.toIso8601String(),
    },
    Preparando(:final tiempoEstimado) => {
      'tipo': 'preparando',
      'tiempoEstimado': tiempoEstimado,
    },
    EnCamino(:final repartidor, :final placaVehiculo) => {
      'tipo': 'en_camino',
      'repartidor': repartidor,
      'placaVehiculo': placaVehiculo,
    },
    Entregado(:final horaEntrega) => {
      'tipo': 'entregado',
      'horaEntrega': horaEntrega.toIso8601String(),
    },
    Cancelado(:final motivo) => {'tipo': 'cancelado', 'motivo': motivo},
  };
}
