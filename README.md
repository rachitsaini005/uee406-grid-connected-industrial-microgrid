# Design, Simulation and Techno-Economic Feasibility Analysis of a Grid-Connected Industrial Microgrid

A MATLAB-based academic project evaluating a conceptual industrial microgrid that integrates **solar photovoltaic (PV) generation, battery energy storage (BESS), diesel backup generation, and the utility grid**. The project combines load assessment, preliminary component sizing, energy-flow modelling, outage analysis, and a 20-year techno-economic assessment.

> **Project status:** Preliminary academic design using illustrative assumptions and a synthetic load profile. It is not a site-certified engineering design, a detailed electromagnetic-transient simulation, or an investment-grade financial study.

## Table of Contents

- [Objectives](#objectives)
- [System Overview](#system-overview)
- [Design Basis and Assumptions](#design-basis-and-assumptions)
- [Methodology](#methodology)
- [MATLAB Scripts](#matlab-scripts)
- [Report and Figures](#report-and-figures)
- [How to Run](#how-to-run)
- [Key Preliminary Results](#key-preliminary-results)
- [Techno-Economic Model](#techno-economic-model)
- [Limitations and Further Work](#limitations-and-further-work)
- [Repository Structure](#repository-structure)
- [Reproducibility and Data Notes](#reproducibility-and-data-notes)

## Objectives

1. Develop a representative industrial electricity-demand profile.
2. Estimate solar PV generation using an assumed peak-sun-hours value and performance ratio.
3. size a battery energy storage system for critical-load backup.
4. Estimate a suitable diesel-generator rating for prolonged outages.
5. Explore preliminary power balance and energy-management behaviour during normal operation.
6. Model a simplified grid-outage sequence involving battery support and diesel-generator takeover.
7. Compare annual grid-energy requirements before and after direct use of solar PV.
8. Estimate indicative project costs and evaluate cash flow, NPV, IRR, payback, and sensitivity to selected assumptions.
9. Discuss operational, protection, environmental, and implementation considerations.

## System Overview

The conceptual architecture contains:

- **Utility grid:** Supplies the site's remaining demand when local generation is insufficient.
- **Solar PV:** A proposed 350 kWp array supplying the industrial load when solar energy is available.
- **Battery energy storage system:** A proposed 250 kWh battery with a candidate 125 kW bidirectional converter.
- **Diesel generator:** A candidate 150 kVA standby source for prolonged grid interruptions.
- **Industrial load:** A representative load with a peak hourly-average demand of 250 kW and a designated critical load of 100 kW.
- **Energy-management and protection functions:** Supervisory control, source coordination, grid isolation, islanding, synchronization, and load-shedding functions that would be required in a real implementation.

The scripts are calculation and plotting models in MATLAB. They do **not** constitute a detailed Simulink switching model or validate dynamic voltage/frequency behaviour, transient stability, relay coordination, or protection settings.

## Design Basis and Assumptions

The values below are project assumptions for a preliminary study, not measurements from a named industrial facility.

| Parameter | Preliminary value | Notes |
|---|---:|---|
| Study location | Punjab, India | General location assumption |
| Nominal LV reference | 415 V, three-phase | An actual facility may be supplied at medium/high voltage |
| Frequency | 50 Hz | Assumed system frequency |
| Industrial peak hourly-average load | 250 kW | Based on the synthetic profile |
| Operating schedule | 16 h/day, 300 days/year | Simplified production schedule |
| Critical load | 100 kW | Used for backup sizing |
| Critical-load backup target | 2 h | Before accounting for end-of-life and reserve margins |
| Solar PV capacity | 350 kWp | Candidate array size |
| Solar resource assumption | 5 peak-sun-hours/day | Illustrative; not a site-specific resource assessment |
| PV performance ratio | 0.80 | Simplified overall derating factor |
| BESS nominal energy | 250 kWh | Candidate capacity |
| BESS converter rating | 125 kW | Candidate bidirectional power rating |
| Battery depth of discharge | 90% | Assumption |
| Battery discharge efficiency | 95% | Assumption |
| Diesel generator | 150 kVA | Candidate rating; verify transient and derating requirements |
| Financial evaluation period | 20 years | Assumed study horizon |
| Effective electricity tariff | ₹8/kWh | Illustrative model input, not a confirmed bill tariff |
| Illustrative emissions factor | 0.70 tCO₂/MWh | Must be replaced with an applicable, verified factor for formal reporting |

### Synthetic industrial load profile

The 16 hourly values used in the model are:

```text
100, 120, 140, 160, 180, 200, 160, 120,
130, 150, 170, 190, 250, 200, 120, 110 kW
```

Their sum is **2,500 kWh per operating day**, with a mean of **156.25 kW** across the 16 modelled operating hours and a peak hourly-average value of **250 kW**.

At 300 operating days per year, the modelled annual load energy is:

**2,500 kWh/day × 300 days/year = 750,000 kWh/year = 750 MWh/year.**

Standby consumption and non-production days are not separately modelled.

## Methodology

### 1. Load assessment

A synthetic 16-hour demand profile is created and plotted. Daily energy is calculated by summing the hourly values. Annual energy is calculated using the assumed 300 operating days per year.

### 2. Solar PV estimate

The preliminary daily PV-energy estimate is:

**Daily PV energy = PV capacity × peak-sun-hours × performance ratio**

Using the design assumptions:

**350 kWp × 5 h/day × 0.80 = 1,400 kWh/day.**

This corresponds to approximately **511 MWh/year** if annualized over 365 days. The model uses a synthetic hourly PV shape; this is not a substitute for measured irradiance, a site-specific PV simulation, or seasonal modelling.

### 3. Direct PV utilization and grid imports

The simplified energy calculation prioritizes direct PV use against the load. The preliminary model estimates approximately **1,250.4 kWh per operating day** of direct PV use, or about **375.1 MWh/year** over 300 operating days. Under this simplified calculation, remaining grid imports are approximately **374.9 MWh/year**.

These are model estimates. The ratio of annual PV generation to annual load is not the same as the fraction of demand served by PV because solar production and load do not necessarily occur at the same time.

### 4. Battery sizing

The ideal AC energy needed to supply a 100 kW critical load for two hours is:

**Required AC backup energy = 100 kW × 2 h = 200 kWh.**

With 90% depth of discharge and 95% discharge efficiency, the preliminary nominal battery requirement is:

**Nominal battery energy = 200 / (0.90 × 0.95) ≈ 233.9 kWh.**

A 250 kWh candidate battery provides about **213.75 kWh** of AC-equivalent energy under these assumptions, or approximately **2.14 hours** at 100 kW when new and fully charged. This leaves limited margin for ageing, reserve state of charge, auxiliaries, temperature effects, and real operating constraints.

### 5. Diesel-generator sizing

At a 100 kW critical load and assumed power factor of 0.9:

**Required apparent power = 100 / 0.9 ≈ 111.1 kVA.**

If the design target is to keep the generator at or below 80% loading:

**Candidate rating = 111.1 / 0.80 ≈ 138.9 kVA.**

A 150 kVA generator is therefore used as a candidate for the preliminary study. Final selection must consider motor starting, step loads, harmonics, ambient-temperature and altitude derating, manufacturer performance curves, fuel storage, emissions rules, and applicable standards.

### 6. Operating and outage cases

The normal-operation model uses PV against load, routes surplus PV to battery charging within the simplified model, and uses the grid to supply a deficit. Battery discharge is restricted in this case to preserve reserve.

The outage model represents a simplified battery-supported interval followed by diesel-generator takeover after an assumed start delay. It does not simulate switching transients, synchronization, detailed converter control, or dynamic voltage/frequency response.

### 7. Financial evaluation

The financial model estimates capital expenditure, annual operating cost, energy-cost savings, and cash flow over 20 years. It calculates or plots financial indicators and performs sensitivity analysis for selected variables. All outputs depend on the assumptions and implementation in the scripts.

## MATLAB Scripts

The repository's MATLAB package contains these ten scripts:

| Script | Purpose |
|---|---|
| `01_Industrial_Load_Profile.m` | Defines the synthetic load profile, calculates daily/annual energy, and plots the load |
| `02_Solar_PV_Generation.m` | Estimates and plots a representative PV-generation profile |
| `03_Battery_Sizing_SOC.m` | Calculates preliminary BESS energy requirements and plots battery state of charge for critical-load backup |
| `04_Diesel_Generator_Sizing.m` | Estimates the apparent-power requirement and compares it with the candidate generator rating |
| `05_Preliminary_Microgrid_Power_Balance.m` | Illustrates the preliminary load, PV, and power-balance relationship |
| `06_Integrated_Normal_Operation.m` | Models simplified normal-operation energy management and battery SOC |
| `07_Grid_Outage_Simulation.m` | Models battery support and diesel-generator takeover during a simplified grid outage |
| `08_Annual_Energy_Cost_Comparison.m` | Compares baseline grid energy with the simplified PV-assisted case |
| `09_20_Year_Financial_Analysis.m` | Evaluates indicative project cash flow and financial indicators over 20 years |
| `10_Sensitivity_Analysis.m` | Examines how selected assumptions affect NPV |

A `README.md` is also included in the MATLAB scripts package. The report contains the reconstructed MATLAB code in its appendices. Because scripts may have been reconstructed separately from earlier screenshots, do not assume every console value in a screenshot will exactly match a fresh run of the supplied code.

## Report and Figures

The detailed report is provided as a Word document:

**`Industrial_Microgrid_Detailed_Report_with_Figures_and_Code.docx`**

It includes the project discussion, design calculations, figures, financial analysis, limitations, conclusions, and MATLAB code appendices.

### Report-image archive

The descriptively renamed report-image package is:

**`Industrial_Microgrid_Report_Images_Descriptive_Names.zip`**

It contains the `Report_Images/` folder and `README_Image_Index.txt`. The archive is intended to include the 21 screenshots used in the report, with names based on their subject or report figure rather than screenshot timestamps.

Representative figure names include:

- `Fig_1.1_Representative_Industrial_Load_Profile.png`
- `Fig_2.1_Industrial_Load_and_Solar_PV_Generation.png`
- `Fig_3.1_Battery_SOC_During_Critical_Load_Backup.png`
- `Fig_4.1_Critical_Load_and_Candidate_Diesel_Generator_Rating.png`
- `Fig_5.1_Preliminary_Microgrid_Power_Balance.png`
- `Fig_6.1_Microgrid_Energy_Management_During_Normal_Operation.png`
- `Fig_6.2_Battery_SOC_During_Normal_Operation.png`
- `Fig_7.1_Battery_Only_Backup_During_Grid_Outage.png`
- `Fig_7.2_Battery_and_Diesel_Generator_During_Prolonged_Outage.png`
- `Fig_8.1_Preliminary_Annual_Grid_Energy_Comparison.png`

Other images cover financial cash flow and sensitivity-analysis outputs. Refer to `README_Image_Index.txt` inside the archive for the complete image index.

A broader original screenshot archive may also be retained for traceability, but the descriptively renamed archive is the preferred image package for organizing the report figures.

## How to Run

1. Install MATLAB with standard plotting functionality.
2. Download or clone the repository.
3. Extract the MATLAB scripts archive if the `.m` files are packaged in a ZIP.
4. Add the folder containing the scripts to the MATLAB path, or set it as the current folder.
5. Run the scripts individually in numerical order, starting with `01_Industrial_Load_Profile.m`.
6. Review the Command Window output and generated plots.
7. Compare the new outputs with the report, keeping in mind that reconstructed scripts may not exactly reproduce every earlier screenshot.

The scripts are intended to be run individually. Unless a script explicitly saves a figure or output file, MATLAB will display results in the current session rather than automatically export them.

## Key Preliminary Results

| Metric | Preliminary result | Interpretation |
|---|---:|---|
| Daily industrial energy | 2,500 kWh/day | Synthetic 16-hour operating profile |
| Annual industrial energy | 750 MWh/year | 300 operating days/year |
| Peak hourly-average demand | 250 kW | Based on the assumed profile |
| Estimated PV energy | 1,400 kWh/day | 350 kWp × 5 PSH × 0.80 PR |
| Annualized PV generation | 511 MWh/year | Uses 365-day annualization |
| Direct PV utilization | About 375.1 MWh/year | Simplified operating-day model |
| Remaining grid imports | About 374.9 MWh/year | Simplified direct-PV-use calculation |
| Minimum nominal BESS estimate | About 233.9 kWh | For 100 kW × 2 h at assumed DoD/efficiency |
| Candidate BESS | 250 kWh / 125 kW converter | Limited margin for ageing and reserves |
| Candidate diesel generator | 150 kVA | Requires detailed equipment and transient checks |

The values are preliminary and should be recalculated when real load data, site solar data, utility bills, vendor quotations, and operating requirements become available.

## Techno-Economic Model

The illustrative financial case uses the following preliminary inputs:

| Item | Illustrative value |
|---|---:|
| PV capital cost | ₹126 lakh |
| BESS capital cost | ₹62.5 lakh |
| Diesel-generator capital cost | ₹15 lakh |
| Integration cost | ₹20 lakh |
| Other project costs | ₹10 lakh |
| **Total indicative CAPEX** | **₹233.5 lakh** |
| Annual OPEX | ₹5 lakh/year |
| Effective tariff used in the model | ₹8/kWh |
| Evaluation period | 20 years |
| Discount rate used in the base sensitivity case | 10% |

These values are assumptions for academic analysis, not binding quotes. Verify what each cost includes and avoid double counting equipment, installation, power conversion systems, civil work, taxes, interconnection, and commissioning.

An earlier model/screenshot reported a simple payback of approximately **11.09 years**, an IRR of approximately **7.51%**, and an NPV of approximately **−₹37.44 lakh at a 10% discount rate**. These are historical outputs from the earlier model and may not be reproduced exactly by the reconstructed scripts. Treat them as provisional until the model and cash flows have been reconciled and independently checked.

Sensitivity analysis is included because project economics can change materially with tariff, installed cost, operating expenses, PV utilization, and discount rate. A real decision should also account for battery replacement, degradation, financing, taxes, escalation, demand charges, export compensation, fuel costs, maintenance, and downtime where relevant.

## Limitations and Further Work

This project is a preliminary academic study. Before real-world implementation, the following work is needed:

- Replace the synthetic load profile with interval-meter data covering representative operating seasons.
- Confirm the site's actual supply voltage, tariff category, billing rules, power factor, demand charges, and export/interconnection conditions.
- Use site-specific solar-resource data and a validated PV-yield model that accounts for orientation, shading, temperature, losses, and seasonal variation.
- Model battery degradation, usable energy at end of life, reserve SOC, round-trip efficiency, auxiliary consumption, and replacement timing.
- Obtain vendor quotations and performance curves for PV, BESS, converter, diesel generator, switchgear, protection, and integration.
- Perform short-circuit, load-flow, protection-coordination, earthing, harmonic, transient, and islanding studies.
- Design safe utility isolation and reconnection, synchronization, anti-islanding protection, load shedding, and grid-forming/grid-following control as appropriate.
- Verify fuel consumption using the selected generator's manufacturer data and expected loading profile.
- Use an applicable, verified emissions factor and define the accounting boundary before reporting avoided emissions.
- Reconcile all cash-flow formulas, replacement assumptions, escalation, discounting, and financial indicators before using results for investment decisions.

The simplified outage logic does not establish that the proposed system can safely or reliably operate as an islanded microgrid. Detailed engineering and compliance review are essential.

## Repository Structure

A suggested GitHub layout is:

```text
industrial-microgrid/
├── README.md
├── industrial_microgrid_matlab/
│   ├── 01_Industrial_Load_Profile.m
│   ├── 02_Solar_PV_Generation.m
│   ├── 03_Battery_Sizing_SOC.m
│   ├── 04_Diesel_Generator_Sizing.m
│   ├── 05_Preliminary_Microgrid_Power_Balance.m
│   ├── 06_Integrated_Normal_Operation.m
│   ├── 07_Grid_Outage_Simulation.m
│   ├── 08_Annual_Energy_Cost_Comparison.m
│   ├── 09_20_Year_Financial_Analysis.m
│   ├── 10_Sensitivity_Analysis.m
│   └── README.md
├── industrial_microgrid_report/
│   └── Industrial_Microgrid_Detailed_Report_with_Figures_and_Code.pdf
└── Industrial_Microgrid_Report_Images_/
    ├── README_Image_Index.txt
    ├── Fig_1.1_Representative_Industrial_Load_Profile.png
    ├── ...
    └── other report figures and analysis outputs
```

The layout above is a recommended repository organization. The downloadable ZIP archives may need to be extracted and their contents moved into these folders before committing to GitHub.

## Reproducibility and Data Notes

- All load data and operating schedules are illustrative unless explicitly identified otherwise.
- PV output is based on assumed peak-sun-hours, performance ratio, and a synthetic hourly shape.
- The ₹8/kWh tariff and cost estimates are model inputs, not verified current quotations or a substitute for the site's applicable tariff order.
- Annual PV generation and direct PV utilization use different time bases in the simplified model: PV generation is annualized over 365 days, while the industrial operating profile uses 300 days/year.
- Financial indicators depend on cash-flow timing, replacement assumptions, tariff, costs, and discount rate. Recalculate them from the current scripts before citing them as final results.
- Screenshots are included as report figures and may represent outputs from an earlier version of the calculations.
- This repository is intended for educational and preliminary feasibility analysis. It does not replace professional electrical design, statutory approvals, or a bankable feasibility study.

## Acknowledgements

Prepared as an academic power-system practices project. The work applies concepts from load assessment, distributed generation, energy storage, backup generation, energy management, and techno-economic evaluation.

