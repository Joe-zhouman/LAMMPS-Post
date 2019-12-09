%% script to find the PDOS
clc,clear,close all
tic
for file_id = 1
    for defect_type_id = 4
%% define defect type id to represente defect types 
    %       1.   random antisite
    %       2.   neighbor antisite
    %       3.   B substitute N
    %       4.   N substitute B
    defect_type  = defect_id2type( defect_type_id );
%% calculate pdos
            for coverage = 40 :10 : 100
                for times = 1 : 2
                    dump = times * 10;
                    %% define some variables 

                    timestep=0.25e-3;%timestep: unit ps
                    dump_step=dump;   %steps between two time point
                    load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\'...
                        ,defect_type,'\zigzag\',num2str(file_id),'\',num2str(coverage),'\dump',num2str(dump)];
                    load_name = ['v_all_dump',num2str(dump),'.mat'];
                    save_path = load_path;
                    save_name = ['vacf_pdos.mat'];
                    load_file_name=[load_path,'\',load_name];%file name of v_all
                    save_file_name = [save_path, '\' ,save_name];
                    omega=0 : 400 ;%frequncy you want to show
                    net_time_points=1000;%time point you use to calculat vacf for time average
                                            %it should be smaller than total number of timepoint
                    
                    %% calculate some variables
                    load(load_file_name)
                    total_time_points=total_dump_step;%total number of time point
                    time_origins=total_time_points-net_time_points;%time origins you used to calculate vacf
                    delta_t=timestep*dump_step;%time interval between two measurements, in units of ps
                    correlation_time=(0:net_time_points-1)*delta_t;
                    
                    %% compute vacf and pdos
                    vacf=find_vacf_all(v_all,time_origins,net_time_points);%compute vacf
                    
                    pdos=find_pdos_all(vacf,omega,net_time_points,delta_t);%compute pdos
                        
                    %% check the answer
                    normalization_of_pdos=trapz(omega,mean(pdos(:,1),2))
                    %% save data for drawing
                    save(save_file_name,'pdos','vacf','correlation_time','omega')
                end
            end
     end
end
toc
