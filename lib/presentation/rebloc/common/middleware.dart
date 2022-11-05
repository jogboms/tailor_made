import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/presentation/rebloc.dart';

typedef Middleware = Stream<WareContext<AppState>> Function(WareContext<AppState> context);
