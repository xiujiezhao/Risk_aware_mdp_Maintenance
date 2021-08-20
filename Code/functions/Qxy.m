function Q=Qxy(a,x,y,N,a_max,sigR)
%function of Q(x,y)
if x==1
    if y==1
        Q=1;
    else
        Q=0;
    end
elseif x==N
    if a==a_max && y==1
        Q=1;
    else
        Q=0;
    end
elseif a==0
    if x==y
        Q=1;
    else
        Q=0;
    end
elseif a==a_max
    if y==1
        Q=1;
    else
        Q=0;
    end
elseif y==1
   pd=makedist('normal',a,sigR);
   pd_trunc=truncate(pd,0,x-1);
   Q=1-cdf(pd_trunc,x-1);
elseif y>1
   pd=makedist('normal',a,sigR);
   pd_trunc=truncate(pd,0,x-1);
   Q=cdf(pd_trunc,x-y+1)-cdf(pd_trunc,x-y);
end