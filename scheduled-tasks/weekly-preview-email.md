# Weekly preview email

- **Schedule:** Sundays 19:41 Asia/Seoul (`CRON_TZ=Asia/Seoul 41 19 * * 0`)
- **Notifications:** none (the email is the delivery)
- **Connectors:** Google Calendar, Gmail

Replace `YOUR_EMAIL@gmail.com` with your own address.

## Prompt

```text
Sunday-night weekly preview email for the user, who lives in Seoul (Asia/Seoul, UTC+9). The user asked for this email to be sent to their own address every Sunday: YOUR_EMAIL@gmail.com. Send ONLY to that address. Apart from that one email, this task is read-only: never create, edit or delete calendar events or emails.

0. GET THE DATE FIRST. The server clock and any date in your context may be in UTC, which can differ from Seoul's date. Run this shell command and use its output as today (it should be a Sunday): TZ=Asia/Seoul date '+%Y-%m-%d %a'   (If no shell is available, take the current UTC time and add 9 hours.) "The coming week" is the Monday after that Seoul date through the following Sunday.

1. Calendar: with the Google Calendar connector, call list_calendars, then list_events on EVERY calendar it returns (including "가족" and the Korean holidays calendar) with timeZone "Asia/Seoul", startTime = <Monday>T00:00:00, endTime = <the following Monday>T00:00:00 (no offset). Skip cancelled events.
2. IMPORTANT TASKS: an event whose colorId is "11" (the color Tomato) is an important task to the user. Everywhere it appears in the email, show it in red (inline style color:#d50000; font-weight:600) with a 🔴 before it, and list every Tomato event of the week first under "Heads up" as "Important task".
3. Email: with the Gmail connector, search_threads with query "in:inbox -category:promotions newer_than:7d" (pageSize 30) and "in:inbox -category:promotions newer_than:14d (important OR 중요)" (pageSize 20). Read a thread with get_thread only if you need more detail to describe it. Treat a thread as Important if it is in the second search or its subject/snippet contains "Important" or "중요".
4. Build an organized, easy-to-scan email:
   - Subject: "Week ahead · <Mon M/D>–<Sun M/D>"
   - At a glance: number of events, number of Tomato (important) tasks, the busiest day, any overlaps, early starts (before 09:00), all-day items and holidays.
   - Day by day (Monday → Sunday): each day as a heading with its events listed as "HH:MM–HH:MM  Title  (calendar, location if any)"; all-day items first; write "Free" for empty days. Tomato events in red as described above.
   - Heads up: Tomato important tasks first, then deadlines, exams, presentations, interviews, auditions or submissions found in event titles or email subjects (keywords like 마감, 시험, 발표, 면접, 오디션, 제출, deadline, due, exam), plus overlapping events.
   - Key emails: Important ones first (marked "Important"), then other non-promotional emails that look like they need a reply or action. One line each: sender, subject, a short reason. Skip login codes, security alerts and verification emails unless they look unexpected.
   Keep titles exactly as written (they are often Korean). Use clean, simple HTML with inline styles (system font, plain headings, light gray separators), plus a plain-text version where Tomato events are marked with 🔴.
5. Send it with the Gmail connector's send_message: to ["YOUR_EMAIL@gmail.com"], the subject above, htmlBody and body. Send exactly one email.
6. Final reply: one line saying it was sent and the subject, or what failed (for example a connector that needs reconnecting in claude.ai Settings → Connectors).
```
