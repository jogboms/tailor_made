import * as admin from "firebase-admin";
import { Change, EventContext, firestore } from "firebase-functions";
import { isArray } from "util";

async function asyncForEach(array, callback) {
  for (let index = 0; index < array.length; index++) {
    await callback(array[index], index, array);
  }
}

async function _onContactStats(
  change: Change<firestore.DocumentSnapshot>,
  context: EventContext
) {
  const old_job = change.before.data();
  const job = change.after.data();
  const db = admin.firestore();

  let count = 0,
    total = 0;
  // Added single/multiple new job
  if (old_job === undefined) {
    // Multiple
    if (isArray(job)) {
      count = job.length;
    }
    // Single
    else {
      count = total = 1;
    }
  }
  // Removed multiple jobs
  else if (isArray(old_job)) {
    count = -job.filter(_ => _.isComplete === false).length;
  }
  // Toggled isComplete
  else if (old_job.isComplete !== job.isComplete) {
    count = job.isComplete ? -1 : 1;
  }

  // TODO
  // Multiple contacts (maybe)
  if (isArray(job)) {
    // const batch = db.batch();

    // const start = async () => {
    //   await asyncForEach(job, async _ => {
    //     const ref = db.doc(`contacts/${_.contactID}`);
    //     const contactSnap = (await ref.get()).data();

    //     const total = old_job.length > job.length ? -job.length : job.length;
    //     batch.set(ref, {
    //       totalJobs: contactSnap.totalJobs + total,
    //       pendingJobs: contactSnap.pendingJobs + count
    //     });
    //   });
    // };

    // start();

    // // Commit the batch
    // return batch.commit();
    return null;
  }
  // Single contact
  else {
    const contact = db.doc(`contacts/${job.contactID}`);

    const contactSnap = (await contact.get()).data();

    return contact.update({
      totalJobs: contactSnap.totalJobs + total,
      pendingJobs: contactSnap.pendingJobs + count
    });
  }
}

export const onContactStats = firestore
  .document("jobs/{jobId}")
  .onWrite(_onContactStats);
