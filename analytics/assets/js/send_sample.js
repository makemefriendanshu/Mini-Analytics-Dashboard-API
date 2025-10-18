function generateRandomJson() {
  const users = ["alice", "bob", "charlie", "dave", "eve"];
  const actions = ["login", "view", "click", "search", "logout"];
  const count = Math.floor(Math.random() * 6) + 10; // Generate 10-15 entries
  const now = new Date();
  const data = [];
  for (let i = 0; i < count; i++) {
    const timestamp = new Date(now - Math.random() * 86400000); // Random time within last 24 hours
    data.push({
      user_id: users[Math.floor(Math.random() * users.length)],
      timestamp: timestamp.toISOString(),
      action_type: actions[Math.floor(Math.random() * actions.length)],
    });
  }
  return data;
}
import { renderCharts } from "./charts";

// Reads JSON from textarea #sample-input and sends it to /api/usage-summary. Shows response in #sample-response and charts

function parseJsonOrShowError(text) {
  try {
    return { ok: true, value: JSON.parse(text) };
  } catch (e) {
    return { ok: false, error: e.message };
  }
}

async function sendFromTextarea() {
  const textarea = document.getElementById("sample-input");
  const responseEl = document.getElementById("sample-response");
  if (!textarea) {
    console.error("sample-input textarea not found");
    return;
  }

  const text = textarea.value.trim();
  if (!text) {
    responseEl &&
      (responseEl.textContent = "Please enter JSON payload in the textbox.");
    return;
  }

  const parsed = parseJsonOrShowError(text);
  if (!parsed.ok) {
    responseEl && (responseEl.textContent = "Invalid JSON: " + parsed.error);
    return;
  }

  try {
    const resp = await fetch("/api/usage-summary", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(parsed.value),
    });

    const data = await resp.json();
    console.log("Server response", data);
    if (responseEl) responseEl.textContent = JSON.stringify(data, null, 2);

    // Show charts container after successful response
    const chartsContainer = document.getElementById("charts-container");
    if (chartsContainer) chartsContainer.classList.remove("hidden");

    // Render charts with the response data
    renderCharts(data);
  } catch (err) {
    console.error("Error sending payload", err);
    if (responseEl) responseEl.textContent = "Network error: " + err.message;
  }
}

function init() {
  // Hide charts container on load
  const chartsContainer = document.getElementById("charts-container");
  if (chartsContainer) chartsContainer.classList.add("hidden");

  const btn = document.getElementById("send-sample");
  if (btn) btn.addEventListener("click", sendFromTextarea);

  const generateBtn = document.getElementById("generate-sample");
  if (generateBtn) {
    generateBtn.addEventListener("click", () => {
      const textarea = document.getElementById("sample-input");
      if (textarea) {
        const randomData = generateRandomJson();
        textarea.value = JSON.stringify(randomData, null, 2);
      }
    });
  }
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", init);
} else {
  init();
}

export default {};
