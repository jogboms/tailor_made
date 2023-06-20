import {Change, firestore} from "firebase-functions";

async function _onJobPayments(
    change: Change<firestore.DocumentSnapshot>
) {
  const job = change.after.data();
  const oldJob = change.before.data();

  if (!change.after.exists) {
    return null;
  }

  if (!job) {
    return;
  }

  // Freshly created
  if (!oldJob) {
    //
  } else if (job.payments.length === oldJob.payments.length) { // Nothing changed in payments
    return null;
  }

  const completedPayment = job.payments.reduce(
      (acc: number, cur: any) => acc + cur.price,
      0
  );
  return change.after.ref.update({
    completedPayment: completedPayment,
    pendingPayment: job.price - completedPayment,
  });
}

export const onJobPayments = firestore
    .document("jobs/{jobId}")
    .onWrite(_onJobPayments);
