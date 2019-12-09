%% draw pictures of vacf and pdos
clc,clear

%% define some variables of the limitation of  y-label    
omega_lim=350/(2*pi);%limit of x-cor of PDOS figure 
pdos_lim=0.1;%limit of y-cor of PDOS figure 

%% define a cell to save figure object
f = cell(1,2);
%%
file_id = 1;
za = 'armchair';
for defect_type_id = 3
%% define pdos type id to represent pdos type
    %       1.   in plane pdos
    %       2.   out plane pdos
    %       3.   normal style pdos
%% set properties to draw vacf figure        
        f{2*1-1} = figure;
        xlabel('Time (ps)','fontsize',20);
        ylabel('VACF (normalized)','fontsize',20);
        xlim([0,5]);
        ylim([-0.6,1]);
        set(gca,'fontsize',20,'linewidth',1.5);
        set(gca,'ticklength',get(gca,'ticklength')*2);
        hold on
%%  set properties to drow pdos figure         
        f{2*1} = figure;
        hold on
        N = 10; 
        idx = 1;
        C =linspecer(N) ;
        xlabel('\omega (1/ps)','fontsize',20);
        ylabel('PDOS (ps)','fontsize',20);
        xlim([0,omega_lim]);
        %ylim([0,pdos_lim]);
        set(gca,'fontsize',20,'linewidth',1.5);
        set(gca,'ticklength',get(gca,'ticklength')*2);
%% define defect type id to represente defect types      
    %       1.   random antisite
    %       2.   neighbor antisite
    %       3.   B substitute N
    %       4.   N substitute B
    defect_type  = defect_id2type( defect_type_id );

%%
        legend_str= [];
%%  
        for coverage = 0 : 1 : 9
            for times =2
                dump = times * 10;
%% load files for drawing
                load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',defect_type,...
                        '\',za,'\',num2str(file_id),'\',num2str(coverage),'\dump',num2str(dump)];
                load_file_name = 'vacf_pdos.mat';
                load_file = [load_path,'\',load_file_name];
                load (load_file)
                omega = omega ./ (2*pi);
%% draw figure of vacf,which should be limit to zero
                figure(f{2*1-1});
                plot(correlation_time,vacf,'color',C(idx,:));
                 
%% draw figure of PDOS
                figure(f{2*1})
               
                   
                    plot(omega,pdos(:,1),'LineWidth',2,'color',C(idx,:));
         
%% An important check is that PDOS should be normalized to about 1
                normalization_of_pdos=trapz(omega,pdos);
%% set legend of pdos figure
                  idx = idx + 1;   
                legend_char = string(['defect coverage = ',num2str(coverage) ,'%']);
                legend_str = [legend_str;legend_char];
            
            end
            
        end
        legend(legend_str)
end

