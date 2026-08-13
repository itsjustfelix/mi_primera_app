import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mi_primera_app/core/json.dart';

part 'direccion.freezed.dart';

@freezed
abstract class Direccion with _$Direccion {
  const factory Direccion({required String calle, required String barrio}) =
      _Direccion;

  factory Direccion.desdeJson(Map<String, dynamic> json) => Direccion(
    calle: leerTexto(json, 'calle'),
    barrio: leerTexto(json, 'barrio'),
  );
}

extension DireccionJson on Direccion {
  Map<String, dynamic> toJson() => {'calle': calle, 'barrio': barrio};
}
