clc,clear, close all; font_size=15;

file_path = 'D:\zm_documents\LAMMPS\hBN_defects\hBN_antisite_1pc_cvg\tersoff&ectep\nobackfire';

%MD模拟参数
%metal单位 ev ps bar A
num_blocks = 80;                        % 块的个数
Lx =  188.5610;                         % 输运方向长度
Ly =  49.4844;                             %宽度
Lz =  1.44586 ;                             %厚度
dt = 0.5e-3;                            %时间步长
dE = 2;                             %交换能量功率
timesteps = 900000;                    %时间步数
ave_timesteps = 100000;                 %计算平均温度的步数
block = 40;
%计算一些参数
file = [file_path,'\',num2str(num_blocks),'.temp'];
num_outputs = timesteps/ave_timesteps;  % 输出块温度的次数
dx = Lx / num_blocks;                   % 每个块的长度
power = dE * 1.6e-7;                    % 功率 eV/ps -> W
A = Ly*Lz * 1.0e-20;                    % 横截面积 A^2 -> m^2
Q = power / A / 2;                      % 热流密度 W/m^2
t0 =ave_timesteps*dt;                   % 每次输出数据增加的模拟时间

% 非平衡模拟时间
t= t0 * (1 : num_outputs);

% 块坐标
x = (1 : num_blocks) * dx; % 一行
x = x.';                   % 一列

%从LAMMPS输出文件中提取块温度
[Chunk Coord1 Ncount v_TEMP] ...
    = textread(file, '%n%n%n%n', 'headerlines', 3, 'emptyvalue', 0);
temp = [Chunk Coord1 Ncount v_TEMP]; 
nall = length(temp) / (num_blocks+1);
clear Chunk Coord1 Ncount v_TEMP;
for i =1:nall
    temp((i-1)*num_blocks+1,:)=[];
end
temp = reshape(temp(:, end), num_blocks, num_outputs);

% 对输出次数作循环，计算温度梯度和热导率
for n = 1 : num_outputs
    
    % 确定拟合区间（具体问题具体分析）
    index_1 = num_blocks/block*4+1 : num_blocks/2;              % 左边除去热源后的块指标
    index_2 = num_blocks/2+num_blocks/block*4 : num_blocks;   % 右边除去热汇后的块指标
    
    % 拟合温度分布
    p1 = fminsearch(@(p) ...
        norm(temp(index_1, n) - (p(1)-p(2)*x(index_1)) ), [60, -1]);
    p2 = fminsearch(@(p) ...
        norm(temp(index_2, n) - (p(1)+p(2)*x(index_2)) ), [60, 1]);
    
    % 得到温度梯度
    gradient_1 = p1(2) * 1.0e10; % K/A -> K/m
    gradient_2 = p2(2) * 1.0e10; % K/A -> K/m
    
    % 得到热导率
    kappa_1(n) = -Q / gradient_1;
    kappa_2(n) = -Q / gradient_2;
    
    % 画温度分布以及拟合曲线
    figure(n)
    plot(x, temp(:, n), 'bo', 'linewidth', 2);
    hold on;
    x1=x(index_1(1)) : 0.1 : x(index_1(end));
    x2=x(index_2(1)) : 0.1 : x(index_2(end));
    plot(x1, p1(1)-p1(2)*x1, 'r-', 'linewidth', 2);
    plot(x2, p2(1)+p2(2)*x2, 'g--', 'linewidth', 2);
    legend('MD', 'fit-left', 'fit-right','location','best');
    set(gca, 'fontsize', font_size);
    title (['t = ', num2str(t0 * n), ' ps']);
    xlabel('x (nm)');
    ylabel('T (K)');
end

% 热导率的时间收敛测试
kappa = (kappa_1 + kappa_2) / 2;
figure(n+1);
plot(t, kappa_1, ' rd', 'linewidth', 2);
hold on;
plot(t, kappa_2, ' bs', 'linewidth', 2);
plot(t, kappa, ' ko', 'linewidth', 2);
set(gca, 'fontsize', font_size);
xlabel('t (ps)');
ylabel('\kappa (W/mK)');
legend('left', 'right', 'average');

% 报道结果（具体问题具体分析）
kappa_average = mean( kappa(1:end) )
kappa_error   = mean( 0.5*abs( kappa_1(1:end)-kappa_2(1:end) ) )
text(120,39,['\kappa_{ave} =',num2str(kappa_average)],'fontsize',20);
text(120,38.5,['\kappa_{error} =',num2str(kappa_error)],'fontsize',20,'color','red');

figure(n+2)
boxplot(temp','PlotStyle','compact')
xlabel('x (nm)');
ylabel('T (K)');