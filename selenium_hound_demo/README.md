# Selenium Hound Demo

This project demonstrates browser automation for a Phoenix analytics dashboard using Elixir and the Hound library.

## Features

- Launches Chrome browser and navigates to the analytics app
- Clicks the "Try Usage Summary" link and "Send JSON from textbox" button
- Waits for page transitions and scrolls to the bottom
- Checks visibility of the main graph container (`#action-chart`)
- Runs in full screen (1920x1080)

## Usage

1. Ensure ChromeDriver is running on port 9515:
   ```bash
   chromedriver --port=9515 &
   ```
2. Start the Phoenix analytics app (in a separate terminal):
   ```bash
   cd ../analytics
   mix phx.server
   ```
3. Run the automation:
   ```bash
   mix run run_clicker.exs
   ```

## Requirements

- Elixir >= 1.10
- Hound library
- ChromeDriver
- Phoenix analytics app running at http://localhost:4003

## Files

- `lib/selenium_hound_demo/button_clicker.ex`: Main automation logic
- `run_clicker.exs`: Entry point for automation
- `.gitignore`: Standard Elixir/Phoenix ignores

## Customization

- Update selectors in `button_clicker.ex` to target different elements or add more actions.

## License

MIT
