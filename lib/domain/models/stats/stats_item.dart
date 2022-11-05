import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_item.freezed.dart';
part 'stats_item.g.dart';

@freezed
class StatsItemModel with _$StatsItemModel {
  const factory StatsItemModel({
    @Default(0.0) double total,
    @Default(0.0) double pending,
    @Default(0.0) double completed,
  }) = _StatsItemModel;

  factory StatsItemModel.fromJson(Map<String, Object?> json) => _$StatsItemModelFromJson(json);
}
