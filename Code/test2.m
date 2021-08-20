a=0;

for x=1:10
    for y=1:10
        
        P(x,y)=Paxy(a,x,y,N_max,a_max,sigR,dd,dt,mu,sig);
        
    end
end

sum(P,2)

