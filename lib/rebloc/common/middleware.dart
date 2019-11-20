import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/app_state.dart';

typedef Middleware = Stream<WareContext<AppState>> Function(WareContext<AppState> context);
