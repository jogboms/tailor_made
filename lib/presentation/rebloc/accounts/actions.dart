import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';

class InitAccountAction extends Action {
  const InitAccountAction(this.userId);

  final String? userId;
}

class OnPremiumSignUp extends Action {
  const OnPremiumSignUp(this.payload);

  final AccountModel? payload;
}

class OnReadNotice extends Action {
  const OnReadNotice(this.payload);

  final AccountModel? payload;
}

class OnSendRating extends Action {
  const OnSendRating(this.account, this.rating);

  final AccountModel? account;
  final int rating;
}

class OnSkipedPremium extends Action {
  const OnSkipedPremium();
}
