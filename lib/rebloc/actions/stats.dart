import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/stats.dart';

class OnDataStatEvent extends Action {
  const OnDataStatEvent({
    @required this.payload,
  });

  final StatsModel payload;
}
