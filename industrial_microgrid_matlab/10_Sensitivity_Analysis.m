%% 10 - NPV Sensitivity Analysis
% One-factor-at-a-time sensitivity model. All values in INR lakh.
clc; clear; close all;

N = 20;
base_discount_rate = 0.10;
base_CAPEX = 233.50;
base_PV_saving = 30.01;
base_OPEX = 5.00;
battery_replacement_year10 = 0.70*62.50;
years = (0:N)';

baseCF = zeros(N+1,1);
baseCF(1) = -base_CAPEX;
for y = 1:N
    baseCF(y+1) = base_PV_saving-base_OPEX;
end
baseCF(11) = baseCF(11)-battery_replacement_year10;

NPVcalc = @(cf,r) sum(cf./(1+r).^years);
baseNPV = NPVcalc(baseCF,base_discount_rate);
fprintf('Base-case NPV: Rs %.2f lakh\\n',baseNPV);

% Tariff sensitivity: assume PV savings scale linearly with effective tariff.
tariffs = [6 8 10 12];
npv_tariff = zeros(size(tariffs));
for i = 1:numel(tariffs)
    cf = baseCF;
    annual_saving = base_PV_saving*(tariffs(i)/8);
    for y = 1:N, cf(y+1) = annual_saving-base_OPEX; end
    cf(11) = cf(11)-battery_replacement_year10;
    npv_tariff(i) = NPVcalc(cf,base_discount_rate);
end
figure('Name','NPV Sensitivity to Electricity Tariff');
plot(tariffs,npv_tariff,'-o','LineWidth',1.5); hold on; yline(0,'--'); hold off;
xlabel('Assumed Electricity Tariff (INR/kWh)'); ylabel('NPV (INR lakh)');
title('NPV Sensitivity to Electricity Tariff'); grid on;

% CAPEX sensitivity.
capex_factors = [0.8 1.0 1.2];
npv_capex = zeros(size(capex_factors));
for i = 1:numel(capex_factors)
    cf = baseCF; cf(1) = -base_CAPEX*capex_factors(i);
    npv_capex(i) = NPVcalc(cf,base_discount_rate);
end
figure('Name','NPV Sensitivity to Initial Capital Cost');
plot(capex_factors*100,npv_capex,'-o','LineWidth',1.5); hold on; yline(0,'--'); hold off;
xlabel('Initial CAPEX (% of Base Case)'); ylabel('NPV (INR lakh)');
title('NPV Sensitivity to Initial Capital Cost'); grid on;

% OPEX sensitivity.
opex_cases = [3 5 7];
npv_opex = zeros(size(opex_cases));
for i = 1:numel(opex_cases)
    cf = baseCF;
    for y = 1:N, cf(y+1) = base_PV_saving-opex_cases(i); end
    cf(11) = cf(11)-battery_replacement_year10;
    npv_opex(i) = NPVcalc(cf,base_discount_rate);
end
figure('Name','NPV Sensitivity to Annual Operating Expenses');
plot(opex_cases,npv_opex,'-o','LineWidth',1.5); hold on; yline(0,'--'); hold off;
xlabel('Annual OPEX (INR lakh/year)'); ylabel('NPV (INR lakh)');
title('NPV Sensitivity to Annual Operating Expenses'); grid on;

% PV savings sensitivity.
pv_factors = [0.8 1.0 1.1];
npv_pv = zeros(size(pv_factors));
for i = 1:numel(pv_factors)
    cf = baseCF;
    for y = 1:N, cf(y+1) = base_PV_saving*pv_factors(i)-base_OPEX; end
    cf(11) = cf(11)-battery_replacement_year10;
    npv_pv(i) = NPVcalc(cf,base_discount_rate);
end
figure('Name','NPV Sensitivity to PV Energy Utilization');
plot(pv_factors*100,npv_pv,'-o','LineWidth',1.5); hold on; yline(0,'--'); hold off;
xlabel('Direct PV Saving (% of Base Case)'); ylabel('NPV (INR lakh)');
title('NPV Sensitivity to PV Energy Utilization'); grid on;

% Discount-rate sensitivity.
discount_rates = [0.06 0.08 0.10 0.12];
npv_rate = zeros(size(discount_rates));
for i = 1:numel(discount_rates)
    npv_rate(i) = NPVcalc(baseCF,discount_rates(i));
end
figure('Name','NPV Sensitivity to Discount Rate');
plot(discount_rates*100,npv_rate,'-o','LineWidth',1.5); hold on; yline(0,'--'); hold off;
xlabel('Discount Rate (%)'); ylabel('NPV (INR lakh)');
title('NPV Sensitivity to Discount Rate'); grid on;

fprintf('\\nTARIFF SENSITIVITY\\n');
for i=1:numel(tariffs), fprintf('Rs %.2f/kWh: NPV Rs %.2f lakh\\n',tariffs(i),npv_tariff(i)); end
fprintf('\\nCAPEX SENSITIVITY\\n');
for i=1:numel(capex_factors), fprintf('%.0f%% of base: NPV Rs %.2f lakh\\n',100*capex_factors(i),npv_capex(i)); end
fprintf('\\nOPEX SENSITIVITY\\n');
for i=1:numel(opex_cases), fprintf('Rs %.2f lakh/year: NPV Rs %.2f lakh\\n',opex_cases(i),npv_opex(i)); end
fprintf('\\nPV SAVINGS SENSITIVITY\\n');
for i=1:numel(pv_factors), fprintf('%.0f%% of base: NPV Rs %.2f lakh\\n',100*pv_factors(i),npv_pv(i)); end
fprintf('\\nDISCOUNT-RATE SENSITIVITY\\n');
for i=1:numel(discount_rates), fprintf('%.0f%%: NPV Rs %.2f lakh\\n',100*discount_rates(i),npv_rate(i)); end
