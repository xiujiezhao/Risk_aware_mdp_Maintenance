clear all
addpath(genpath('functions'))
addpath(genpath('result'))

%addpath(genpath('data'))
N=10;
mu=2.5;
sig=4;
dt=1;
dd=1;
sigR=2;
cr=20;
cm=100000000;
cf=20;
tau=0.7;
lambda=0.9;
a_max=N-1;
N_max=N;

clear OptObj


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sensitivity for cf

k=1;
for cf=1:5:100
    alpha=0.3;
    [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
    OptCost1(k)=OptObj
    alpha=1;
    [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
    OptCost10(k)=OptObj;
    k=k+1;
    k
end

figure 
subplot(1,2,1)
plot((1:5:100)+20,OptCost1,'k','LineStyle','-');
hold on
plot((1:5:100)+20,OptCost10,'k','LineStyle','--');
xlabel('Cost of corrective replacement')
ylabel('Optimal discounted cost')
legend('VaR constraint','No risk constraint','Location','se')
xlabel('Cost of corrective replacement')


k=1;
for cf=1:5:100
    tau=0.8;
    alpha=0.05;
    [PhiOpt,OptObj,C2O]=CVaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
    OptCost2(k)=OptObj
    tau=0;
    [PhiOpt,OptObj,C2O]=CVaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
    OptCost20(k)=OptObj
    k=k+1;
    k
end
subplot(1,2,2)
plot((1:5:100)+20,OptCost2,'k','LineStyle','-');
hold on
plot((1:5:100)+20,OptCost20,'k','LineStyle','--');
legend('CVaR constraint','No risk constraint','Location','se')
xlabel('Cost of corrective replacement')
%ylabel('Optimal discounted cost')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example under alpha=0.3
alpha=0.3;
[PhiOpt,OptObj,C2O]=CVaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    

%Example under alpha=1
tau=0;
[PhiOpt,OptObj,C2O]=CVaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    

Result=[PhiOpt [repmat([(0:9)'],N-1,1); 9]]


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Example under different alpha
% k=1;
% for alpha=0.1:0.02:0.6
%     [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
%     OptCost(k)=OptObj;
%     Con2O(k)=C2O;
%     k=k+1;
% end
% save sens_alpha_var1.mat
% 
% x=0.1:0.02:0.6;
% plot(x(OptCost>=0),OptCost(OptCost>=0),'r','LineWidth',1.5)
% hold on
% XL=[0 0.6]
% YL=ylim
% 
% xpos=x(OptCost>=0);
% plot([xpos(1) xpos(1)],[YL(1),YL(2)],'k','LineWidth',1,'LineStyle','--')
% text(xpos(1)/2,(YL(1)+YL(2))/2,'Infeasible','HorizontalAlignment','center')
% plot(XL,[YL(1),YL(1)],'Color',[0.92 0.92 0.92],'LineWidth',1)
% plot([XL(1) XL(1)],YL,'Color',[0.92 0.92 0.92],'LineWidth',1)
% xlim(XL)
% ylim(YL)
% xlabel('$\alpha$','interpreter','latex')
% ylabel('Minimum cost')
% box off
% set(gca,'color',[0.92 0.92 0.92])
% set(gca,'GridColor',[1 1 1])
% set(gca,'GridAlpha',1)
% grid on
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Example under different tau
% k=1;
% alpha=0.3;
% for tau=0.2:0.02:0.80
%     [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
%     OptCost(k)=OptObj;
%     Con2O(k)=C2O;
%     k=k+1;
% end
% save sens_tau_var1.mat
% x=0.2:0.02:0.80;
% 
% % plot(x(OptCost>=0),OptCost(OptCost>=0),'r','LineWidth',1.5)
% plot(x,OptCost,'r','LineWidth',1.5)
% hold on
% XL=[0.2 0.8]
% YL=ylim
% 
% % xpos=x(OptCost>=0);
% xpos=x;
% plot([xpos(1) xpos(1)],[YL(1),YL(2)],'k','LineWidth',1,'LineStyle','--')
% %text(xpos(1)/2,(YL(1)+YL(2))/2,'Infeasible','HorizontalAlignment','center')
% plot(XL,[YL(1),YL(1)],'Color',[0.92 0.92 0.92],'LineWidth',1)
% plot([XL(1) XL(1)],YL,'Color',[0.92 0.92 0.92],'LineWidth',1)
% xlim(XL)
% ylim(YL)
% xlabel('$\alpha$','interpreter','latex')
% ylabel('Minimum cost')
% box off
% set(gca,'color',[0.92 0.92 0.92])
% set(gca,'GridColor',[1 1 1])
% set(gca,'GridAlpha',1)
% grid on
% 
% 
 clear OptCost
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example under different tau\alpha
k1=1;
for alpha=0:0.02:0.9
    k2=1;
    for tau=0:0.02:1
        [PhiOpt,OptObj,C2O]=CVaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);
        OptCost(k1,k2)=OptObj;
%         Con2O(k)=C2O;
        k2=k2+1;
        [k1 k2]
    end
    k1=k1+1;
end

for k1=1:length(0:0.02:0.9)
    for k2=1:length(0:0.02:1)
        if OptCost(k1,k2)==-1
            OptCost(k1,k2)=150;
        end
    end
end

save sens_tau_alphaboth_CVAR.mat

surface(0:0.02:1,0:0.02:0.9,OptCost,'EdgeColor','flat')
h=colorbar;
xlabel('\tau')
ylabel('\alpha')
title('Minimum discounted cost')
h.Ticks=[50:20:150]
h.TickLabels={'50','70','90','110','130','Infeasible'}
