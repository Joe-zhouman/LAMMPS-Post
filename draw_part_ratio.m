clc,clear,close all
N = 12; 
idx = 1;
C =linspecer(N) ;
figure
axis([50/2/pi,95/2/pi,0,1]);
legend_str = [];
timestep = 0.25e-3;
a = zeros(N,1);
defect_type = 'Bn';
za = 'armchair';
file_id = 1;
hold on
for coverage = 0 : 1 : 9
for times =2
    dump = times * 10;
    load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',defect_type,...
                        '\',za,'\',num2str(file_id),'\',num2str(coverage),...
                        '\dump',num2str(dump)];
    load_name = ['part_ratio_10THz.mat'];
    save_path = load_path;
    save_name = 'part_ratio.jpg';

    load_file_name = [load_path,'\',load_name];
    save_file_name = [save_path,'\',save_name];

    load(load_file_name)
    omega1 = omega;

    markers = 'oxsd^v<>+ph';
    a(idx) = sum(part_ratio);
    yyaxis left
    plot(omega1./(2*pi),part_ratio,'Color',C(idx,:),'marker','^',...
             'MarkerFaceColor',C(idx,:),'linestyle','none','markersize',5)
    

    xlabel('\omega(THz)')
    ylabel('participating ratio')
    %plot(omega,part_ratio,'Color',C(idx,:))
    idx = idx + 1;
    legend_char =string([  'defect coverage = ',num2str(coverage),'%']);
    legend_str = [legend_str;legend_char];
%     if coverage == 0
%             load([load_path,'\vacf_pdos.mat'])
%             omega2 = omega;
%             yyaxis right
%             plot(omega2./(2*pi),pdos(:,1),'LineWidth',2,'color','r')
%             ylabel('PDOS')
%             
%     end
%      
end
end
% legend_str = [legend_str;"PDOS of prestin h-BN"];
% legend(legend_str)
