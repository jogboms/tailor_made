import {firestore as cloudDb} from "firebase-admin";
import {auth} from "firebase-functions";

export function _onAuth() {
  return async (user: auth.UserRecord) => {
    const db = cloudDb();
    const batch = db.batch();

    const account = db.collection("accounts").doc(user.uid);
    batch.set(account, {
      storeName: user.displayName,
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      status: 0,
      hasPremiumEnabled: false,
      notice: "Its amazing to have you here, look around, Enjoy the experience!",
      hasReadNotice: false,
    });

    const stats = db.collection("stats").doc(user.uid);
    batch.set(stats, {
      contacts: {
        total: 0,
      },
      gallery: {
        total: 0,
      },
      jobs: {
        total: 0,
        pending: 0,
        completed: 0,
      },
      payments: {
        total: 0,
        pending: 0,
        completed: 0,
      },
    });

    // Commit the batch
    return batch.commit();
  };
}

export function onAuthCreate() {
  return auth.user().onCreate(_onAuth());
}
