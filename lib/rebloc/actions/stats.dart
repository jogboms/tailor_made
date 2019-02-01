import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/stats.dart';

class OnDataStatAction extends Action {
  const OnDataStatAction({
    @required this.payload,
  });

  final StatsModel payload;
}
