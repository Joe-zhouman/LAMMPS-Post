%% find the overlap coefficent
clc,clear,close all
model_type = 'zigzag';
for times = 1 
      dump = times * 10;

%% load pdos1
      pdos1_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\size_effect\2\',...
              model_type,'\2\dump',num2str(dump)];
      pdos1_name = 'vacf_pdos.mat';
      pdos1_file = [pdos1_path,'\',pdos1_name];
      load(pdos1_file)
      pdos1 = pdos;
      overlap_coeff = zeros(10,6);
      overlap_coeff(1,:) = find_overlap_coeff(pdos1, pdos1, omega);
%% define defect type id to represente defect types      
    %       1.   random antisite
    %       2.   neighbor antisite
    %       3.   B substitute N
    %       4.   N substitute B
    defect_type_id = 4;
    defect_type  = defect_id2type( defect_type_id );

%% load pdos2 
      for coverage = 1 : 9
                load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',...
                        defect_type,'\',model_type,'\1\',num2str(coverage),'\dump',num2str(dump)];
                load_file_name = 'vacf_pdos.mat';
                load_file = [load_path,'\',load_file_name];
                load (load_file)
                
%% find overlap coefficent                
                overlap_coeff(coverage + 1,:) = find_overlap_coeff(pdos1, pdos, omega);
      end
%% draw overlap_coefficent figure    
end
