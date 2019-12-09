clc,clear, close all; font_size=15;

file_path = 'D:\zm_documents\LAMMPS\hBN_defects\hBN_antisite_1pc_cvg\tersoff&ectep\nobackfire';

%MDģ�����
%metal��λ ev ps bar A
num_blocks = 80;                        % ��ĸ���
Lx =  188.5610;                         % ���˷��򳤶�
Ly =  49.4844;                             %���
Lz =  1.44586 ;                             %���
dt = 0.5e-3;                            %ʱ�䲽��
dE = 2;                             %������������
timesteps = 900000;                    %ʱ�䲽��
ave_timesteps = 100000;                 %����ƽ���¶ȵĲ���
block = 40;
%����һЩ����
file = [file_path,'\',num2str(num_blocks),'.temp'];
num_outputs = timesteps/ave_timesteps;  % ������¶ȵĴ���
dx = Lx / num_blocks;                   % ÿ����ĳ���
power = dE * 1.6e-7;                    % ���� eV/ps -> W
A = Ly*Lz * 1.0e-20;                    % ������ A^2 -> m^2
Q = power / A / 2;                      % �����ܶ� W/m^2
t0 =ave_timesteps*dt;                   % ÿ������������ӵ�ģ��ʱ��

% ��ƽ��ģ��ʱ��
t= t0 * (1 : num_outputs);

% ������
x = (1 : num_blocks) * dx; % һ��
x = x.';                   % һ��

%��LAMMPS����ļ�����ȡ���¶�
[Chunk Coord1 Ncount v_TEMP] ...
    = textread(file, '%n%n%n%n', 'headerlines', 3, 'emptyvalue', 0);
temp = [Chunk Coord1 Ncount v_TEMP]; 
nall = length(temp) / (num_blocks+1);
clear Chunk Coord1 Ncount v_TEMP;
for i =1:nall
    temp((i-1)*num_blocks+1,:)=[];
end
temp = reshape(temp(:, end), num_blocks, num_outputs);

% �����������ѭ���������¶��ݶȺ��ȵ���
for n = 1 : num_outputs
    
    % ȷ��������䣨����������������
    index_1 = num_blocks/block*4+1 : num_blocks/2;              % ��߳�ȥ��Դ��Ŀ�ָ��
    index_2 = num_blocks/2+num_blocks/block*4 : num_blocks;   % �ұ߳�ȥ�Ȼ��Ŀ�ָ��
    
    % ����¶ȷֲ�
    p1 = fminsearch(@(p) ...
        norm(temp(index_1, n) - (p(1)-p(2)*x(index_1)) ), [60, -1]);
    p2 = fminsearch(@(p) ...
        norm(temp(index_2, n) - (p(1)+p(2)*x(index_2)) ), [60, 1]);
    
    % �õ��¶��ݶ�
    gradient_1 = p1(2) * 1.0e10; % K/A -> K/m
    gradient_2 = p2(2) * 1.0e10; % K/A -> K/m
    
    % �õ��ȵ���
    kappa_1(n) = -Q / gradient_1;
    kappa_2(n) = -Q / gradient_2;
    
    % ���¶ȷֲ��Լ��������
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

% �ȵ��ʵ�ʱ����������
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

% �������������������������
kappa_average = mean( kappa(1:end) )
kappa_error   = mean( 0.5*abs( kappa_1(1:end)-kappa_2(1:end) ) )
text(120,39,['\kappa_{ave} =',num2str(kappa_average)],'fontsize',20);
text(120,38.5,['\kappa_{error} =',num2str(kappa_error)],'fontsize',20,'color','red');

figure(n+2)
boxplot(temp','PlotStyle','compact')
xlabel('x (nm)');
ylabel('T (K)');