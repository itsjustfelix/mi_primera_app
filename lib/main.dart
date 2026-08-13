import 'package:flutter/material.dart';
import 'package:mi_primera_app/features/pedidos/data/pedidos_locales.dart';
import 'package:mi_primera_app/features/pedidos/domain/estado_pedido.dart';
import 'package:mi_primera_app/features/pedidos/domain/pedido.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Pedidos',
    theme: ThemeData(colorSchemeSeed: Colors.indigo),
    home: const PantallaPedidos(),
  );
}

class PantallaPedidos extends StatefulWidget {
  const PantallaPedidos({super.key});

  @override
  State<PantallaPedidos> createState() => _PantallaPedidosState();
}

class _PantallaPedidosState extends State<PantallaPedidos> {
  late final Future<List<Pedido>> _pedidos = PedidosLocales().obtenerTodos();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pedidos')),
    body: FutureBuilder<List<Pedido>>(
      future: _pedidos,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('No se pudo leer:\n${snapshot.error}'));
        }

        final pedidos = snapshot.data ?? const <Pedido>[];
        return ListView.separated(
          itemCount: pedidos.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final pedido = pedidos[i];
            return ListTile(
              title: Text(pedido.cliente),
              subtitle: Text(
                '${pedido.direccion.barrio} · ${pedido.estado.etiqueta}',
              ),
              trailing: pedido.tieneNota
                  ? const Icon(Icons.sticky_note_2_outlined)
                  : null,
            );
          },
        );
      },
    ),
  );
}
