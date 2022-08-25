import 'flavors.dart';
import 'main.dart' as app;

void main() {
  F.appFlavor = Flavor.production;
  app.main();
}
