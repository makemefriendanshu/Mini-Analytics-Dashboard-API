
Write-Host "Hello from PowerShell on Ubuntu!"

# Start the analytics Phoenix application first
Write-Host "Starting Analytics Phoenix app..."
Start-Process "pwsh" -ArgumentList "-NoProfile", "-Command", "cd ./analytics; mix phx.server" -NoNewWindow

# Start ChromeDriver in the background
Write-Host "Starting ChromeDriver..."
Start-Process "chromedriver" -ArgumentList "--port=9515" -NoNewWindow

# Launch the Elixir Hound automation (assumes Elixir and dependencies are installed)
Write-Host "Launching Elixir Hound automation..."
Start-Process "pwsh" -ArgumentList "-NoProfile", "-Command", "cd ./selenium_hound_demo; mix run run_clicker.exs"

exit