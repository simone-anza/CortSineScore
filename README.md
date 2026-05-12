# CortSineScore

A package to compute a single scalar metric for diurnal cortisol cycle analysis — the Cortisol Sine Score (CSS).
Model-free, robust, and ideal for regression, classification, and biomarker research.
---------
🚀 Installation

You can install the development version from GitHub using:

install.packages("remotes")

remotes::install_github("simone-anza/CortSineScore")

-------------------------
# 🧠 What is the Cortisol Sine Score?

The Cortisol Sine Score (CSS) is a simple scalar index calculated as:

CSS = ∑ cortisol_i × sin(2π × time_i / 24)

-------------------------
# Where:
time_i is extracted from column names like time_0600, time_1400, etc.

The sine function gives positive weights to morning timepoints and negative weights to evening timepoints.

You only need a minimum of 4 timepoints (2 before and 2 after 12:00).
----------------------------------------
✅ Interpretation

Positive CSS → Morning-aligned cortisol profile

Negative CSS → Evening-shifted or inverted profile

Near 0 CSS → Blunted or flat profile
--------------------------------
💡 Why use CSS?

Feature	Description

✅ Model-free	No curve fitting, no assumptions about waveform shape

✅ Scalar output	Perfect for regression, classification, clustering

✅ Flexible	Works with any number of cortisol timepoints

✅ Lightweight	One-line computation from raw values

---------------------------------
🔬 Example

library(CortSineScore)

df <- tibble::tibble(
  Volunteer.ID = c("S1", "S2"),
  time_0200 = c(2.1, 1.3),
  time_0600 = c(5.4, 3.2),
  time_1000 = c(4.8, 2.5),
  time_1400 = c(3.2, 1.6),
  time_1800 = c(1.0, 1.2),
  time_2200 = c(0.5, 0.6)
)

compute_css(df)


You’ll get a single column cortisol_sin_score per subject — summarizing their 24h profile.

📦 Features

🔹 Extracts time from column names (e.g., time_0600)

🔹 Works with as few as 4 timepoints (2 before and 2 after noon)

🔹 Optional verbose = TRUE returns per-timepoint contributions

🔹 No dependence on waveform shape — no model assumptions

🔹 Easily integrates into downstream analysis pipelines
------------------
# 📜 License

CortSineScore is free for academic and research use.

For questions, contact:
Contact: simoneanza@gmail.com

📖 Citation
If you use CortSineScore in your research, please cite:
Anzà S, Rosa BA, Herzberg MP, et al. (2025). Simplifying Daily Cortisol 
Cycle Analysis: Validation and Benchmarking of the Cortisol Sine Score 
Against Cosinor and JTK_CYCLE models.
https://www.medrxiv.org/content/10.64898/2026.02.23.26346831v1
