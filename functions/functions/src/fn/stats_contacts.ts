import { firestore as Firestore } from "firebase-admin";
import { EventContext, firestore } from "firebase-functions";
import { isArray } from "util";
import { ChangeState } from "../utils";

export function _onStatsContacts(onCreate: ChangeState) {
  return async (
    snapshot: firestore.DocumentSnapshot,
    context: EventContext
  ) => {
    const db = Firestore();
    const contact = snapshot.data();
    const stats = db.doc(`stats/${contact.userID}`);

    const statsSnap = await stats.get();

    // Multiple & Single
    const count = isArray(contact) ? contact.length : 1;
    const total = statsSnap.data().contacts.total;

    return stats.update({
      contacts: {
        total: total + (onCreate ? count : -count)
      }
    });
  };
}

export function onStatsContacts(onCreate: ChangeState) {
  const store = firestore.document("contacts/{contactId}");

  return onCreate === ChangeState.Created
    ? store.onCreate(_onStatsContacts(onCreate))
    : store.onDelete(_onStatsContacts(onCreate));
}
