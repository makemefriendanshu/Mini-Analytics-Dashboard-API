# Mini-Analytics-Dashboard-API

This repository contains:

- A Phoenix analytics dashboard application (`analytics`)
- Selenium Hound browser automation demo (`selenium_hound_demo`)
- PowerShell integration scripts (`pwsh_script.ps1`)

## Features

- Analytics dashboard with interactive charts and summary views
- Automated browser testing using Elixir and Hound
- PowerShell script to launch the full workflow (Phoenix app, ChromeDriver, automation)

## Quick Start

1. Install dependencies for Elixir, Phoenix, Node.js, and ChromeDriver
2. Start the Phoenix analytics app:
   ```bash
   cd analytics
   mix phx.server
   ```
3. Start ChromeDriver:
   ```bash
   chromedriver --port=9515 &
   ```
4. Run browser automation:
   ```bash
   cd selenium_hound_demo
   mix run run_clicker.exs
   ```
5. Or use the PowerShell script:
   ```bash
   pwsh -File pwsh_script.ps1
   ```

## Folder Structure

- `analytics/` - Phoenix dashboard app
- `selenium_hound_demo/` - Elixir Hound automation
- `pwsh_script.ps1` - PowerShell integration script

## License

MIT
