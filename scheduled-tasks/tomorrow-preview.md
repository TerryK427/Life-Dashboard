# Tomorrow preview

- **Schedule:** daily 21:44 Asia/Seoul (`CRON_TZ=Asia/Seoul 44 21 * * *`)
- **Notifications:** push
- **Connectors:** Google Calendar

## Prompt

```text
Evening preview of TOMORROW for the user, who lives in Seoul (Asia/Seoul, UTC+9). This is a read-only task: never create, edit, delete or send anything.

0. GET THE DATE FIRST. The server clock and any date in your context may be in UTC, which can differ from Seoul's date. Run this shell command and use its output as today: TZ=Asia/Seoul date '+%Y-%m-%d %a'   (If no shell is available, take the current UTC time and add 9 hours.) "Tomorrow" below always means the day after that Seoul date.

1. With the Google Calendar connector, call list_calendars, then list_events on EVERY calendar it returns (including the family calendar "가족" and the Korean holidays calendar) with timeZone "Asia/Seoul", startTime = <tomorrow>T00:00:00, endTime = <tomorrow + 1 day>T00:00:00 (no offset). Before writing, check that the events you got start on tomorrow's Seoul date; if not, redo step 1 with the right date.
2. Merge the events. Skip cancelled ones. All-day events first, then timed events by start time.
3. IMPORTANT TASKS: an event whose colorId is "11" (the color Tomato) is an important task to the user. Put a 🔴 directly before its time, and never drop a Tomato event to make room.
4. Write ONE push message about TOMORROW ONLY, at most 200 characters, one line, no markdown. Format (with tomorrow's real weekday and date):
   "Tomorrow (Thu 11/5, N): 🔴 10:30 수업 보강 · 19:00 트레이닝"
   Use 24-hour times and keep titles exactly as written. If the first timed event starts before 09:00, begin the message with "Early start! ". If two timed events overlap, add " ⚠ overlap". If it would exceed 200 characters, keep the Tomato events and the earliest others, and end with "+N more". If there are no events: "Tomorrow (<day> <M/D>): nothing scheduled."
5. If a PushNotification tool is available, send the message with it. Either way, make that exact message your final reply and nothing else.
If the calendar connector fails, final reply: "Tomorrow preview couldn't read Google Calendar. Reconnect it in claude.ai Settings → Connectors."
```
