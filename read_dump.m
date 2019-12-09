%% read LAMMPS velocity dump file
clc,clear,close all
a = [1,2,3,4,5,8,16];
for cvg =  1:9
    for times = 1:2
        dump = times * 10;
        %% define some variables
        N_atoms=3200;%number of atoms
        len_header=9;%length of headerline
        N=N_atoms+len_header;%length of block
        frame=6010; %assumed number of dump step,
                    %it should be larger than real number of frame
        %% define load/save file path and name
        load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\Bn\armchair\1\',num2str(cvg)];
        load_file=[load_path,'\dump',num2str(dump),'.vel'];%dmp file name
        save_path = [load_path,'\dump',num2str(dump)];
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
        catch
            error('fail to deal with file')
        end
        fclose(fileID);
        v_all(:,:,idx+1:end)=[];
        total_dump_step=idx;%real number of dump frame
        save(save_file,'v_all','total_dump_step')
    end
end

