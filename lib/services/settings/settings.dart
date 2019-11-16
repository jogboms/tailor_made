import 'package:injector/injector.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/repository/main.dart';

abstract class Settings<T extends Repository> {
  Settings() : repository = Injector.appInstance.getDependency<Repository>();

  final T repository;

  Stream<SettingsModel> fetch();
}
