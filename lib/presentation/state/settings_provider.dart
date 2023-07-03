import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import 'registry_provider.dart';

part 'settings_provider.g.dart';

@Riverpod(dependencies: <Object>[registry])
Stream<SettingEntity> settings(SettingsRef ref) => ref.read(registryProvider).get<Settings>().fetch();
