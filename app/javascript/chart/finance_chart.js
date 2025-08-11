import Chart from "chart.js/auto";

document.addEventListener("turbo:load", () => {
  const chartCanvas = document.getElementById("financeChart");
  if (!chartCanvas) return;

  const labels = JSON.parse(chartCanvas.dataset.labels || "[]");
  const income = JSON.parse(chartCanvas.dataset.income || "[]");
  const expense = JSON.parse(chartCanvas.dataset.expense || "[]");

  if (window.financeChart && typeof window.financeChart.destroy === "function") {
    window.financeChart.destroy();
  }

  window.financeChart = new Chart(chartCanvas.getContext("2d"), {
    type: "bar",
    data: {
      labels: labels,
      datasets: [
        {
          label: "Recettes (€)",
          data: income,
          backgroundColor: "#4e73df"
        },
        {
          label: "Dépenses (€)",
          data: expense,
          backgroundColor: "#eb6864"
        }
      ]
    } 
  });
});