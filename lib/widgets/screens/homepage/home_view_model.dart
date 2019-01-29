import 'package:redux/redux.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/states/account.dart';
import 'package:tailor_made/rebloc/states/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/stats.dart';
import 'package:tailor_made/redux/actions/account.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/view_models/stats.dart';
import 'package:tailor_made/services/settings.dart';
import 'package:version/version.dart';

class HomeViewModel extends StatsViewModel {
  HomeViewModel(Store<AppState> store) : super(store);

  AccountState get _state => store.state.account;

  AccountModel get account => _state.account;

  List<ContactModel> get contacts => store.state.contacts.contacts;

  @override
  bool get isLoading {
    return store.state.stats.status == StatsStatus.loading ||
        store.state.contacts.status == ContactsStatus.loading ||
        _state.status == AccountStatus.loading;
  }

  bool get hasSkipedPremium => _state.hasSkipedPremium == true;

  bool get isDisabled => account.status == AccountModelStatus.disabled;

  bool get isWarning => account.status == AccountModelStatus.warning;

  bool get isPending => account.status == AccountModelStatus.pending;

  bool get shouldSendRating {
    return !account.hasSendRating &&
        (((store.state.contacts.contacts?.length ?? 0) >= 10) ||
            ((store.state.jobs.jobs?.length ?? 0) >= 10));
  }

  bool get isOutdated {
    final currentVersion = Version.parse(Settings.getVersion());
    final latestVersion =
        Version.parse(store.state.settings.settings?.versionName ?? "1.0.0");

    return latestVersion > currentVersion;
  }

  void onPremiumSignUp() => store.dispatch(OnPremiumSignUp(payload: account));

  void onSendRating(int rating) => store.dispatch(
        OnSendRating(payload: account, rating: rating),
      );

  void onReadNotice() => store.dispatch(OnReadNotice(payload: account));

  void onSkipedPremium() => store.dispatch(OnSkipedPremium());

  void logout() => store.dispatch(OnLogoutEvent());
}
