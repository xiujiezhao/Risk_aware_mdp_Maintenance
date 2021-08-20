function [PhiOpt,OptObj,Cons2_O]=CVaR_LP(N,mu,sig,dt,dd,sigR,cr,cm,cf,tau,lambda,a_max,N_max,alpha)

cxa=[repmat([cm.*(0:1:(N-2)) cr]',N-1,1);
    cr+cf];

Cons1=zeros(N,length(cxa));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Constraint 1
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

% Cons1=[Cons1;zeros(1,length(cxa))];
% Cons1_R=[(1-lambda);zeros(9,1);1];
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Constraint 2
Cons2=zeros(N,length(cxa));
Cons2_R=zeros(N,1);
qxv=zeros(length(cxa),1);



for x=1:N-1
    qx=0;
    for xp=x:1:N-1
        qx=qx+Rxy(x,xp,N,dd,dt,mu,sig);
    end
    qxv(((x-1)*N+1):((x-1)*N+N))=qx;
end


for x=1:N-1
   eta=0;
   for xp=x:1:N-1
      eta=eta+Rxy(x,xp,N,dd,dt,mu,sig);
   end
   
   Cons2(x,:)=-(1-alpha)^-1.*max([(qxv'-eta) 0]);
   Cons2_R(x)=eta-tau;
end

Cons2(N,:)=-(1-alpha)^-1.*(qxv');
Cons2_R(N)=-tau;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Objective function
f=(1-lambda)^-1.*cxa;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve the problem

[PhiOpt,OptObj]  = linprog(f,Cons2,Cons2_R,Cons1,Cons1_R,zeros(1,length(cxa)),[]);


if OptObj>=0
    Cons2_O=Cons2*PhiOpt;
else
    Cons2_O=-1;
        OptObj=-1;

end
end