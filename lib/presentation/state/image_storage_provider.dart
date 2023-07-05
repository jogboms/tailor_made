import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import 'account_provider.dart';
import 'registry_provider.dart';

part 'image_storage_provider.g.dart';

@Riverpod(dependencies: <Object>[account, registry])
ImageStorageProvider imageStorage(ImageStorageRef ref) {
  return ImageStorageProvider(
    fetchAccount: () => ref.read(accountProvider.future),
    imageStorage: ref.read(registryProvider).get(),
  );
}

class ImageStorageProvider {
  @visibleForTesting
  const ImageStorageProvider({
    required AsyncValueGetter<AccountEntity> fetchAccount,
    required ImageStorage imageStorage,
  })  : _fetchAccount = fetchAccount,
        _imageStorage = imageStorage;

  final AsyncValueGetter<AccountEntity> _fetchAccount;
  final ImageStorage _imageStorage;

  Future<ImageFileReference> create(CreateImageType type, {required String path}) async {
    final String userId = (await _fetchAccount()).uid;
    return switch (type) {
      CreateImageType.reference => _imageStorage.createReferenceImage(path: path, userId: userId),
      CreateImageType.contact => _imageStorage.createContactImage(path: path, userId: userId),
    };
  }

  Future<void> delete(ImageFileReference reference) async {
    final String userId = (await _fetchAccount()).uid;
    await _imageStorage.delete(reference: reference, userId: userId);
  }
}

enum CreateImageType { reference, contact }
