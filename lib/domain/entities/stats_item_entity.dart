import 'package:equatable/equatable.dart';

class StatsItemEntity with EquatableMixin {
  const StatsItemEntity({
    this.total = 0.0,
    this.pending = 0.0,
    this.completed = 0.0,
  });

  final double total;
  final double pending;
  final double completed;

  @override
  List<Object> get props => <double>[total, pending, completed];
}
