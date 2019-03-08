%translate MS .car file to LAMMPS .data file
%atom_type atomic in LAMMPS

clc,clear,close all

%all the data below shoube be set yourself
    infile='hBN.car';%name of input .car file
    outfile='hBN.data';%name of output .data file
    outfile_dir='D:\mathworks\car2data\'; %saving path
    N_atom_types=2;%number of atom types
    N_each_atom=[1760,1760];%number of each atom
    lattice_para=[1.420 1.2298 40]; %distance between the nearest simulation box
                                    %in x,y,z direction which is necessary for
                                    %predic boundary type
    masses=[11,14];%masses of atoms,it should be a vector,length(vector)=N_atom_types;
%end
N_atoms=sum(N_each_atom);%number of atoms
temp=[1:N_atoms;zeros(4,N_atoms)]';%temp data file

%read data from .car file
    fileID=fopen(infile);
    len_header=5;%length of headerline
    N=N_atoms+len_header;%length of block
    formatSpec='%s %n %n %n %*[^\n]';
    C=textscan(fileID,formatSpec,N,'HeaderLines',len_header,'CommentStyle','end');
    for idx=1:3
        temp(:,idx+2)=C{idx+1};
    end
    for i=1:N_atoms
        S=cell2mat(C{1,1}(i));
        if S(1)=='B'
            temp(i,2)=1;
        elseif S(1)=='N'
            temp(i,2)=2;
        end
    end
    fclose(fileID);
    test=temp;
%end

save test.mat test
temp=temp';
% print the file which LAMMPS can recognize
    fid=fopen([outfile_dir,outfile],'w');%create the file in such filename
    fprintf(fid,'LAMMPS data file.\r\n\r\n');%print the headline
    fprintf(fid,'\t%d atoms\r\n\r\n\r\n',N_atoms);%print the number of atoms
    fprintf(fid,'\t%d atom types\r\n\r\n',N_atom_types);%print the number of atom types
    %print x,y,z,range
        cor_name='xyz';
        for idx=1:3
            fprintf(fid,'\t%10f\t%10f %clo %chi\r\n',...
            min(temp(2+idx,:))-lattice_para(idx)/2,...
            max(temp(2+idx,:))+lattice_para(idx)/2,...
            cor_name(idx),cor_name(idx));
        end
    %end
    fprintf(fid,'\r\n');
    %print masses
        fprintf(fid,'Masses\r\n\r\n');
        for idx=1:N_atom_types
            fprintf(fid,'\t%d\t%f\r\n',idx,masses(idx));
        end
    %end
    %print atom data
        %=====|--ID--|--type(ID)--|--x--|--y--|--z--|=====
        fprintf(fid,'\r\n');
        fprintf(fid,'Atoms\r\n\r\n');
        fprintf(fid,'%5d%5d\t%15.9f\t%15.9f\t%15.9f\r\n',temp);
        fclose(fid);
    %end
%end
%test
    load test.mat
    figure
    hold on
    axis([min(temp(3,:))-lattice_para(1)/2, max(temp(3,:))+lattice_para(1)/2,...
        min(temp(4,:))-lattice_para(2)/2, max(temp(4,:))+lattice_para(2)/2]);
    colors='rbymcgwk';
    for idj=1:N_atom_types
        x_cor=zeros(1,N_each_atom(idj));
        y_cor=zeros(1,N_each_atom(idj));
        idm=1;
        for i=1:N_atoms  
            if test(i,2)==idj
                x_cor(idm)=test(i,3);
                y_cor(idm)=test(i,4);
                idm=idm+1;
            end
        end
        plot(x_cor,y_cor,[colors(idj),'o'])
    end
    axis equal
%end
