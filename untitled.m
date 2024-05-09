run('utslappRCP45.m')

%ställer upp alpha, alltså flödeskoefficienten
B_noll = [600; 600; 1500]; %GtC
F_noll = [0, 60, 0
          15, 0, 45
          45, 0, 0]; %GtC/år
alpha = F_noll./B_noll;

%Ställer upp NPP, alltså flödet mellan box B1 och box B2
NPP_noll = F_noll(1,2); %Inte helt säker på denna
NPP = @(B1) NPP_noll * (1 + beta * log(B1/B_noll(1)));

%Ställer upp utsläppet
U = CO2Emissions;

%Ställer upp flödesförändringen mellan boxaran
B1_prim = @(t,B1,B2,B3) alpha(3,1)*B3 + alpha(2,1)*B2 - NPP(B1) + U(t);
B2_prim = @(t,B1,B2,B3) NPP(B1) - alpha(2,3)*B2 - alpha(2,1)*B2;
B3_prim = @(t,B1,B2,B3) alpha(2,3)*B2 - alpha(3,1)*B3;

%Ställer up modellen med euler framåt
h = 1; %år
B = zeros(3,length(years)-1);
B = [B_noll, B];
for t=1:(length(years)-1)
    B(1,t+h) = B(1,t) + B1_prim(t,B(1,t),B(2,t),B(3,t))*h;
    B(2,t+h) = B(2,t) + B2_prim(t,B(1,t),B(2,t),B(3,t))*h;
    B(3,t+h) = B(3,t) + B3_prim(t,B(1,t),B(2,t),B(3,t))*h;
end

