import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp(functions.config().firebase);

export const aggregateStats = functions.firestore
  .document("jobs/{jobId}")
  .onWrite(async (change, context) => {
    const db = admin.firestore();
    const stats = db.doc("stats/current");

    const jobsSnap = await db.collection("jobs").get();
    const contactsSnap = await db.collection("contacts").get();

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
      contacts: {
        total: contactsSnap.size
      },
      images: {
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
  });

export const aggregateContactStats = functions.firestore
  .document("jobs/{jobId}")
  .onWrite(async (change, context) => {
    const job = change.after.data();

    const db = admin.firestore();
    const count = job.isComplete ? -1 : 1;
    const contact = db.doc(`contacts/${job.contact.documentID}`);

    const jobsSnap = await db
      .collection("jobs")
      .where("contact.id", "==", job.contact.id)
      .get();

    const contactSnap = (await contact.get()).data();

    return contact.update({
      totalJobs: jobsSnap.size,
      hasPending: contactSnap.hasPending + count
    });
  });

export const updateContact = functions.firestore
  .document("contacts/{contactId}")
  .onCreate((change, context) => {
    return change.data().update({
      documentID: context.params.contactId
    });
  });