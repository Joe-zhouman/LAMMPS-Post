%% calculate thermal resistence for MD simulation with ansymmetrical thermostat and non-peridic boundary
clc,clear, close all; font_size=15;

lammps_log = [
];

file_id = 1;
defect_type_id = 1;
defect_type  = defect_id2type( defect_type_id );
for coverage = 1
    file_path = ['D:\zm_documents\LAMMPS\hBN_defects\test\',defect_type,'\',num2str(file_id),'\',num2str(coverage)];
    %ii = coverage/2 + 1;
    %data from MD simulations
    %metal unit ev ps bar A
    blocks = 80;
        
    num_blocks = 41;                        % ��ĸ���
    Lx =  lammps_log(1,3);                 % ���˷��򳤶�
    Ly = 49.20;                             %���
    Lz = 1.45 ;                             %���
    dt = 0.25e-3;                           %ʱ�䲽��
    delta_E = 4;

    

    timesteps = 4000000;                    %ʱ�䲽��
    ave_timesteps = 1000000;                 %����ƽ���¶ȵĲ���

    %����һЩ����
    file_name = [file_path,'/',num2str(blocks),'.temp'];

    num_outputs = timesteps/ave_timesteps;  % ������¶ȵĴ���
    dx = Lx / num_blocks;                   % ÿ����ĳ���

    t0 =ave_timesteps*dt;                   % ÿ������������ӵ�ģ��ʱ��
    factor = blocks/(num_blocks-1);
    % ��ƽ��ģ��ʱ��
    t= t0 * (1 : num_outputs);
    % ������
    x = (1 : blocks) /factor* dx; % һ��
    x = x.';                   % һ��

    %��LAMMPS����ļ�����ȡ���¶�
    [Chunk Coord1 Ncount v_TEMP] ...
        = textread(file_name, '%n%n%n%n', 'headerlines', 3, 'emptyvalue', 0);
    temp = [Chunk Coord1 Ncount v_TEMP]; 
    nall = length(temp) / (blocks+1);
    clear Chunk Coord1 Ncount v_TEMP;
    for i =1:nall
        temp((i-1)*num_blocks+1,:)=[];
    end
    temp = reshape(temp(:, end), blocks, num_outputs);
    temp1 = zeros(blocks,num_outputs);
    
    

    
    
    

    % �����������ѭ���������¶��ݶȺ��ȵ���
    for n = 1 : num_outputs
        %iii = (ii-1) * num_outputs + n;
        
            
            E_left=lammps_log(n,1);
            E_right=lammps_log(n,2);
            if E_left ==0
                dE = delta_E;
            else
                dE=(E_left-E_right)/2/ave_timesteps/n / dt;
            end
            power = dE * 1.6e-7;                    % ���� eV/ps -> W
            A = Ly*Lz * 1.0e-20;                    % ������ A^2 -> m^2
            Q = power / A  ;                       % �����ܶ� W/m^2
        % ȷ��������䣨����������������
        index_1 = 5*factor : blocks-5*factor;              % ��߳�ȥ��Դ��Ŀ�ָ��


        % ����¶ȷֲ�
        p1 = fminsearch(@(p) ...
            norm(temp(index_1, n) - (p(1)-p(2)*x(index_1)) ), [60, -1]);


        % �õ��¶��ݶ�
        gradient_1 = p1(2) * 1.0e10; % K/A -> K/m


        % �õ��ȵ���
        kappa_1(n) = - Q / gradient_1;

      
        % ���¶ȷֲ��Լ��������
        figure
        plot(x(1:end-2*factor), temp(1:end-2*factor, n), 'bo', 'linewidth', 2);
        hold on;
        x1=x(index_1(1)) : 0.1 : x(index_1(end));

        plot(x1, p1(1)-p1(2)*x1, 'r-', 'linewidth', 2);

        legend('MD','location','best');
        set(gca, 'fontsize', font_size);
        title (['t = ', num2str(t0 * n), ' ps']);
        xlabel('x (nm)');
        ylabel('T (K)');
     end

    % �ȵ��ʵ�ʱ����������
%     kappa_1;
%     figure;
%     plot(t, kappa_1, ' ko', 'linewidth', 2);
%     set(gca, 'fontsize', font_size);
%     xlabel('t (ps)');
%     ylabel('\kappa (W/mK)');
%     legend('average');

    % �������������������������
    kappa_1 = kappa_1'  
    kappa  = mean( abs( kappa_1(1:end)) )

%     figure(n+2)
%     boxplot(temp(4:end-3,:)','PlotStyle','compact')
%     xlabel('x (nm)');
%     ylabel('T (K)');
end
% figure
% hold on
% 
% x0 = 0 : 2 : 10;
% y0 = kappa./kappa(1) * 100;
% 
% plot(x0,1./y0,'ro')
% 
% xq = linspace(0,10.5,100);
% yq = interp1(x0,y0,xq,'spline');
% 
% plot(xq,1./yq);
% xlim ( [0,10.5]);
% %ylim ([0,110]);
