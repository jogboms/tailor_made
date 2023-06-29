import 'package:equatable/equatable.dart';

import 'stats_item_entity.dart';

class StatsEntity with EquatableMixin {
  const StatsEntity({
    required this.jobs,
    required this.contacts,
    required this.gallery,
    required this.payments,
  });

  final StatsItemEntity jobs;
  final StatsItemEntity contacts;
  final StatsItemEntity gallery;
  final StatsItemEntity payments;

  @override
  List<Object> get props => <StatsItemEntity>[jobs, contacts, gallery, payments];
}

// KEEP
// {
//   'contacts': {
//     'total': 0
//   },
//   'gallery': {
//     'total': 0
//   },
//   'jobs': {
//     'total': 0,
//     'pending': 0,
//     'completed': 0,
//   },
//   'payments': {
//     'total': 0,
//     'pending': 0,
//     'completed': 0,
//   },
// }
