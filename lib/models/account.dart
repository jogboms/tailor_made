import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:tailor_made/repository/models.dart';

part 'account.g.dart';

enum AccountModelStatus { enabled, disabled, warning, pending }

abstract class AccountModel with ModelInterface implements Built<AccountModel, AccountModelBuilder> {
  factory AccountModel([void updates(AccountModelBuilder b)]) = _$AccountModel;

  factory AccountModel.fromSnapshot(Snapshot snapshot) =>
      AccountModel.fromJson(snapshot.data)..reference = snapshot.reference;

  AccountModel._();

  String get uid;

  String get storeName;

  String get email;

  String get displayName;

  @nullable
  int get phoneNumber;

  String get photoURL;

  AccountModelStatus get status;

  bool get hasPremiumEnabled;

  bool get hasSendRating;

  int get rating;

  String get notice;

  bool get hasReadNotice;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(AccountModel.serializer, this);

  static AccountModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(AccountModel.serializer, map);

  static Serializer<AccountModel> get serializer => _$accountModelSerializer;
}
