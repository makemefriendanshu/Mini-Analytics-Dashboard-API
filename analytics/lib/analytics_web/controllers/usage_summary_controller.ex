defmodule AnalyticsWeb.UsageSummaryController do
  use AnalyticsWeb, :controller
  use PhoenixSwagger

  def prompt(conn, _params) do
    # "Generate a usage summary report from the given user activity data, including unique users, action-wise counts, most active user, peak activity time, and peak activity hour."
    render(conn, :prompt)
  end

  swagger_path :summary do
    post("/api/usage-summary")
    description("List usage summary")
    consumes("application/json")
    produces("application/json")

    parameters do
      data(:body, Schema.ref(:DataList), "data_list", required: true)
    end

    response(200, "Success")
  end

  def swagger_definitions do
    %{
      DataList:
        swagger_schema do
          title("DataList")
          type(:array)
          items(Schema.ref(:Data))

          example([
            %{
              "user_id" => "alice",
              "timestamp" => "2025-09-23T09:10:01Z",
              "action_type" => "login"
            },
            %{"user_id" => "bob", "timestamp" => "2025-09-23T09:15:12Z", "action_type" => "view"},
            %{
              "user_id" => "alice",
              "timestamp" => "2025-09-23T10:03:23Z",
              "action_type" => "purchase"
            },
            %{
              "user_id" => "alice",
              "timestamp" => "2025-09-23T09:42:21Z",
              "action_type" => "login"
            },
            %{
              "user_id" => "charlie",
              "timestamp" => "2025-09-23T09:01:05Z",
              "action_type" => "login"
            },
            %{
              "user_id" => "bob",
              "timestamp" => "2025-09-23T11:13:45Z",
              "action_type" => "logout"
            },
            %{
              "user_id" => "bob",
              "timestamp" => "2025-09-23T09:55:32Z",
              "action_type" => "login"
            },
            %{
              "user_id" => "charlie",
              "timestamp" => "2025-09-24T09:23:02Z",
              "action_type" => "view"
            }
          ])
        end,
      Data:
        swagger_schema do
          title("Data")
          description("A single user action data point")
          type(:object)

          properties do
            user_id(:string, "ID of the user", required: true)
            timestamp(:string, "ISO8601 formatted timestamp", required: true)
            action_type(:string, "Type of action performed", required: true)
          end

          example(%{
            "user_id" => "Jane Doe",
            "timestamp" => "2023-01-01T12:00:00Z",
            "action_type" => "login"
          })
        end
    }
  end

  def summary(conn, %{"_json" => list} = _param) do
    {acc_user, acc_time, acc_action} =
      list
      |> Enum.reduce({[], [], []}, fn %{
                                        "user_id" => user,
                                        "timestamp" => time,
                                        "action_type" => action
                                      } = _item,
                                      {acc_user, acc_time, acc_action} ->
        {[user] ++ acc_user, [time] ++ acc_time, [action] ++ acc_action}
      end)

    acc_hours =
      Enum.map(acc_time, fn x -> DateTime.from_iso8601(x) end)
      |> Enum.map(fn {:ok, dt, _} -> dt.hour end)

    conn
    |> json(%{
      unique_users: Enum.uniq(acc_user),
      action_wise_counts: Enum.frequencies(acc_action),
      action_user_wise_counts:
        Enum.reduce(list, %{}, fn %{"action_type" => action, "user_id" => user}, acc ->
          Map.update(acc, action, %{user => 1}, fn user_map ->
            Map.update(user_map, user, 1, &(&1 + 1))
          end)
        end),
      most_active_user:
        case Enum.max_by(Enum.frequencies(acc_user), fn {_k, v} -> v end) do
          {k, v} -> %{value: k, count: v}
        end,
      unique_days: Enum.uniq(Enum.map(acc_time, fn x -> String.slice(x, 0, 10) end)),
      unique_days_hour_wise_counts:
        Enum.reduce(acc_time, %{}, fn time, acc ->
          day = String.slice(time, 0, 10)
          hour = String.slice(time, 11, 2) |> String.to_integer()

          Map.update(acc, day, %{hour => 1}, fn hour_map ->
            Map.update(hour_map, hour, 1, &(&1 + 1))
          end)
        end),
      peak_activity_hour:
        case Enum.max_by(Enum.frequencies(acc_hours), fn {_k, v} -> v end) do
          {k, v} -> %{value: k, count: v}
        end,
      message: "Usage summary generated successfully"
    })
  end
end
