function R=Rxy(x,y,N,dd,dt,mu,sig)
% function of R(x,y), i.e., the transition probability w/o interventions

if x==N
    if y==N
        R=1;
    else
        R=0;
    end
else
    if y==N
        R=1-normcdf((N*dd-x*dd-mu*dt)/(sig*sqrt(dt)));
    elseif y>x
        R=normcdf((y*dd-x*dd+dd-mu*dt)/(sig*sqrt(dt)))-normcdf((y*dd-x*dd-mu*dt)/(sig*sqrt(dt)));
    elseif y==x
        R=normcdf((dd-mu*dt)/(sig*sqrt(dt)));
    else
        R=0;
    end
end