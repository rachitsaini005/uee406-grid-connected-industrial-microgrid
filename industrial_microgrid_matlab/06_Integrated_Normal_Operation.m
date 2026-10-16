%% 06 - Integrated Microgrid Normal Operation
% Illustrative dispatch: PV serves load first; surplus charges battery.
% Battery discharge is disabled here to preserve outage reserve.
clc; clear; close all;

load_kW = [100 120 140 160 180 200 160 120 130 150 170 190 250 200 120 110];
hour = 6:21;
dt_h = 1;

PV_kWp = 350; PSH = 5; PR = 0.80;
daily_PV_kWh = PV_kWp * PSH * PR;
factor = [0.05 0.15 0.30 0.50 0.70 0.85 0.95 1.00 0.95 0.80 0.60 0.35 0.10];
PV_kW = zeros(size(load_kW));
PV_kW(1:numel(factor)) = factor * daily_PV_kWh / sum(factor);

battery_kWh = 250;
SOC_min_pct = 10; SOC_max_pct = 100; SOC_pct = SOC_max_pct;
eta_charge = 0.95;
grid_import_kW = zeros(size(hour));
battery_charge_kW = zeros(size(hour));
SOC_trace_pct = zeros(size(hour));

for k = 1:numel(hour)
    surplus_kW = max(PV_kW(k) - load_kW(k), 0);
    deficit_kW = max(load_kW(k) - PV_kW(k), 0);

    storage_headroom_kWh = max(0, (SOC_max_pct - SOC_pct)/100 * battery_kWh);
    charge_kW = min(surplus_kW, storage_headroom_kWh/(eta_charge*dt_h));
    battery_charge_kW(k) = charge_kW;
    SOC_pct = min(SOC_max_pct, SOC_pct + charge_kW*dt_h*eta_charge/battery_kWh*100);

    grid_import_kW(k) = deficit_kW;
    SOC_trace_pct(k) = SOC_pct;
end

figure('Name','Microgrid Energy Management During Normal Operation');
stairs(hour, load_kW, 'LineWidth', 1.5); hold on;
stairs(hour, PV_kW, 'LineWidth', 1.5);
stairs(hour, grid_import_kW, 'LineWidth', 1.5); hold off;
xlabel('Hour of Day'); ylabel('Power (kW)');
title('Microgrid Energy Management During Normal Operation');
legend('Load','PV Output','Grid Import','Location','best'); grid on;

figure('Name','Battery SOC During Normal Operation');
plot(hour, SOC_trace_pct, '-o', 'LineWidth', 1.5);
xlabel('Hour of Day'); ylabel('SOC (%)');
title('Battery State of Charge During Normal Operation'); grid on;
ylim([0 100]);

fprintf('Daily grid import before battery discharge: %.2f kWh\\n', sum(grid_import_kW)*dt_h);
fprintf('Daily battery charging energy (AC-side): %.2f kWh\\n', sum(battery_charge_kW)*dt_h);
