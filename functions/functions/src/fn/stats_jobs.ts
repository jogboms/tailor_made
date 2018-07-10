import * as admin from "firebase-admin";
import { Change, EventContext, firestore } from "firebase-functions";

async function _onStatsJob(
  change: Change<firestore.DocumentSnapshot>,
  context: EventContext
) {
  const db = admin.firestore();
  const stats = db.doc("stats/current");

  const jobsSnap = await db.collection("jobs").get();

  let completedJob = 0,
    pendingJob = 0,
    completedPrice = 0,
    totalPrice = 0,
    totalImages = 0;

  jobsSnap.forEach(doc => {
    const data = doc.data();
    totalPrice += data.price;
    totalImages += data.images.length;
    completedPrice += data.payments.reduce((acc, cur) => acc + cur.price, 0);

    if (data.isComplete) {
      completedJob += 1;
    } else {
      pendingJob += 1;
    }
  });

  return stats.update({
    gallery: {
      total: totalImages
    },
    jobs: {
      total: jobsSnap.size,
      pending: pendingJob,
      completed: completedJob
    },
    payments: {
      total: totalPrice,
      pending: totalPrice - completedPrice,
      completed: completedPrice
    }
  });
}

export const onStatsJob = firestore
  .document("jobs/{jobId}")
  .onWrite(_onStatsJob);
