%% 09 - 20-Year Financial Analysis (Illustrative)
% All monetary values are in INR lakh.
% Model assumptions must be validated before investment decisions.
clc; clear; close all;

project_life_years = 20;
discount_rate = 0.10;

PV_CAPEX = 126.00;
BESS_CAPEX = 62.50;
DG_CAPEX = 15.00;
integration_CAPEX = 20.00;
other_CAPEX = 10.00;
initial_CAPEX = PV_CAPEX+BESS_CAPEX+DG_CAPEX+integration_CAPEX+other_CAPEX;

annual_gross_PV_saving = 30.01;
annual_OPEX = 5.00;
annual_incremental_fuel_cost = 0.00; % not modelled; replace with actual estimate
annual_other_benefits = 0.00;
annual_net_cash_flow = annual_gross_PV_saving + annual_other_benefits ...
    - annual_OPEX - annual_incremental_fuel_cost;

% Illustrative battery replacement in Year 10 at 70% of initial BESS CAPEX.
replacement_cost = zeros(project_life_years,1);
replacement_cost(10) = 0.70*BESS_CAPEX;

cash_flow = zeros(project_life_years+1,1);
cash_flow(1) = -initial_CAPEX;
for y = 1:project_life_years
    cash_flow(y+1) = annual_net_cash_flow - replacement_cost(y);
end
year = (0:project_life_years)';

discounted_cash_flow = cash_flow ./ (1+discount_rate).^year;
NPV_lakh = sum(discounted_cash_flow);
npv_function = @(r) sum(cash_flow ./ (1+r).^year);

IRR = NaN;
if npv_function(-0.99)*npv_function(5) < 0
    IRR = fzero(npv_function,[-0.99 5]);
end

cumulative_cash_flow = cumsum(cash_flow);
idx_simple = find(cumulative_cash_flow >= 0,1,'first');
simple_payback_years = NaN;
if ~isempty(idx_simple)
    if idx_simple == 1
        simple_payback_years = 0;
    else
        previous_cumulative = cumulative_cash_flow(idx_simple-1);
        current_flow = cash_flow(idx_simple);
        simple_payback_years = (year(idx_simple)-1) + abs(previous_cumulative)/current_flow;
    end
end

cumulative_discounted_cash_flow = cumsum(discounted_cash_flow);
idx_discounted = find(cumulative_discounted_cash_flow >= 0,1,'first');
discounted_payback_years = NaN;
if ~isempty(idx_discounted)
    discounted_payback_years = year(idx_discounted);
end

fprintf('\\nINDUSTRIAL MICROGRID FINANCIAL ANALYSIS\\n');
fprintf('Project life                   : %d years\\n',project_life_years);
fprintf('Discount rate                  : %.2f %%\\n',discount_rate*100);
fprintf('PV CAPEX                       : Rs %.2f lakh\\n',PV_CAPEX);
fprintf('Battery CAPEX                  : Rs %.2f lakh\\n',BESS_CAPEX);
fprintf('DG CAPEX                       : Rs %.2f lakh\\n',DG_CAPEX);
fprintf('Integration CAPEX              : Rs %.2f lakh\\n',integration_CAPEX);
fprintf('Other CAPEX                    : Rs %.2f lakh\\n',other_CAPEX);
fprintf('Total initial CAPEX             : Rs %.2f lakh\\n',initial_CAPEX);
fprintf('Annual gross PV saving          : Rs %.2f lakh\\n',annual_gross_PV_saving);
fprintf('Annual OPEX                     : Rs %.2f lakh\\n',annual_OPEX);
fprintf('Annual net before replacement   : Rs %.2f lakh\\n',annual_net_cash_flow);
fprintf('NPV at %.1f%%                    : Rs %.2f lakh\\n',discount_rate*100,NPV_lakh);
if isnan(IRR), fprintf('IRR                             : not found in search interval\\n');
else, fprintf('IRR                             : %.2f %%\\n',IRR*100); end
if isnan(simple_payback_years), fprintf('Simple payback                  : not reached\\n');
else, fprintf('Simple payback                  : %.2f years\\n',simple_payback_years); end
if isnan(discounted_payback_years), fprintf('Discounted payback              : not reached within project life\\n');
else, fprintf('Discounted payback              : %.2f years\\n',discounted_payback_years); end

figure('Name','20-Year Industrial Microgrid Cash Flow');
bar(year,cash_flow);
xlabel('Project Year'); ylabel('Cash Flow (INR lakh)');
title('20-Year Industrial Microgrid Cash Flow'); grid on;

figure('Name','Cumulative Cash Flow Over 20 Years');
plot(year,cumulative_cash_flow,'-o','LineWidth',1.5); hold on; yline(0,'--'); hold off;
xlabel('Project Year'); ylabel('Cumulative Cash Flow (INR lakh)');
title('Cumulative Cash Flow Over 20 Years'); grid on;

figure('Name','Discounted Cumulative Cash Flow Over 20 Years');
plot(year,cumulative_discounted_cash_flow,'-o','LineWidth',1.5); hold on; yline(0,'--'); hold off;
xlabel('Project Year'); ylabel('Discounted Cumulative Cash Flow (INR lakh)');
title('Discounted Cumulative Cash Flow Over 20 Years'); grid on;
