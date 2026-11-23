# Daily brief (morning brief + tomorrow preview)

One prompt runs as two scheduled tasks. Create each task from the prompt below, replacing `{DAY}`, `{Label}` and `{Extra}` with that task's values:

| | Morning brief | Tomorrow preview |
|---|---|---|
| **Schedule** | daily 05:47 Asia/Seoul (`CRON_TZ=Asia/Seoul 47 5 * * *`) | daily 21:44 Asia/Seoul (`CRON_TZ=Asia/Seoul 44 21 * * *`) |
| `{DAY}` | today | tomorrow (the day after today's Seoul date) |
| `{Label}` | Today | Tomorrow |
| `{Extra}` | *(delete the line)* | If the first timed event starts before 09:00, begin the message with "Early start! ". |

- **Notifications:** push (the task's "notify when finished" setting delivers the final reply)
- **Connectors:** Google Calendar

```text
Daily brief about {DAY} for the user, who lives in Seoul (Asia/Seoul, UTC+9). This is a read-only task: never create, edit, delete or send anything. The only output is your final reply.

DELIVERY: your FINAL REPLY is delivered to the user's phone as a notification when this run finishes. That is the only delivery route: do NOT use the PushNotification tool or any other way to send it. The final reply must be exactly the message from step 4 and nothing else (no preamble, no status, no quotes).

0. GET THE DATE FIRST. The server clock and any date in your context may be in UTC, which can be a day behind Seoul (05:47 in Seoul is still the previous day in UTC). Run this shell command and use its output as today: TZ=Asia/Seoul date '+%Y-%m-%d %a'   (If no shell is available, take the current UTC time and add 9 hours.) "{DAY}" below always means that Seoul-based date. Never use the UTC date.

1. With the Google Calendar connector, call list_calendars, then list_events on EVERY calendar it returns (including the family calendar and the holidays calendar) with timeZone "Asia/Seoul", startTime = <{DAY}>T00:00:00, endTime = <{DAY} + 1 day>T00:00:00 (no offset). Before writing, check that the events you got start on {DAY}'s Seoul date; if they are for a different day, you used the wrong date: redo step 1. If a call errors, retry it once.
2. Merge the events. Skip cancelled ones. Put all-day events first, then timed events by start time.
3. IMPORTANT TASKS: an event whose colorId is "11" (the color Tomato) is an important task to the user. Put a 🔴 directly before its time, and never drop a Tomato event to make room.
4. Write ONE message about {DAY} ONLY, at most 200 characters, one line, no markdown. Format (with the real weekday and date):
   "{Label} (Thu 11/5, N): All day 휴가 · 🔴 08:00 출발 · 19:00 과외"
   Use 24-hour times and keep event titles exactly as written. If it would exceed 200 characters, keep the Tomato events and the earliest others, and end with "+N more". If two timed events overlap, add " ⚠ overlap" at the end. If there are no events, write: "{Label} (<day> <M/D>): nothing scheduled."
   {Extra}
   CONNECTOR PROBLEMS (Claude's connectors sometimes fail during outages; tell the user so they double-check, and never invent events):
   - If the Google Calendar connector is unavailable or list_calendars still fails after the retry, the message is: "⚠ Claude connectors failing: couldn't read Google Calendar for {DAY}. Double-check your schedule in the Google Calendar app."
   - If only some calendars failed, start the message with "⚠ Some calendars didn't load, double-check · " and then the normal brief from the calendars that did load (shorten it to stay within 200 characters).
5. FINAL REPLY: exactly the message from step 4, as a single line, and nothing else.
```
