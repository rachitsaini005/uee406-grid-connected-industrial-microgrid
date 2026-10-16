%% 04 - Diesel Generator Sizing
% Preliminary rating only; verify starting loads, derating, and manufacturer data.
clc; clear; close all;

Pcritical_kW = 100;
power_factor = 0.90;
target_loading = 0.80;
DG_rating_kVA = 150;

S_load_kVA = Pcritical_kW / power_factor;
S_required_kVA = S_load_kVA / target_loading;
DG_active_capability_kW = DG_rating_kVA * power_factor;
active_loading_pct = Pcritical_kW / DG_active_capability_kW * 100;

figure('Name','Critical Load and Candidate Generator Rating');
bar([Pcritical_kW DG_active_capability_kW]);
set(gca, 'XTickLabel', {'Critical Load','DG Active Capability'});
ylabel('Power (kW)');
title('Critical-Load Requirement and Candidate Generator Rating');
grid on;

fprintf('\\nDIESEL GENERATOR SIZING\\n');
fprintf('Critical load apparent power  : %.2f kVA\\n', S_load_kVA);
fprintf('Rating at target loading      : %.2f kVA\\n', S_required_kVA);
fprintf('Candidate DG active capability: %.2f kW\\n', DG_active_capability_kW);
fprintf('Approximate active loading    : %.1f %%\\n', active_loading_pct);
