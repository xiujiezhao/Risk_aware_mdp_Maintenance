clear all
load sens_mu_sig_VAR_HA.mat

for k1=1:length(1:0.05:5)
    for k2=1:length(2:0.05:6)
        if OptCost(k1,k2)==-1
            OptCost(k1,k2)=150;
        end
    end
end
figure 
subplot(2,1,1)

surface(02:0.05:6,1:0.05:5,OptCost,'EdgeColor','flat')
h=colorbar;
xlabel('\sigma')
ylabel('\mu')
title('VaR constraint')
h.Ticks=[30,50:20:150]
h.TickLabels={'30','50','70','90','110','130','Infeasible'}

% clear all
% 
%
subplot(2,1,2)
load sens_mu_sig_CVAR_HA.mat
% 
% % 
% load sens_mu_sig_VAR.mat
for k1=1:length(1:0.05:5)
    for k2=1:length(2:0.05:6)
        if OptCost(k1,k2)==150
            OptCost(k1,k2)=180;
        end
    end
end
surface(2:0.05:6,1:0.05:5,OptCost,'EdgeColor','flat')
h=colorbar;
xlabel('\sigma')
ylabel('\mu')
title('CVaR constraint')
h.Ticks=[30:20:150,170]
h.TickLabels={'30','50','70','90','110','130','150','Infeasible'}