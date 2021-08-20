function P=Paxy(a,x,y,N_max,a_max,sigR,dd,dt,mu,sig)
P=0;
for l=1:N_max
    P=P+Qxy(a,x,l,N_max,a_max,sigR)*Rxy(l,y,N_max,dd,dt,mu,sig);
end
end