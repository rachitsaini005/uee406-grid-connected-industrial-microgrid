%% 05 - Preliminary Microgrid Power Balance
% Power-balance illustration before battery operation.
clc; clear; close all;

load_kW = [100 120 140 160 180 200 160 120 130 150 170 190 250 200 120 110];
hour = 6:21;
PV_kWp = 350; PSH = 5; PR = 0.80;
daily_PV_kWh = PV_kWp * PSH * PR;
factor = [0.05 0.15 0.30 0.50 0.70 0.85 0.95 1.00 0.95 0.80 0.60 0.35 0.10];

PV_kW = zeros(size(load_kW));
PV_kW(1:numel(factor)) = factor * daily_PV_kWh / sum(factor);

direct_PV_kW = min(load_kW, PV_kW);
surplus_PV_kW = max(PV_kW - load_kW, 0);
grid_deficit_kW = max(load_kW - PV_kW, 0);

figure('Name','Preliminary Microgrid Power Balance');
stairs(hour, load_kW, 'LineWidth', 1.5); hold on;
stairs(hour, PV_kW, 'LineWidth', 1.5);
stairs(hour, grid_deficit_kW, 'LineWidth', 1.5);
stairs(hour, surplus_PV_kW, 'LineWidth', 1.5); hold off;
xlabel('Hour of Day'); ylabel('Power (kW)');
title('Preliminary Microgrid Power Balance');
legend('Load','PV','Grid Deficit Before Battery','Potential PV Surplus','Location','best');
grid on;

fprintf('Direct PV overlap in synthetic operating day: %.2f kWh\\n', sum(direct_PV_kW));
fprintf('Potential PV surplus in modelled hours: %.2f kWh\\n', sum(surplus_PV_kW));
