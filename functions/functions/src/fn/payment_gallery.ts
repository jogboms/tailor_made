import * as admin from "firebase-admin";
import {Change, firestore} from "firebase-functions";

async function _onPaymentGallery(
    change: Change<firestore.DocumentSnapshot>
) {
  const data = change.after.data();
  if (!data) {
    return null;
  }

  const payments = data.payments;
  const images = data.images;
  const db = admin.firestore();

  const batch = db.batch();

  payments.forEach((payment: any) => {
    const ref = db.collection("payments").doc(payment.id);
    batch.set(ref, payment);
  });

  images.forEach((image: any) => {
    const ref = db.collection("gallery").doc(image.id);
    batch.set(ref, image);
  });

  // Commit the batch
  return batch.commit();
}

export const onPaymentGallery = firestore
    .document("jobs/{jobId}")
    .onWrite(_onPaymentGallery);
