%% 07 - Simplified Grid-Outage Scenarios
% Scenario 1: battery supplies 100 kW for up to two hours.
% Scenario 2: battery bridges a 0.25 h DG start delay, then DG supplies load.
% Illustrative energy model only; not a dynamic or protection simulation.
clc; clear; close all;

Pcritical_kW = 100;
battery_kWh = 250;
eta_discharge = 0.95;
SOC_initial_pct = 100;
SOC_min_pct = 10;
dt_h = 0.01;

% Scenario 1: battery-only
t1_h = 0:dt_h:2;
SOC1_pct = zeros(size(t1_h));
SOC1_pct(1) = SOC_initial_pct;
for k = 2:numel(t1_h)
    dSOC = Pcritical_kW*dt_h/(battery_kWh*eta_discharge)*100;
    SOC1_pct(k) = max(SOC_min_pct, SOC1_pct(k-1)-dSOC);
end

figure('Name','Battery Only Backup During Grid Outage');
plot(t1_h, SOC1_pct, 'LineWidth', 1.6);
xlabel('Time (h)'); ylabel('Battery SOC (%)');
title('Battery-Only Backup During Grid Outage'); grid on; ylim([0 100]);

% Scenario 2: battery bridges startup delay; DG supplies critical load afterwards
startup_delay_h = 0.25;
t2_h = 0:dt_h:2;
SOC2_pct = SOC_initial_pct * ones(size(t2_h));
P_battery_kW = zeros(size(t2_h));
P_DG_kW = zeros(size(t2_h));

SOC_after_start_pct = max(SOC_min_pct, SOC_initial_pct - ...
    Pcritical_kW*startup_delay_h/(battery_kWh*eta_discharge)*100);

for k = 1:numel(t2_h)
    if t2_h(k) < startup_delay_h
        P_battery_kW(k) = Pcritical_kW;
        SOC2_pct(k) = max(SOC_min_pct, SOC_initial_pct - ...
            Pcritical_kW*t2_h(k)/(battery_kWh*eta_discharge)*100);
    else
        P_DG_kW(k) = Pcritical_kW;
        SOC2_pct(k) = SOC_after_start_pct;
    end
end

figure('Name','Battery and Diesel Generator During Prolonged Outage');
yyaxis left;
plot(t2_h, SOC2_pct, 'LineWidth', 1.6);
ylabel('Battery SOC (%)');
yyaxis right;
plot(t2_h, P_battery_kW, 'LineWidth', 1.5); hold on;
plot(t2_h, P_DG_kW, 'LineWidth', 1.5); hold off;
ylabel('Power (kW)'); xlabel('Time (h)');
title('Battery and Diesel Generator During Prolonged Outage');
legend('Battery SOC','Battery Output','Diesel Output','Location','best');
grid on;

fprintf('SOC after %.2f h startup bridge: %.2f %%\\n', startup_delay_h, SOC_after_start_pct);
