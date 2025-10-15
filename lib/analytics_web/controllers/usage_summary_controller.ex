defmodule AnalyticsWeb.UsageSummaryController do
  use AnalyticsWeb, :controller

  def summary(conn, param) do
    %{"_json" => list} = param

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
        Enum.max_by(Enum.frequencies(acc_user), fn {_k, v} -> v end) |> Tuple.to_list(),
      peak_activity_time:
        Enum.max_by(Enum.frequencies(acc_time), fn {_k, v} -> v end) |> Tuple.to_list(),
      peak_activity_hour:
        Enum.max_by(Enum.frequencies(acc_hours), fn {_k, v} -> v end) |> Tuple.to_list(),
      message: "Usage summary generated successfully"
      # data: param
    })

    # Logic to generate usage summary for the user
  end
end
