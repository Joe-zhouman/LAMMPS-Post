clc,clear,close all
len_model = [10.02
20.03
30.05
40.05
50.05
80.09
160.26
];
kappa = [89.25398889
113.4401556
162.5138778
179.7544778
199.2238667
240.4088889
280.9941889
];
f = fit(len_model,kappa,'power2');
plot(f,len_model,kappa)
len_a = len_model.^f.b;
p = polyfit(len_model.^f.b, kappa,1);
plot(len_a, kappa,'bo');
hold on
len_q = linspace(min(len_a),max(len_a),20);
plot(len_q, p(1).*len_q+p(2),'r')
hold off
plot(log(len_model),kappa)

