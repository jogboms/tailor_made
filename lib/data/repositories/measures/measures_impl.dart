import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/domain.dart';
import 'package:uuid/uuid.dart';

import '../../network/firebase.dart';

class MeasuresImpl extends Measures {
  MeasuresImpl({
    required this.firebase,
    required this.isDev,
  }) : collection = CloudDbCollection(firebase.db, collectionName);

  final Firebase firebase;
  final bool isDev;
  final CloudDbCollection collection;

  static const String collectionName = 'measurements';

  @override
  Stream<List<MeasureEntity>> fetchAll(String userId) {
    return firebase.db.measurements(userId).snapshots().map(
          (MapQuerySnapshot snapshot) => snapshot.docs
              .map((MapQueryDocumentSnapshot doc) => _deriveMeasureEntity(doc.id, doc.reference.path, doc.data()))
              .toList(),
        );
  }

  @override
  Future<bool> create(
    List<BaseMeasureEntity> measures,
    String userId, {
    required MeasureGroup groupName,
    required String unitValue,
  }) async {
    await firebase.db.batchAction((_) {
      for (final BaseMeasureEntity measure in measures) {
        switch (measure) {
          case MeasureEntity():
            final ReferenceEntity reference = measure.reference;
            final MapDocumentReference ref = collection.db.doc(reference.path);
            _.update(ref, <String, String?>{
              'group': groupName.displayName,
              'unit': unitValue,
            });
            break;
          case DefaultMeasureEntity():
            final String id = const Uuid().v4();
            _.set(
              firebase.db.measurements(userId).doc(id),
              measure.toJson(id),
              SetOptions(merge: true),
            );
            break;
        }
      }
    });
    return true;
  }

  @override
  Future<bool> deleteGroup(List<MeasureEntity> measures, String userId) async {
    await firebase.db.batchAction((_) {
      for (final MeasureEntity measure in measures) {
        _.delete(firebase.db.measurements(userId).doc(measure.id));
      }
    });
    return true;
  }

  @override
  Future<bool> deleteOne(ReferenceEntity reference) async {
    await firebase.db.doc(reference.path).delete();
    return true;
  }

  @override
  Future<bool> update(Iterable<BaseMeasureEntity> measures, String userId) async {
    await firebase.db.batchAction((_) {
      try {
        for (final BaseMeasureEntity measure in measures) {
          switch (measure) {
            case MeasureEntity():
              _.set(
                firebase.db.measurements(userId).doc(measure.id),
                measure.toJson(),
                SetOptions(merge: true),
              );
              break;
            case DefaultMeasureEntity():
              final String id = const Uuid().v4();
              _.set(
                firebase.db.measurements(userId).doc(id),
                measure.toJson(id),
                SetOptions(merge: true),
              );
              break;
          }
        }
      } catch (_) {}
    });
    return true;
  }

  @override
  Future<bool> updateOne(ReferenceEntity reference, {String? name}) async {
    await firebase.db.doc(reference.path).update(<String, Object?>{
      if (name != null) 'name': name,
    });
    return true;
  }
}

MeasureEntity _deriveMeasureEntity(String id, String path, DynamicMap data) {
  return MeasureEntity(
    reference: ReferenceEntity(id: id, path: path),
    id: data['id'] as String,
    name: data['name'] as String,
    value: data['value'] as double? ?? 0.0,
    unit: data['unit'] as String,
    group: MeasureGroup.valueOf(data['group'] as String),
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}

extension on CloudDb {
  MapCollectionReference measurements(String? userId) => collection('${MeasuresImpl.collectionName}/$userId/common');
}

extension on MeasureEntity {
  Map<String, Object> toJson() {
    return <String, Object>{
      'id': id,
      'name': name,
      'value': value,
      'unit': unit,
      'group': group.displayName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

extension on DefaultMeasureEntity {
  Map<String, Object> toJson(String id) {
    return <String, Object>{
      'id': id,
      'name': name,
      'value': value,
      'unit': unit,
      'group': group.displayName,
      'createdAt': clock.now().toIso8601String(),
    };
  }
}
