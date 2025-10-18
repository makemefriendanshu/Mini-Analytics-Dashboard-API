// Import only the D3 modules we need to minimize bundle size
import { select, scaleBand, scaleLinear, max, axisBottom, axisLeft } from "d3";

// Renders bar charts for the analytics response
export function renderCharts(data) {
  if (!data || !data.action_wise_counts) return;

  // Clear previous charts
  select("#action-chart").html("");
  select("#user-chart").html("");
  select("#action-user-chart").html("");
  select("#hour-chart").html("");

  // Extract data for action-wise counts
  const actionData = Object.entries(data.action_wise_counts).map(
    ([name, count]) => ({ name, count })
  );

  // Create actionActivity-user data for stacked bars
  const actionUserData = [];
  if (data.action_user_wise_counts) {
    for (const [action, users] of Object.entries(
      data.action_user_wise_counts
    )) {
      actionUserData.push({
        action,
        users: Object.entries(users).map(([user, count]) => ({ user, count })),
      });
    }
  }

  // Create hour data
  const hourData = [];
  if (data.unique_days_hour_wise_counts) {
    for (const [hour, count] of Object.entries(
      data.unique_days_hour_wise_counts
    )) {
      hourData.push({
        name: `${hour}:00`,
        count: typeof count === "number" ? count : Object.keys(count).length,
      });
    }
    hourData.sort((a, b) => parseInt(a.name) - parseInt(b.name));
  }

  // Extract data for most active users
  const userCounts = {};
  if (data.action_user_wise_counts) {
    Object.values(data.action_user_wise_counts).forEach((users) => {
      Object.entries(users).forEach(([user, count]) => {
        userCounts[user] = (userCounts[user] || 0) + count;
      });
    });
  }
  const userDataArray = Object.entries(userCounts).map(([name, count]) => ({
    name,
    count,
  }));

  // Render all charts
  renderBarChart("#action-chart", actionData, "Actions by Type");
  renderBarChart("#user-chart", userDataArray, "User Activity");
  if (actionUserData.length > 0) {
    renderStackedBarChart(
      "#action-user-chart",
      actionUserData,
      "Actions by User"
    );
  }
  if (hourData.length > 0) {
    renderBarChart("#hour-chart", hourData, "Activity by Hour");
  }
}

function renderBarChart(selector, data, title) {
  const container = select(selector).node();
  if (!container) return;

  const margin = { top: 30, right: 20, bottom: 50, left: 50 };

  // Get dimensions from container
  const containerWidth = container.offsetWidth || 400;
  const containerHeight = container.offsetHeight || 300;

  const width = containerWidth - margin.left - margin.right;
  const height = containerHeight - margin.top - margin.bottom;

  const svg = select(selector)
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", `translate(${margin.left},${margin.top})`);

  // Add title
  svg
    .append("text")
    .attr("x", width / 2)
    .attr("y", -margin.top / 2)
    .attr("text-anchor", "middle")
    .style("font-size", "16px")
    .text(title);

  // Create scales
  const x = scaleBand()
    .domain(data.map((d) => d.name))
    .range([0, width])
    .padding(0.2);

  const y = scaleLinear()
    .domain([0, max(data, (d) => d.count)])
    .nice()
    .range([height, 0]);

  // Add axes
  svg
    .append("g")
    .attr("transform", `translate(0,${height})`)
    .call(axisBottom(x))
    .selectAll("text")
    .style("text-anchor", "end")
    .attr("dx", "-.8em")
    .attr("dy", ".15em")
    .attr("transform", "rotate(-45)");

  svg.append("g").call(axisLeft(y));

  // Add bars
  svg
    .selectAll("rect")
    .data(data)
    .join("rect")
    .attr("x", (d) => x(d.name))
    .attr("y", height)
    .attr("width", x.bandwidth())
    .attr("height", 0)
    .attr("fill", "rgb(79, 70, 229)")
    .transition()
    .duration(1000)
    .attr("y", (d) => y(d.count))
    .attr("height", (d) => height - y(d.count));
}

function renderStackedBarChart(selector, data, title) {
  const container = select(selector).node();
  if (!container) return;

  const margin = { top: 30, right: 20, bottom: 50, left: 50 };

  // Get dimensions from container
  const containerWidth = container.offsetWidth || 400;
  const containerHeight = container.offsetHeight || 300;

  const width = containerWidth - margin.left - margin.right;
  const height = containerHeight - margin.top - margin.bottom;

  const svg = select(selector)
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", `translate(${margin.left},${margin.top})`);

  // Add title
  svg
    .append("text")
    .attr("x", width / 2)
    .attr("y", -margin.top / 2)
    .attr("text-anchor", "middle")
    .style("font-size", "16px")
    .text(title);

  // Create scales
  const x = scaleBand()
    .domain(data.map((d) => d.action))
    .range([0, width])
    .padding(0.2);

  const y = scaleLinear()
    .domain([
      0,
      max(data, (d) => d.users.reduce((sum, user) => sum + user.count, 0)),
    ])
    .nice()
    .range([height, 0]);

  // Add axes
  svg
    .append("g")
    .attr("transform", `translate(0,${height})`)
    .call(axisBottom(x))
    .selectAll("text")
    .style("text-anchor", "end")
    .attr("dx", "-.8em")
    .attr("dy", ".15em")
    .attr("transform", "rotate(-45)");

  svg.append("g").call(axisLeft(y));

  // Calculate stack positions
  data.forEach((d) => {
    let y0 = 0;
    d.users.forEach((user) => {
      user.y0 = y0;
      user.y1 = y0 + user.count;
      y0 = user.y1;
    });
  });

  // Define colors before using in stacked bars
  const colors = [
    "rgb(79, 70, 229)",
    "rgb(59, 130, 246)",
    "rgb(16, 185, 129)",
    "rgb(245, 158, 11)",
  ];

  // Add stacked bars with hover tooltip
  const tooltip = select("body")
    .append("div")
    .attr("class", "chart-tooltip")
    .style("position", "absolute")
    .style("background", "#fff")
    .style("border", "1px solid #ccc")
    .style("padding", "6px 10px")
    .style("border-radius", "6px")
    .style("pointer-events", "none")
    .style("font-size", "13px")
    .style("box-shadow", "0 2px 8px rgba(0,0,0,0.12)")
    .style("display", "none");

  data.forEach((d, i) => {
    svg
      .selectAll(`.bar-${i}`)
      .data(d.users)
      .join("rect")
      .attr("class", `bar-${i}`)
      .attr("x", x(d.action))
      .attr("y", height)
      .attr("width", x.bandwidth())
      .attr("height", 0)
      .attr("fill", (_, j) => colors[j % colors.length])
      .on("mousemove", function (event, user) {
        tooltip
          .style("display", "block")
          .html(
            `<strong>User:</strong> ${user.user}<br><strong>Count:</strong> ${user.count}`
          )
          .style("left", event.pageX + 12 + "px")
          .style("top", event.pageY - 18 + "px");
      })
      .on("mouseout", function () {
        tooltip.style("display", "none");
      })
      .transition()
      .duration(1000)
      .attr("y", (user) => y(user.y1))
      .attr("height", (user) => y(user.y0) - y(user.y1));
  });
}

export default { renderCharts };
