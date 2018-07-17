import { firestore as Firestore } from "firebase-admin";
import { auth, EventContext } from "firebase-functions";
import { ChangeState } from "../utils";

export function _onAuth(onCreate: ChangeState) {
  return async (user: auth.UserRecord, context: EventContext) => {
    const db = Firestore();
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
        total: 0
      },
      gallery: {
        total: 0
      },
      jobs: {
        total: 0,
        pending: 0,
        completed: 0
      },
      payments: {
        total: 0,
        pending: 0,
        completed: 0
      }
    });

    // Commit the batch
    return batch.commit();
  };
}

export function onAuthCreate(onCreate: ChangeState) {
  const store = auth.user();

  // return onCreate == ChangeState.Create
  //   ? store.onCreate(_onAuth(onCreate))
  //   : store.onDelete(_onAuth(onCreate));
  return store.onCreate(_onAuth(onCreate));
}
