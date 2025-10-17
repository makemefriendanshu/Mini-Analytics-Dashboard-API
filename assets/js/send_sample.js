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

    // Render charts with the response data
    renderCharts(data);
  } catch (err) {
    console.error("Error sending payload", err);
    if (responseEl) responseEl.textContent = "Network error: " + err.message;
  }
}

function init() {
  const btn = document.getElementById("send-sample");
  if (btn) btn.addEventListener("click", sendFromTextarea);
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", init);
} else {
  init();
}

export default {};
