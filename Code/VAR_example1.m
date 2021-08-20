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
cm=20000000;
cf=20;
tau=0.7;
lambda=0.9;
a_max=N-1;
N_max=N;

clear OptObj

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %Sensitivity for cf
% k=1;
% for cf=1:5:100
%     alpha=0.3;
%     [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
%     OptCost(k)=OptObj
%     alpha=1;
%     [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
%     OptCost0(k)=OptObj;
%     k=k+1;
%     k
% end
% 
% 
% plot(1:5:100+20,OptCost,'k','LineStyle','-');
% hold on
% plot(1:5:100+20,OptCost0,'k','LineStyle','--');
% xlabel('Cost of corrective replacement')
% ylabel('Optimal discounted cost')

%Example under alpha=0.3
alpha=1;
[PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    


cxa=[repmat([cm.*(0:1:(N-2)) cr]',N-1,1);
    cr+cf];
PhiOpt_cons=PhiOpt;
PhiOpt_cons(70)=PhiOpt_cons(69)+PhiOpt_cons(70);
PhiOpt_cons(69)=0;

PhiOpt_agg=PhiOpt;
PhiOpt_agg(69)=PhiOpt_agg(69)+PhiOpt_agg(70);
PhiOpt_agg(70)=0;

Cost_cons=sum(PhiOpt_cons.*(1-lambda)^-1.*cxa)
Cost_agg=sum(PhiOpt_agg.*(1-lambda)^-1.*cxa)

Result=[PhiOpt_cons [repmat([(0:9)'],N-1,1); 9]]


%Constraint 1
Cons1=zeros(N,length(cxa));

for x=1:N
    for y=1:N-1
        for a=0:1:N-1
            Cons1(x,(y-1)*N+a+1)=Cons1(x,(y-1)*N+a+1)-lambda*Paxy(a,y,x,N_max,a_max,sigR,dd,dt,mu,sig);
            if y==x
                Cons1(x,(y-1)*N+a+1)=Cons1(x,(y-1)*N+a+1)+1;
            end
        end
    end
    
    Cons1(x,(N-1)*N+1)=Cons1(x,(N-1)*N+1)-lambda*Paxy(N-1,N,x,N_max,a_max,sigR,dd,dt,mu,sig);
end

Cons1(N,(N-1)*N+1)=Cons1(N,(N-1)*N+1)+1;


%Cons1=Cons1;
Cons1_R=[(1-lambda);zeros(9,1)];
Cons2=zeros(1,length(cxa));
for x=1:N-1
   qx=0;
   for xp=x:1:N-1
      qx=qx+Rxy(x,xp,N,dd,dt,mu,sig);
   end
   if qx<=tau
       Cons2(((x-1)*N+1):x*N)=1;
   end
end

Cons2((N-1)*N+1)=1;

% Cons2*PhiOpt_cons
% Cons2*PhiOpt_agg
% 
% Cons1*PhiOpt_cons
% Cons1*PhiOpt_agg

%Example under alpha=1
alpha=1;
[PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    

Result=[PhiOpt [repmat([(0:9)'],N-1,1); 9]]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example under different alpha
k=1;
for alpha=0.1:0.02:0.6
    [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
    OptCost(k)=OptObj;
    Con2O(k)=C2O;
    k=k+1;
end
save sens_alpha_var1.mat

x=0.1:0.02:0.6;
plot(x(OptCost>=0),OptCost(OptCost>=0),'r','LineWidth',1.5)
hold on
XL=[0 0.6]
YL=ylim

xpos=x(OptCost>=0);
plot([xpos(1) xpos(1)],[YL(1),YL(2)],'k','LineWidth',1,'LineStyle','--')
text(xpos(1)/2,(YL(1)+YL(2))/2,'Infeasible','HorizontalAlignment','center')
plot(XL,[YL(1),YL(1)],'Color',[0.92 0.92 0.92],'LineWidth',1)
plot([XL(1) XL(1)],YL,'Color',[0.92 0.92 0.92],'LineWidth',1)
xlim(XL)
ylim(YL)
xlabel('$\alpha$','interpreter','latex')
ylabel('Minimum cost')
box off
set(gca,'color',[0.92 0.92 0.92])
set(gca,'GridColor',[1 1 1])
set(gca,'GridAlpha',1)
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example under different tau
k=1;
alpha=0.3;
for tau=0.2:0.02:0.80
    [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);    
    OptCost(k)=OptObj;
    Con2O(k)=C2O;
    k=k+1;
end
save sens_tau_var1.mat
x=0.2:0.02:0.80;

% plot(x(OptCost>=0),OptCost(OptCost>=0),'r','LineWidth',1.5)
plot(x,OptCost,'r','LineWidth',1.5)
hold on
XL=[0.2 0.8]
YL=ylim

% xpos=x(OptCost>=0);
xpos=x;
plot([xpos(1) xpos(1)],[YL(1),YL(2)],'k','LineWidth',1,'LineStyle','--')
%text(xpos(1)/2,(YL(1)+YL(2))/2,'Infeasible','HorizontalAlignment','center')
plot(XL,[YL(1),YL(1)],'Color',[0.92 0.92 0.92],'LineWidth',1)
plot([XL(1) XL(1)],YL,'Color',[0.92 0.92 0.92],'LineWidth',1)
xlim(XL)
ylim(YL)
xlabel('$\alpha$','interpreter','latex')
ylabel('Minimum cost')
box off
set(gca,'color',[0.92 0.92 0.92])
set(gca,'GridColor',[1 1 1])
set(gca,'GridAlpha',1)
grid on


clear OptCost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example under different tau\alpha
k1=1;
for alpha=0:0.02:1
    k2=1;
    for tau=0:0.02:1
        [PhiOpt,OptObj,C2O]=VaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha);
        OptCost(k1,k2)=OptObj;
%         Con2O(k)=C2O;
        k2=k2+1;
        [k1 k2]
    end
    k1=k1+1;
end

for k1=1:length(0:0.02:1)
    for k2=1:length(0:0.02:1)
        if OptCost(k1,k2)==-1
            OptCost(k1,k2)=150;
        end
    end
end

save sens_tau_alphaboth.mat

surface(0:0.02:1,0:0.02:1,OptCost,'EdgeColor','flat')
h=colorbar;
xlabel('\tau')
ylabel('\alpha')
title('Minimum discounted cost')
h.Ticks=[50:20:150]
h.TickLabels={'50','70','90','110','130','Infeasible'}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example_varying_sigma
clear OptCost

