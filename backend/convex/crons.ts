import { cronJobs } from "convex/server";
import { api } from "./_generated/api";

const crons = cronJobs();

// Run the purge job every hour to guarantee ephemeral rolling storage
crons.hourly(
  "purge-old-chat-messages",
  { minuteUTC: 0 },
  api.chat.purgeOldMessages
);

export default crons;
