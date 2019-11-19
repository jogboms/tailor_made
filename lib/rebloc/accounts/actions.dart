import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/account.dart';

class InitAccountAction extends Action {
  const InitAccountAction();
}

class OnPremiumSignUp extends Action {
  const OnPremiumSignUp(this.payload);

  final AccountModel payload;
}

class OnReadNotice extends Action {
  const OnReadNotice(this.payload);

  final AccountModel payload;
}

class OnSendRating extends Action {
  const OnSendRating(this.account, this.rating);

  final AccountModel account;
  final int rating;
}

class OnSkipedPremium extends Action {
  const OnSkipedPremium();
}
