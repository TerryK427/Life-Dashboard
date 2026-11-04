# Scheduled tasks

These three prompts run as **Claude scheduled tasks** in the cloud, so nothing has to be running on the laptop. Each run starts a fresh Claude session with the Google Calendar and Gmail connectors.

| Task | Schedule (Asia/Seoul) | Cron | Delivers |
|---|---|---|---|
| [Morning brief](morning-brief.md) | Daily 05:47 | `CRON_TZ=Asia/Seoul 47 5 * * *` | Push: today's events |
| [Tomorrow preview](tomorrow-preview.md) | Daily 21:44 | `CRON_TZ=Asia/Seoul 44 21 * * *` | Push: tomorrow's events |
| [Weekly preview email](weekly-preview-email.md) | Sundays 19:41 | `CRON_TZ=Asia/Seoul 41 19 * * 0` | Email to my own address |

The times sit a few minutes before the hour (6:00, 22:00, 20:00) because runs at exactly :00 can be delayed when servers are busy.

All three are read-only except the weekly task, which sends exactly one email to one fixed address.
