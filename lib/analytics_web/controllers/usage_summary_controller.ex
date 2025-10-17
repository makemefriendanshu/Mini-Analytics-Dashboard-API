defmodule AnalyticsWeb.UsageSummaryController do
  use AnalyticsWeb, :controller
  use PhoenixSwagger

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
              "user_id" => "Jane Doe",
              "timestamp" => "2023-01-01T12:00:00Z",
              "action_type" => "login"
            },
            %{
              "user_id" => "John Smith",
              "timestamp" => "2023-01-01T12:05:00Z",
              "action_type" => "logout"
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
      most_active_user:
        case Enum.max_by(Enum.frequencies(acc_user), fn {_k, v} -> v end) do
          {k, v} -> %{value: k, count: v}
        end,
      peak_activity_time:
        case Enum.max_by(Enum.frequencies(acc_time), fn {_k, v} -> v end) do
          {k, v} -> %{value: k, count: v}
        end,
      peak_activity_hour:
        case Enum.max_by(Enum.frequencies(acc_hours), fn {_k, v} -> v end) do
          {k, v} -> %{value: k, count: v}
        end,
      message: "Usage summary generated successfully"
    })
  end
end
