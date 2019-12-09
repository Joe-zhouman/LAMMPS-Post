%% read LAMMPS velocity dump file

clc,clear,close all
tic
%% define defect type id to represente defect types
    %       1.   random antisite
    %       2.   neighbor antisite
    %       3.   B substitute N
    %       4.   N substitute B
    defect_type_id = 4;
    defect_type  = defect_id2type( defect_type_id );
%% read dump files 
for file_id = 2
for coverage = 1:9
    for times = 1 : 2
        dump = times * 10;
        %% define some variables
        N_atoms=3200;%number of atoms
        len_header=9;%length of headerline
        N=N_atoms+len_header;%length of block
        frame=6010; %assumed number of dump step,
                    %it should be larger than real number of frame
        %% define load/save file path and name
        load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\'...
                ,defect_type,'\armchair\',num2str(file_id),'\',num2str(coverage)];
        load_file=[load_path,'\dump',num2str(dump),'.vel'];%dmp file name
        save_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\'...
                ,defect_type,'\armchair\',num2str(file_id),'\',num2str(coverage),'\dump',num2str(dump)];
        mkdir(save_path);
        save_file=[save_path,'\v_all_dump',num2str(dump),'.mat'];%output file
        
        %% load file and save data to vall.mat
        v_all=zeros(N_atoms,3,frame);%all velocity file
        fileID=fopen(load_file);
        try
            formatSpec='%d %d %n %n %n';
            idx=0;%total number of dump point
            while ~feof(fileID)
                idx=idx+1;
                 C=textscan(fileID,formatSpec,N,'HeaderLines',len_header,'Delimiter','\t');
                 for idj=1:3
                     v_all(:,idj,idx)=C{idj+2};
                 end
            end
        catch ME
            rethrow(ME)
        end
        fclose(fileID);
        v_all(:,:,idx+1:end)=[];
        total_dump_step=idx;%real number of dump frame
        save(save_file,'v_all','total_dump_step')
    end
end
end
toc
