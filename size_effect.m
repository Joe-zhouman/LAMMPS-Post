clc,clear,close all
kappa1=[

0.049925112	0.009438656
0.03327787	0.006640514
0.024968789	0.005907473
0.01998002	0.005228099
0.012485953	0.004222702
0.00623986	0.003586889
];
kappa2 = [

0.057803468	0.010915732
0.038520801	0.008100726
0.02891009	0.006609433
0.023137436	0.00570633
0.014446692	0.00435342
0.007223346	0.003738099

];
plot(kappa1(:,1),kappa1(:,2),'rs','markersize', 10);
hold on
p1 = polyfit(kappa1(:,1),kappa1(:,2),1);
x = linspace(0,0.06,50);
plot(x,p1(1) .* x + p1(2),'b'); 

plot(kappa2(:,1),kappa2(:,2),'m^','markersize', 10);
p2 = polyfit(kappa2(:,1),kappa2(:,2),1);
plot(x,p2(1) .* x + p2(2),'g'); 
legend('zigzag points','zigzag fitting line', 'armchair points','armchair fitting line','location','northwest')


kappa_z = 1/p1(2);
kappa_a = 1/p2(2);
