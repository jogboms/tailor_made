import { firestore as Firestore } from "firebase-admin";
import { EventContext, firestore } from "firebase-functions";
import { isArray } from "util";

export function _onStatsContacts(onCreate: boolean) {
  return async (
    snapshot: firestore.DocumentSnapshot,
    context: EventContext
  ) => {
    const db = Firestore();
    const stats = db.doc("stats/current");
    const contact = snapshot.data();

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

export function onStatsContacts(onCreate = true) {
  const store = firestore.document("contacts/{contactId}");

  return onCreate
    ? store.onCreate(_onStatsContacts(onCreate))
    : store.onDelete(_onStatsContacts(onCreate));
}
