import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/account.dart';

class InitAccountAction extends Action {
  const InitAccountAction();
}

class OnDataAccountAction extends Action {
  const OnDataAccountAction({
    @required this.payload,
  });
  final AccountModel payload;
}

class OnPremiumSignUp extends Action {
  const OnPremiumSignUp({
    @required this.payload,
  });
  final AccountModel payload;
}

class OnReadNotice extends Action {
  const OnReadNotice({
    @required this.payload,
  });
  final AccountModel payload;
}

class OnSendRating extends Action {
  const OnSendRating({
    @required this.payload,
    @required this.rating,
  });

  final AccountModel payload;
  final int rating;
}

class OnSkipedPremium extends Action {
  const OnSkipedPremium();
}
