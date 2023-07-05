import 'package:flutter/widgets.dart';

import 'app_router.dart';

extension AppRouterBuildContextExtension on BuildContext {
  AppRouter get router => AppRouter(this);
}
