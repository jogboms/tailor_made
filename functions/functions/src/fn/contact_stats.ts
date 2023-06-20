import * as admin from "firebase-admin";
import {Change, firestore} from "firebase-functions";

// async function asyncForEach<T>(array: T[], callback: (value: T, index: number, array: T[]) => void) {
//   for (let index = 0; index < array.length; index++) {
//     await callback(array[index], index, array);
//   }
// }

async function _onContactStats(change: Change<firestore.DocumentSnapshot>) {
  const oldJob = change.before.data();
  const job = change.after.data();
  const db = admin.firestore();

  let count = 0;
  let total = 0;
  // Added single/multiple new job
  if (oldJob === undefined) {
    // Multiple
    if (Array.isArray(job)) {
      count = job.length;
    } else { // Single
      count = total = 1;
    }
  } else if (Array.isArray(oldJob) && job) {
    // Removed multiple jobs
    count = -job.filter((_: any) => _.isComplete === false).length;
  } else if (job && !Array.isArray(oldJob) && oldJob.isComplete !== job.isComplete) {
    // Toggled isComplete
    count = job.isComplete ? -1 : 1;
  }

  // TODO
  // Multiple contacts (maybe)
  if (Array.isArray(job)) {
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
  } else if (job) {// Single contact
    const contact = db.doc(`contacts/${job.contactID}`);

    const contactSnap = (await contact.get()).data();

    if (!contactSnap) {
      return;
    }

    return contact.update({
      totalJobs: contactSnap.totalJobs + total,
      pendingJobs: contactSnap.pendingJobs + count,
    });
  } else {
    return;
  }
}

export const onContactStats = firestore
    .document("jobs/{jobId}")
    .onWrite(_onContactStats);
