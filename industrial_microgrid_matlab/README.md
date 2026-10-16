# Industrial Microgrid MATLAB Scripts

This folder contains 10 standalone MATLAB `.m` scripts for the UEE406 industrial microgrid project.

## Files
1. `01_Industrial_Load_Profile.m`
2. `02_Solar_PV_Generation.m`
3. `03_Battery_Sizing_SOC.m`
4. `04_Diesel_Generator_Sizing.m`
5. `05_Preliminary_Microgrid_Power_Balance.m`
6. `06_Integrated_Normal_Operation.m`
7. `07_Grid_Outage_Simulation.m`
8. `08_Annual_Energy_Cost_Comparison.m`
9. `09_20_Year_Financial_Analysis.m`
10. `10_Sensitivity_Analysis.m`

## How to run
Open MATLAB, set the Current Folder to this directory, and run each script individually. Scripts clear the workspace and figures, so run them one at a time.

## Model limitations
- The load profile and normalized solar curve are illustrative, not measured site data.
- The assumed effective tariff of INR 8/kWh and capital/operating costs are placeholders.
- The grid-outage model is an energy-balance illustration, not a dynamic, protection, or islanding validation.
- The financial script includes an illustrative battery replacement in year 10.
- Sensitivity outputs are recomputed from the cash flows defined in the script and may not exactly match earlier screenshots if those used different replacement assumptions or formulas.
- Validate all inputs and outputs before using for engineering or investment decisions.
