import * as admin from "firebase-admin";
import { Change, EventContext, firestore } from "firebase-functions";

async function _onPaymentGallery(
  change: Change<firestore.DocumentSnapshot>,
  context: EventContext
) {
  if (!change.after.data()) return null;

  const payments = change.after.data().payments;
  const images = change.after.data().images;
  const db = admin.firestore();

  const batch = db.batch();

  payments.forEach(payment => {
    const ref = db.collection("payments").doc(payment.id);
    batch.set(ref, payment);
  });

  images.forEach(image => {
    const ref = db.collection("gallery").doc(image.id);
    batch.set(ref, image);
  });

  // Commit the batch
  return batch.commit();
}

export const onPaymentGallery = firestore
  .document("jobs/{jobId}")
  .onWrite(_onPaymentGallery);
