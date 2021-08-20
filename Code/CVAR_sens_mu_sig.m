% clear all
% addpath(genpath('functions'))
% addpath(genpath('result'))
% 
% %addpath(genpath('data'))
% N=10;
% mu=2.5;
% sig=4;
% dt=1;
% dd=1;
% sigR=2;
% cr=20;
% cm=1;
% cf=20;
% tau=0.7;
% lambda=0.9;
% a_max=N-1;
% N_max=N;
% 
% clear OptObj
% 
%  clear OptCost
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Example under different tau\alpha
% alpha=0.3;
% tau=0.7;
% k1=1;
% for mu=1:0.05:5
%     k2=1;
%     for sig=2:0.05:6
%         [PhiOpt,OptObj,C2O]=CVaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);
%         OptCost(k1,k2)=OptObj;
% %         Con2O(k)=C2O;
%         k2=k2+1;
%         [k1 k2]
%     end
%     k1=k1+1;
% end
% 
% for k1=1:length(1:0.05:5)
%     for k2=1:length(2:0.05:6)
%         if OptCost(k1,k2)==-1
%             OptCost(k1,k2)=150;
%         end
%     end
% end
% 
% save sens_mu_sig_CVAR.mat

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