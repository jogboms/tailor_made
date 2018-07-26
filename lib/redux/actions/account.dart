import 'package:meta/meta.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/redux/actions/main.dart';

class OnDataAccountEvent extends ActionType<AccountModel> {
  OnDataAccountEvent({
    @required AccountModel payload,
  }) : super(payload: payload);
}

class OnPremiumSignUp extends ActionType<AccountModel> {
  OnPremiumSignUp({
    @required AccountModel payload,
  }) : super(payload: payload);
}

class OnReadNotice extends ActionType<AccountModel> {
  OnReadNotice({
    @required AccountModel payload,
  }) : super(payload: payload);
}

class OnSendRating extends ActionType<AccountModel> {
  final int rating;

  OnSendRating({
    @required AccountModel payload,
    @required this.rating,
  }) : super(payload: payload);
}

class OnSkipedPremium extends ActionType<void> {}
