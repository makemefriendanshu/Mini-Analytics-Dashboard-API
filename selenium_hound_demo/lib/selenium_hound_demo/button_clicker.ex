defmodule SeleniumHoundDemo.ButtonClicker do
  use Hound.Helpers

  def run do
    Hound.start_session()
    # Maximize browser window for full screen
    set_window_size(current_window_handle(), 1920, 1080)

    try do
      # Change this URL to your target page
      navigate_to("http://localhost:4003")
      # Click the 'Try Usage Summary' link by its text or class
      link = find_element(:xpath, "//a[contains(text(), 'Try Usage Summary')]")
      click(link)

      # Wait for the 'Send JSON from textbox' button to appear
      # Wait 2 seconds for page transition
      :timer.sleep(2000)
      send_btn = find_element(:id, "send-sample")
      click(send_btn)

      # Wait for any page updates after click
      :timer.sleep(2000)

      # Scroll to bottom of the page
      execute_script("window.scrollTo(0, document.body.scrollHeight);")

      # Final wait for observation or page updates
      :timer.sleep(3000)

      # Ensure graphs are visible (assume graphs have class 'chart' or 'graph')
      # Check for the #action-chart graph container
      graph_div = find_element(:id, "action-chart")

      is_visible =
        execute_script(
          "return arguments[0].offsetParent !== null && arguments[0].offsetWidth > 0 && arguments[0].offsetHeight > 0;",
          [graph_div]
        )

      if is_visible do
        IO.puts("Graph #action-chart is visible!")
      else
        IO.puts("Graph #action-chart is NOT visible!")
      end

      # Add more button clicks or actions as needed
      IO.puts("Button clicked successfully!")
    rescue
      e -> IO.puts("Error: #{inspect(e)}")
    after
      Hound.end_session()
    end
  end
end
