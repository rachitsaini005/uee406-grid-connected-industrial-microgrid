%% 03 - Battery Sizing and SOC During Critical-Load Backup
% Simplified energy-only model. Does not represent battery electrochemistry.
clc; clear; close all;

Pcritical_kW = 100;
backup_duration_h = 2;
DoD = 0.90;
eta_discharge = 0.95;
battery_nominal_kWh = 250;
SOC_initial_pct = 100;
SOC_min_pct = 10;
P_discharge_kW = 100;
dt_h = 0.05;

E_required_kWh = Pcritical_kW * backup_duration_h;
E_nominal_required_kWh = E_required_kWh / (DoD * eta_discharge);
E_candidate_AC_kWh = battery_nominal_kWh * DoD * eta_discharge;

t_h = 0:dt_h:backup_duration_h;
SOC_pct = zeros(size(t_h));
SOC_pct(1) = SOC_initial_pct;

for k = 2:numel(t_h)
    dSOC = (P_discharge_kW * dt_h / (battery_nominal_kWh * eta_discharge)) * 100;
    SOC_pct(k) = max(SOC_min_pct, SOC_pct(k-1) - dSOC);
end

figure('Name','Battery SOC During Critical Load Backup');
plot(t_h, SOC_pct, 'LineWidth', 1.6);
xlabel('Time (h)'); ylabel('State of Charge (%)');
title('Battery State of Charge During Critical-Load Backup');
grid on; ylim([0 100]);

fprintf('\\nBATTERY SIZING\\n');
fprintf('Critical-load energy required : %.2f kWh\\n', E_required_kWh);
fprintf('Nominal capacity required      : %.2f kWh\\n', E_nominal_required_kWh);
fprintf('Candidate AC-equivalent energy : %.2f kWh\\n', E_candidate_AC_kWh);
fprintf('Idealized duration at 100 kW   : %.2f h\\n', E_candidate_AC_kWh/Pcritical_kW);
