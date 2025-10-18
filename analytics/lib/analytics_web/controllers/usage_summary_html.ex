defmodule AnalyticsWeb.UsageSummaryHTML do
  use AnalyticsWeb, :html

  embed_templates "usage_summary_html/*"

  @doc """
  Returns sample JSON data for the prompt template.
  """
  def sample_json() do
    [
      %{"user_id" => "alice", "timestamp" => "2025-09-23T09:10:01Z", "action_type" => "login"},
      %{"user_id" => "bob", "timestamp" => "2025-09-23T09:15:12Z", "action_type" => "view"},
      %{"user_id" => "alice", "timestamp" => "2025-09-23T10:03:23Z", "action_type" => "purchase"},
      %{"user_id" => "alice", "timestamp" => "2025-09-23T09:42:21Z", "action_type" => "login"},
      %{"user_id" => "charlie", "timestamp" => "2025-09-23T09:01:05Z", "action_type" => "login"},
      %{"user_id" => "bob", "timestamp" => "2025-09-23T11:13:45Z", "action_type" => "logout"},
      %{"user_id" => "bob", "timestamp" => "2025-09-23T09:55:32Z", "action_type" => "login"},
      %{"user_id" => "charlie", "timestamp" => "2025-09-24T09:24:02Z", "action_type" => "view"}
    ]
  end
end
