import { initializeApp } from "firebase-admin";
import { config } from "firebase-functions";
import { onAuthCreate } from "./fn/auth";
import { onContactStats } from "./fn/contact_stats";
import { onJobPayments } from "./fn/job_payments";
import { onPaymentGallery } from "./fn/payment_gallery";
import { onStatsContacts } from "./fn/stats_contacts";
import { onStatsJob } from "./fn/stats_jobs";
import { ChangeState } from "./utils";

initializeApp(config().firebase);

export const AuthCreate = onAuthCreate(ChangeState.Created);

export const PaymentGallery = onPaymentGallery;

export const JobPayments = onJobPayments;

export const StatsJobsCreate = onStatsJob(ChangeState.Created);

export const StatsJobsUpdate = onStatsJob(ChangeState.Updated);

export const StatsJobsDelete = onStatsJob(ChangeState.Deleted);

export const StatsContactsCreate = onStatsContacts(ChangeState.Created);

export const StatsContactsDelete = onStatsContacts(ChangeState.Deleted);

export const ContactStats = onContactStats;
