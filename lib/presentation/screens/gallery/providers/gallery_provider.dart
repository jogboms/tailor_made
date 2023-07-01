import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'gallery_provider.g.dart';

@Riverpod(dependencies: <Object>[registry, account])
Stream<List<ImageEntity>> gallery(GalleryRef ref) async* {
  final AccountEntity account = await ref.watch(accountProvider.future);

  yield* ref.read(registryProvider).get<Gallery>().fetchAll(account.uid);
}
