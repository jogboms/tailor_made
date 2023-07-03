import 'package:flutter/cupertino.dart';
import 'package:tailor_made/domain.dart';

import '../screens/contacts/contact.dart';
import '../screens/contacts/contacts.dart';
import '../screens/contacts/contacts_create.dart';
import '../screens/contacts/contacts_edit.dart';
import '../screens/contacts/widgets/contact_measure.dart';
import '../screens/gallery/gallery.dart';
import '../screens/gallery/widgets/gallery_view.dart';
import '../screens/homepage/homepage.dart';
import '../screens/homepage/widgets/store_name_dialog.dart';
import '../screens/jobs/job.dart';
import '../screens/jobs/jobs.dart';
import '../screens/jobs/jobs_create.dart';
import '../screens/jobs/widgets/contact_lists.dart';
import '../screens/measures/measures.dart';
import '../screens/measures/measures_create.dart';
import '../screens/measures/measures_manage.dart';
import '../screens/measures/widgets/measure_create_item.dart';
import '../screens/payments/payment.dart';
import '../screens/payments/payments.dart';
import '../screens/payments/payments_create.dart';
import '../screens/splash/splash.dart';
import '../screens/tasks/tasks.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter(this._context);

  final BuildContext _context;

  void toHome() => _fadeIn(const HomePage(), AppRoutes.home, clearHistory: true);

  Future<String?>? toStoreNameDialog(AccountEntity account) =>
      _fadeIn<String>(StoreNameDialog(account: account), AppRoutes.storeNameDialog);

  void toSplash() => _fadeIn(const SplashPage(isColdStart: false), AppRoutes.start, clearHistory: true);

  void toContact(String id, {bool replace = false}) =>
      _slideIn(ContactPage(id: id), AppRoutes.contact, replace: replace);

  void toContactEdit(ContactEntity contact) => _slideIn(ContactsEditPage(contact: contact), AppRoutes.editContacts);

  Future<Map<String, double>?>? toContactMeasure({
    required ContactEntity? contact,
    required Map<MeasureGroup, List<MeasureEntity>> grouped,
  }) =>
      _slideIn<Map<String, double>>(ContactMeasure(contact: contact, grouped: grouped), AppRoutes.contactsMeasurement);

  void toContacts() => _slideIn(const ContactsPage(), AppRoutes.contacts);

  Future<ContactEntity?>? toContactsList(List<ContactEntity> contacts) =>
      _fadeIn<ContactEntity>(ContactLists(contacts: contacts), AppRoutes.contactsList);

  void toCreateContact() => _slideIn(const ContactsCreatePage(), AppRoutes.createContact);

  void toJob(JobEntity job, {bool replace = false}) => _slideIn(JobPage(job: job), AppRoutes.job, replace: replace);

  void toJobs() => _slideIn(const JobsPage(), AppRoutes.jobs);

  void toCreateJob(String? contactId) => _slideIn(JobsCreatePage(contactId: contactId), AppRoutes.createJob);

  void toPayment(PaymentEntity payment) =>
      _slideIn(PaymentPage(payment: payment), AppRoutes.payment, fullscreenDialog: true);

  void toPayments(String userId, [List<PaymentEntity>? payments]) => payments == null
      ? _slideIn(PaymentsPage(userId: userId), AppRoutes.payments)
      : _slideIn(PaymentsPage(payments: payments, userId: userId), AppRoutes.payments, fullscreenDialog: true);

  Future<({double price, String notes})?>? toCreatePayment(double payment) =>
      _fadeIn<({double price, String notes})>(PaymentsCreatePage(limit: payment), AppRoutes.createPayment);

  void toGalleryImage({required String src, required String contactID, required String jobID}) =>
      _fadeIn(GalleryView(src: src, contactID: contactID, jobID: jobID), AppRoutes.galleryImage);

  void toGallery(String userId, [List<ImageEntity>? images]) => images == null
      ? _slideIn(GalleryPage(userId: userId), AppRoutes.gallery)
      : _slideIn(
          GalleryPage(userId: userId, images: images),
          AppRoutes.gallery,
          fullscreenDialog: true,
        );

  void toMeasures(Map<String, double> measures) =>
      _slideIn(MeasuresPage(measurements: measures), AppRoutes.measurements, fullscreenDialog: true);

  void toManageMeasures() => _slideIn(const MeasuresManagePage(), AppRoutes.manageMeasurements);

  void toCreateMeasures({
    MeasureGroup? groupName,
    String? unitValue,
    List<MeasureEntity>? measures,
  }) =>
      _slideIn(
        MeasuresCreate(groupName: groupName, unitValue: unitValue, measures: measures),
        AppRoutes.createMeasurements,
        fullscreenDialog: true,
      );

  Future<DefaultMeasureEntity?>? toCreateMeasureItem({
    required MeasureGroup groupName,
    required String unitValue,
  }) =>
      _fadeIn<DefaultMeasureEntity>(
        MeasureCreateItem(groupName: groupName, unitValue: unitValue),
        AppRoutes.createMeasurementItem,
      );

  void toTasks() => _slideIn(const TasksPage(), AppRoutes.tasks);

  Future<T?> _fadeIn<T extends Object>(
    Widget child,
    String name, {
    bool clearHistory = false,
  }) {
    final PageRoute<T> route = _fadeInRoute<T>(
      child,
      settings: RouteSettings(name: name),
    );

    final NavigatorState navigator = Navigator.of(_context);
    if (clearHistory) {
      return navigator.pushAndRemoveUntil<T>(route, (_) => false);
    }
    return navigator.push<T>(route);
  }

  Future<T?> _slideIn<T extends Object>(
    Widget child,
    String name, {
    bool replace = false,
    bool fullscreenDialog = false,
  }) {
    final PageRoute<T> route = _slideInRoute<T>(
      child,
      settings: RouteSettings(name: name),
      fullscreenDialog: fullscreenDialog,
    );

    final NavigatorState navigator = Navigator.of(_context);
    if (replace) {
      return navigator.pushReplacement<T, void>(route);
    }
    return navigator.push<T>(route);
  }
}

PageRoute<T> _slideInRoute<T extends Object>(
  Widget widget, {
  String? name,
  RouteSettings? settings,
  bool maintainState = true,
  bool fullscreenDialog = false,
  PageRoute<Object>? hostRoute,
}) {
  return CupertinoPageRoute<T>(
    builder: (BuildContext context) => widget,
    settings: name != null ? RouteSettings(name: name) : settings,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
  );
}

PageRoute<T> _fadeInRoute<T extends Object>(
  Widget widget, {
  String? name,
  RouteSettings? settings,
  bool maintainState = true,
}) {
  return PageRouteBuilder<T>(
    opaque: false,
    pageBuilder: (_, __, ___) => widget,
    transitionsBuilder: (_, Animation<double> animation, __, Widget child) =>
        FadeTransition(opacity: animation, child: child),
    settings: name != null ? RouteSettings(name: name) : settings,
    maintainState: maintainState,
  );
}
