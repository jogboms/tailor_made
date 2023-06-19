import * as admin from "firebase-admin";
import {Change, firestore} from "firebase-functions";
import {ChangeState} from "../utils";

// TODO
// Maybe not the best way to go about this
async function _onStatsJobUpdate(
    change: Change<firestore.DocumentSnapshot>,
) {
  const jobs = change.before.exists ? change.before : change.after;

  return _onStatsJob(jobs);
}

async function _onStatsJob(
    snapshot: firestore.DocumentSnapshot,
) {
  const db = admin.firestore();
  const _data = snapshot.data();

  if (!_data) {
    return;
  }

  // Get user ID from Job
  const userID = Array.isArray(_data) ? _data[0].userID : _data.userID;

  const stats = db.doc(`stats/${userID}`);

  const jobsSnap = await db
      .collection("jobs")
      .where("userID", "==", userID)
      .get();

  let completedJob = 0;
  let pendingJob = 0;
  let completedPrice = 0;
  let totalPrice = 0;
  let totalImages = 0;

  jobsSnap.forEach((doc) => {
    const data = doc.data();
    totalPrice += data.price;
    totalImages += data.images.length;
    completedPrice += data.payments.reduce((acc: number, cur: any) => acc + cur.price, 0);

    if (data.isComplete) {
      completedJob += 1;
    } else {
      pendingJob += 1;
    }
  });

  return stats.update({
    gallery: {
      total: totalImages,
    },
    jobs: {
      total: jobsSnap.size,
      pending: pendingJob,
      completed: completedJob,
    },
    payments: {
      total: totalPrice,
      pending: totalPrice - completedPrice,
      completed: completedPrice,
    },
  });
}

export function onStatsJob(change: ChangeState) {
  const store = firestore.document("jobs/{jobId}");

  if (change === ChangeState.Created) {
    return store.onCreate(_onStatsJob);
  } else if (change === ChangeState.Updated) {
    return store.onUpdate(_onStatsJobUpdate);
  } else {
    return store.onDelete(_onStatsJob);
  }
}
