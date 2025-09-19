# CortSineScore
R package to compute a single scalar metric for diurnal cortisol cycle analysis — the Cortisol Sine Score (CSS). Model-free, robust, and ideal for regression, classification, and biomarker research.


---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

```{r, include = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "man/figures/README-",
  out.width = "100%"
)
CortSineScore
CortSineScore is an R package to compute the Cortisol Sine Score (CSS) — a simple, scalar index designed to summarize the daily cortisol cycle using time-of-day salivary cortisol measurements.

Unlike traditional rhythm analysis models (e.g., Cosinor, JTK_CYCLE), CSS provides a model-free, single-value output ideal for regression, classification, and integration in biological studies.

🚀 Installation
To install the latest development version from GitHub:

r
Copy code
# install.packages("remotes")
remotes::install_github("yourusername/CortSineScore")
🔁 Replace "yourusername" with your actual GitHub username.

🧠 How It Works
The Cortisol Sine Score is calculated as:

Where:

Time is extracted from column names (e.g., time_0600, time_1400)

Values before noon (e.g., 0200, 0600) receive positive sine weights

Values after noon (e.g., 1400, 2200) receive negative weights

Interpretation:

Positive CSS → Morning-aligned rhythm

Negative CSS → Evening-shifted or misaligned

Zero CSS → Flat or blunted pattern

🧪 Example
{r
Copy code
library(CortSineScore)

# Create example dataset
df <- tibble::tibble(
  Volunteer.ID = c("S1", "S2"),
  time_0200 = c(2.1, 1.3),
  time_0600 = c(5.4, 3.2),
  time_1000 = c(4.8, 2.5),
  time_1400 = c(3.2, 1.6),
  time_1800 = c(1.0, 1.2),
  time_2200 = c(0.5, 0.6)
)

# Compute CSS
compute_css(df)
📦 Features
✅ Works with datasets with 4+ timepoints (2 before and 2 after noon)

✅ No model fitting required

✅ Extracts time info from column names like time_0200

✅ Verbose mode returns timepoint-level contributions

📜 License
CortSineScore is free to use for academic and research purposes.

Commercial use is not permitted without written permission.

Contact: simone.anza@example.com
