%% 08 - Annual Energy and Cost Comparison
% Uses an assumed effective energy price, not a verified utility tariff.
clc; clear; close all;

load_kW = [100 120 140 160 180 200 160 120 130 150 170 190 250 200 120 110];
operating_days = 300;
daily_load_kWh = sum(load_kW);
annual_load_kWh = daily_load_kWh * operating_days;

PV_kWp = 350; PSH = 5; PR = 0.80;
daily_PV_kWh = PV_kWp*PSH*PR;
factor = [0.05 0.15 0.30 0.50 0.70 0.85 0.95 1.00 0.95 0.80 0.60 0.35 0.10];
PV_kW = factor*daily_PV_kWh/sum(factor);
load_for_PV_hours = load_kW(1:numel(PV_kW));
direct_PV_day_kWh = sum(min(PV_kW,load_for_PV_hours));
annual_direct_PV_kWh = direct_PV_day_kWh*operating_days;

tariff_INR_per_kWh = 8;
baseline_cost_INR = annual_load_kWh*tariff_INR_per_kWh;
grid_after_PV_kWh = max(annual_load_kWh-annual_direct_PV_kWh,0);
cost_after_PV_INR = grid_after_PV_kWh*tariff_INR_per_kWh;
gross_saving_INR = baseline_cost_INR-cost_after_PV_INR;

fprintf('\\nANNUAL ENERGY AND COST COMPARISON\\n');
fprintf('Daily load energy             : %.1f kWh\\n',daily_load_kWh);
fprintf('Annual load energy            : %.1f MWh\\n',annual_load_kWh/1000);
fprintf('Annual PV direct use           : %.1f MWh\\n',annual_direct_PV_kWh/1000);
fprintf('Baseline energy cost           : Rs %.2f lakh/year\\n',baseline_cost_INR/1e5);
fprintf('Cost after direct PV use       : Rs %.2f lakh/year\\n',cost_after_PV_INR/1e5);
fprintf('Gross direct-PV saving         : Rs %.2f lakh/year\\n',gross_saving_INR/1e5);

figure('Name','Preliminary Annual Grid-Energy Comparison');
bar([annual_load_kWh grid_after_PV_kWh]/1000);
set(gca,'XTickLabel',{'Baseline Grid Energy','Grid Energy After Direct PV'});
ylabel('Annual Energy (MWh)');
title('Preliminary Annual Grid-Energy Comparison'); grid on;
