%% 01 - Industrial Load Profile
% Representative synthetic load profile; replace with measured facility data.
clc; clear; close all;

load_kW = [100 120 140 160 180 200 160 120 130 150 170 190 250 200 120 110];
hour = 6:21;
dt_h = 1;
operating_days = 300;

daily_energy_kWh = sum(load_kW .* dt_h);
average_load_kW = mean(load_kW);
peak_hourly_average_kW = max(load_kW);
annual_energy_MWh = daily_energy_kWh * operating_days / 1000;

figure('Name','Representative Industrial Load Profile');
stairs(hour, load_kW, 'LineWidth', 1.6);
xlabel('Hour of Day'); ylabel('Demand (kW)');
title('Representative Industrial Load Profile');
grid on; xlim([min(hour) max(hour)]);

fprintf('\\nINDUSTRIAL LOAD ASSESSMENT\\n');
fprintf('Daily energy                 : %.1f kWh/day\\n', daily_energy_kWh);
fprintf('Average operating load       : %.2f kW\\n', average_load_kW);
fprintf('Peak hourly-average load     : %.1f kW\\n', peak_hourly_average_kW);
fprintf('Annual energy                : %.1f MWh/year\\n', annual_energy_MWh);
