clear all
load sens_mu_sig_VAR.mat
figure 
subplot(2,1,1)

surface(02:0.05:6,1:0.05:5,OptCost,'EdgeColor','flat')
h=colorbar;
xlabel('\sigma')
ylabel('\mu')
title('VaR constraint')
h.Ticks=[50:20:150]
h.TickLabels={'50','70','90','110','130','Infeasible'}

% clear all
% 
%
subplot(2,1,2)
load sens_mu_sig_CVAR.mat
% 
% % 
% load sens_mu_sig_VAR.mat
for k1=1:length(1:0.05:5)
    for k2=1:length(2:0.05:6)
        if OptCost(k1,k2)==150
            OptCost(k1,k2)=200;
        end
    end
end
surface(2:0.05:6,1:0.05:5,OptCost,'EdgeColor','flat')
h=colorbar;
xlabel('\sigma')
ylabel('\mu')
title('CVaR constraint')
h.Ticks=[50:20:130,200]
h.TickLabels={'50','70','90','110','130','Infeasible'}