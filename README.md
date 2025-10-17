# Analytics

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4003`](http://localhost:4003) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Mini Analytics Dashboard API

Objective:

Build a simplified backend REST API for an analytics dashboard that summarizes and visualizes usage statistics of a service, using any preferred language from their skillset (Python, Go, or Rust).
Requirements
REST Endpoint:
/usage-summary
Accepts a list of (user_id, timestamp, action_type) as JSON input (simulating usage logs).
Returns a JSON summary containing:
Total number of unique users
Action-wise counts (how many times each action_type occurred)
Most active user (user_id with the most actions)
Time window with highest activity (hour with most log entries)
Bonus:
“/health” endpoint that checks server status (and any dependencies, if implemented).
If time allows, serve a simple HTML page with a D3.js (or chart library) visualization of action counts (not required for completion, for extra credit).
Guidelines
You can choose your stack (Go, Python, Rust).
All logic should be within a single file for simplicity.
Must show understanding of REST APIs, data aggregation, and efficient counting.
Use of any in-memory structure (dicts/maps/etc.), no DB needed.
Add basic error handling in endpoints.

INPUT JSON:
[
{"user_id": "alice", "timestamp": "2025-09-23T09:10:01Z", "action_type": "login"},
{"user_id": "bob", "timestamp": "2025-09-23T09:15:12Z", "action_type": "view"},
{"user_id": "alice", "timestamp": "2025-09-23T10:03:23Z", "action_type": "purchase"},
{"user_id": "alice", "timestamp": "2025-09-23T09:42:21Z", "action_type": "login"},
{"user_id": "charlie", "timestamp": "2025-09-23T09:01:05Z", "action_type": "login"},
{"user_id": "bob", "timestamp": "2025-09-23T11:13:45Z", "action_type": "logout"},
{"user_id": "bob", "timestamp": "2025-09-23T09:55:32Z", "action_type": "login"},
{"user_id": "charlie", "timestamp": "2025-09-23T09:23:02Z", "action_type": "view"}
]

## TO Run

in cmd prompt -> mix phx.server

1. http://localhost:4003/api/swagger

2. curl -X POST -H "Content-Type: application/json" \
    --data '[
   {"user_id": "alice", "timestamp": "2025-09-23T09:10:01Z", "action_type": "login"},
   {"user_id": "bob", "timestamp": "2025-09-23T09:15:12Z", "action_type": "view"},
   {"user_id": "alice", "timestamp": "2025-09-23T10:03:23Z", "action_type": "purchase"},
   {"user_id": "alice", "timestamp": "2025-09-23T09:42:21Z", "action_type": "login"},
   {"user_id": "charlie", "timestamp": "2025-09-23T09:01:05Z", "action_type": "login"},
   {"user_id": "bob", "timestamp": "2025-09-23T11:13:45Z", "action_type": "logout"},
   {"user_id": "bob", "timestamp": "2025-09-23T09:55:32Z", "action_type": "login"},
   {"user_id": "charlie", "timestamp": "2025-09-23T09:23:02Z", "action_type": "view"}
   ]' \
    http://localhost:4003/api/usage-summary

## Result

{"message":"Usage summary generated successfully","unique_users":["charlie","bob","alice"],"action_wise_counts":{"login":4,"logout":1,"purchase":1,"view":2},"most_active_user":["alice",3],"peak_activity_time":["2025-09-23T09:01:05Z",1],"peak_activity_hour":[9,6]}

[Screencast from 15-10-25 05:38:41 PM IST.webm](https://github.com/user-attachments/assets/8f4e1790-f752-4705-b27b-0d940b290b0d)
