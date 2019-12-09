clc,clear,close all
N_atoms=3200;
defect_type_id = 4;
critial_part_ratio = 0.4;
switch defect_type_id
    case 1
        defect_type = 'rand_as';
    case 2
        defect_type = 'neib_as';
    case 3 
        defect_type = 'Bn';
    case 4
        defect_type = 'Nb';
    otherwise
        error('wrong defect type')
end
za = 'armchair';   
file_id = 1;
for coverage = 1 : 1 : 9
    for times  = 2
        dump = times * 10;       
        load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',defect_type,...
                        '\',za,'\',num2str(file_id),'\',num2str(coverage),...
                        '\dump',num2str(dump)];
        load_name = 'part_ratio.mat';
        save_path = load_path;
        save_name = 'local_ratio.mat';
		save_name2 = 'local_ratio2.mat';
        load_file_name = [load_path,'\',load_name];
        save_file_name = [save_path,'\',save_name];
		save_file_name2 = [save_path,'\',save_name2];


        load(load_file_name)
        len_omega=length(omega);
        delta_omega=omega(2)-omega(1);
        localization_omega_id = zeros(len_omega,1);
        parfor idx=1:len_omega
            if part_ratio(idx) < critial_part_ratio
                localization_omega_id(idx) = 1;
            end
        end

        localization_intensity=zeros(1,N_atoms);
        parfor ii=1:N_atoms
            localization_intensity(:,ii)=-trapz(pdos(:,ii).*localization_omega_id,omega);
        end

        localization_ratio=localization_intensity./sum(localization_intensity);

save(save_file_name, 'localization_ratio');
save(save_file_name2, 'localization_intensity');
    end
end
