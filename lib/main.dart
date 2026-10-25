import 'app/config/flavor_config.dart';
import 'bootstrap.dart';

/// Default entry point runs dev. Prefer the explicit `main_<flavor>.dart` files.
void main() => bootstrap(AppFlavor.dev);
