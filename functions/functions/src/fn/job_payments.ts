import { Change, EventContext, firestore } from "firebase-functions";

async function _onJobPayments(
  change: Change<firestore.DocumentSnapshot>,
  context: EventContext
) {
  const job = change.after.data();
  const old_job = change.before.data();

  if (!change.after.exists) {
    return null;
  }

  // Freshly created
  if (!old_job) {
    //
  }
  // Nothing changed in payments
  else if (job.payments.length === old_job.payments.length) return null;

  const completedPayment = job.payments.reduce(
    (acc, cur) => acc + cur.price,
    0
  );
  return change.after.ref.update({
    completedPayment: completedPayment,
    pendingPayment: job.price - completedPayment
  });
}

export const onJobPayments = firestore
  .document("jobs/{jobId}")
  .onWrite(_onJobPayments);
