import 'package:flutter_test/flutter_test.dart';
import 'package:mi_primera_app/main.dart';

void main() {
  testWidgets('la app arranca y muestra el título Pedidos', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Pedidos'), findsOneWidget);
  });
}
