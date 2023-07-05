import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';
import '../widgets/image_form_value.dart';
import '../widgets/payment_grids_form_value.dart';

part 'job_provider.g.dart';

@Riverpod(dependencies: <Object>[account, registry])
JobProvider job(JobRef ref) {
  return JobProvider(
    fetchAccount: () => ref.read(accountProvider.future),
    jobs: ref.read(registryProvider).get(),
  );
}

class JobProvider {
  const JobProvider({
    required AsyncValueGetter<AccountEntity> fetchAccount,
    required Jobs jobs,
  })  : _fetchAccount = fetchAccount,
        _jobs = jobs;

  final AsyncValueGetter<AccountEntity> _fetchAccount;
  final Jobs _jobs;

  Future<JobEntity> create({
    required CreateJobData job,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    return _jobs.create(userId, job);
  }

  Future<void> complete({
    required ReferenceEntity reference,
    required bool complete,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    await _jobs.update(userId, reference: reference, isComplete: complete);
  }

  Future<void> changeDueAt({
    required ReferenceEntity reference,
    required DateTime dueAt,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    await _jobs.update(userId, reference: reference, dueAt: dueAt);
  }

  Future<void> modifyGallery({
    required ReferenceEntity reference,
    required List<ImageFormValue> images,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    await _jobs.update(
      userId,
      reference: reference,
      images: images
          .map(
            (ImageFormValue input) => switch (input) {
              ImageCreateFormValue() => CreateImageOperation(data: input.data),
              ImageModifyFormValue() => ModifyImageOperation(data: input.data),
            },
          )
          .toList(growable: false),
    );
  }

  Future<void> modifyPayments({
    required ReferenceEntity reference,
    required List<PaymentGridsFormValue> payments,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    await _jobs.update(
      userId,
      reference: reference,
      payments: payments
          .map(
            (PaymentGridsFormValue input) => switch (input) {
              PaymentGridsCreateFormValue() => CreatePaymentOperation(data: input.data),
              PaymentGridsModifyFormValue() => ModifyPaymentOperation(data: input.data),
            },
          )
          .toList(growable: false),
    );
  }
}
