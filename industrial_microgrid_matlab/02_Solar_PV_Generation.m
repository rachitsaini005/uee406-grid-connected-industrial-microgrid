%% 02 - Solar PV Generation and Load Comparison
% Synthetic normalized PV curve scaled to an assumed daily energy.
% This is not site-specific irradiance data.
clc; clear; close all;

load_kW = [100 120 140 160 180 200 160 120 130 150 170 190 250 200 120 110];
load_hours = 6:21;

PV_kWp = 350;
peak_sun_hours = 5;
performance_ratio = 0.80;
daily_PV_kWh = PV_kWp * peak_sun_hours * performance_ratio;
annual_PV_MWh = daily_PV_kWh * 365 / 1000;

solar_factor = [0.05 0.15 0.30 0.50 0.70 0.85 0.95 1.00 0.95 0.80 0.60 0.35 0.10];
solar_hours = 6:18;
PV_kW = solar_factor * daily_PV_kWh / sum(solar_factor);

figure('Name','Industrial Load and Solar PV Generation');
stairs(load_hours, load_kW, 'LineWidth', 1.6); hold on;
stairs(solar_hours, PV_kW, 'LineWidth', 1.6); hold off;
xlabel('Hour of Day'); ylabel('Power (kW)');
title('Industrial Load and Solar PV Generation');
legend('Industrial Load','Solar PV Output','Location','best');
grid on;

fprintf('\\nSOLAR PV ESTIMATE\\n');
fprintf('PV capacity                  : %.1f kWp\\n', PV_kWp);
fprintf('Estimated PV energy          : %.1f kWh/day\\n', daily_PV_kWh);
fprintf('Annualized PV energy         : %.1f MWh/year\\n', annual_PV_MWh);
