## ComiditApp (no es proyecto de aula)

    que problema resuelve en dos frases

    Los clientes piden comida y el restaurante no sabe el estado de los pedidos

## El dominio

    Entidad -> Pedidos. idenficador principal el id
    Objeto valor -> Direccion
    Estados -> Recibida , Preparando , EnCamino , Entregado , Cancelado.

Decision: con freezed.Basicamente porque es una herramienta que te ayuda a escribir menos codigo, lo que
tambien significa que "pierdes" menos tiempo en hacer algo manualmente. Ademas que
deja los archivos mas limpios y mas facil de leer.

## Cómo correrlo

    flutter pub get
    dart run build_runner build --delete-conflicting-outputs
    flutter test
    flutter run
