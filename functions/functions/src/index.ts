import { initializeApp } from "firebase-admin";
import { config } from "firebase-functions";
import { onContactStats } from "./fn/contact_stats";
import { onJobPayments } from "./fn/job_payments";
import { onPaymentGallery } from "./fn/payment_gallery";
import { onStatsContacts } from "./fn/stats_contacts";
import { onStatsJob } from "./fn/stats_jobs";

initializeApp(config().firebase);

export const PaymentGallery = onPaymentGallery;

export const JobPayments = onJobPayments;

export const StatsJobs = onStatsJob;

export const StatsContactsCreate = onStatsContacts();

export const StatsContactsDelete = onStatsContacts(false);

export const ContactStats = onContactStats;
