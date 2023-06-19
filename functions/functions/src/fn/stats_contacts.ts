import {firestore as cloudDb} from "firebase-admin";
import {firestore} from "firebase-functions";
import {ChangeState} from "../utils";

export function _onStatsContacts(state: ChangeState) {
  return async (
      snapshot: firestore.DocumentSnapshot
  ) => {
    const db = cloudDb();
    const contact = snapshot.data();
    if (!contact) {
      return;
    }

    const stats = db.doc(`stats/${contact.userID}`);

    const statsSnap = await stats.get();
    const stat = statsSnap.data();
    if (!stat) {
      return;
    }
    // Multiple & Single
    const count = Array.isArray(contact) ? contact.length : 1;
    const total = stat.contacts.total;

    return stats.update({
      contacts: {
        total: total + (state === ChangeState.Created ? count : -count),
      },
    });
  };
}

export function onStatsContacts(onCreate: ChangeState) {
  const store = firestore.document("contacts/{contactId}");

  return onCreate === ChangeState.Created ?
    store.onCreate(_onStatsContacts(onCreate)) :
    store.onDelete(_onStatsContacts(onCreate));
}
