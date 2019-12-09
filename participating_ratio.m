%% find the participating ratio
clc,clear,close all
 
%% define defect type id to represente defect types
%       1.   random antisite
%       2.   neighbor antisite
%       3.   B substitute N
%       4.   N substitute B
%       5.   test       
defect_type_id = 4;
defect_type  = defect_id2type( defect_type_id );
za = 'armchair';
tic
%% calculate participating ratio
for file_id = 1
for coverage = 1:9
for times = 2
        dump = times * 10;
    %% define some variables from MD simulation
    % metal units : ev ps bar A
        %number of atoms
        N_atoms=3200;
        %timestep
        timestep=0.25e-3;
        %steps between two dump frame
        dump_step=dump;
        
        load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',defect_type,...
                        '\',za,'\',num2str(file_id),'\',num2str(coverage),...
                        '\dump',num2str(dump)];
        %file name of v_all
        load_name = ['v_all_dump',num2str(dump),'.mat'];
       
        save_path = load_path;
        %frequncy to calculate pdos
        omega=0:400;
        %time point you use to calculat vacf parfor time average
        %       it should be smaller than total number of time points
        net_time_points = 300;


    %% load v_all and number of dump step(time point)
    %consist of variables v_all and total_dump_step
    %       v_all:                       all the velocity data
    %       total_dump_step:    number of dump frame
        load_file_name = [load_path,'/',load_name];
        load(load_file_name)
                        
        
    %% calculate some variables
        %total number of time point
        total_time_points=total_dump_step;
        %time origins you used to calculate vacf
        time_origins=total_time_points-net_time_points;
        %time interval between two measurements, in units of ps
        delta_t=timestep*dump_step;
        %correlation time for vacf and pdos
        correlation_time=(0:net_time_points-1)*delta_t;


    %% calculate vacf and pdos parfor each atom
        vacf=find_vacf_para(v_all, time_origins, net_time_points);
        pdos=zeros(length(omega),N_atoms);
        %a = zeros(length(omega),N_atoms);
        parfor idx=1:N_atoms
            pdos(:,idx)=find_pdos_para(vacf(idx,:),omega,net_time_points,delta_t);%compute pdos
        end
    

    %% calculate the participating ratio
        part_ratio=zeros(length(omega),1);
        parfor idx=1:length(omega)
            part_ratio(idx)=(sum(pdos(idx,:).^2))^2/sum(pdos(idx,:).^4)/N_atoms;
        end
   
    %% save files parfor drawing
        %part_ratio.mat:    name of saved file
        %part_ratio:        name of participating ratio matrix
        %omega:             frequency
        save_file_name = [save_path,'/','part_ratio.mat'];
        save (save_file_name,'pdos','part_ratio','omega');

end
end
end
toc

