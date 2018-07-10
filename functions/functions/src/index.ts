import { initializeApp } from "firebase-admin";
import { config } from "firebase-functions";
import { onContactStats } from "./lib/contact_stats";
import { onJobPayments } from "./lib/job_payments";
import { onPaymentGallery } from "./lib/payment_gallery";
import { onStatsContacts } from "./lib/stats_contacts";
import { onStatsJob } from "./lib/stats_jobs";

initializeApp(config().firebase);

export const PaymentGallery = onPaymentGallery;

export const JobPayments = onJobPayments;

export const StatsJobs = onStatsJob;

export const StatsContactsCreate = onStatsContacts();

export const StatsContactsDelete = onStatsContacts(false);

export const ContactStats = onContactStats;
