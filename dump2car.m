clc,clear,close all


%%define informations of in/out files
        infile='final.position';               %name of input .car file
        outfile='456';            %name of output .data file
        infile_dir='D:\zm_documents\mathworks';                              %loading_dir
        outfile_dir='D:\zm_documents\mathworks';%saving dir
        out_file = [outfile_dir ,'\',outfile,'.car'];
        N_atoms = 3520;
        xlo = -0.4113077063;
        xhi = 189.7959637062;
        ylo = -0.5442439354;
        yhi = 49.3722439354;
        zlo = -19.9346996289;
        zhi = 19.9346996289;
%find box atoms positions
    fileID=fopen([infile_dir,'\',infile]);
    len_header=9;%length of headerline
    N=N_atoms+len_header;%length of block
    formatSpec='%n %n %n %n %n %*[^\n]';
    C=textscan(fileID,formatSpec,N,'HeaderLines',len_header,'CommentStyle','end');
    fclose(fileID);
%end
    C2='';
    C3=[];
    idx1 = 0;
    idx2 = 0;
    for i = 1 : N_atoms
        if C{2}(i) == 1
            idx1 = idx1 + 1;
            C2(i) = 'B';
            C3 = [C3;idx1];
        elseif C{2}(i) == 2
            idx2 = idx2 + 1;
            C2(i) = 'N';
            C3 = [C3;idx2];
        end
    end
    out = zeros(N_atoms,4);
    out(:,1) = C3;
    out(:,2) = C{3};
    out(:,3) = C{4};
    out(:,4) = C{5};
    fid = fopen(out_file,'w');
    fprintf(fid,'!BIOSYM archive 3\r\n');
    fprintf(fid,'PBC=ON\r\n');
    fprintf(fid,'Materials Studio Generated CAR File\r\n');
    fprintf(fid,'!DATE Thu Mar 21 18:36:27 2019\r\n');
    fprintf(fid,'PBC  %.4f   %.4f   %.4f   90.0000   90.0000   90.0000 (P1)\r\n',xhi - xlo, yhi - ylo, zhi - zlo);
    for i = 1:N_atoms
        fprintf(fid,'%s',C2(i));
        fprintf(fid,'%-4d',out(i,1));
        fprintf(fid,'%15.9f',out(i,2));
        fprintf(fid,'%15.9f',out(i,3));
        fprintf(fid,'%15.9f',out(i,4));
        fprintf(fid,' XXXX 1      xx      ');
        fprintf(fid,'%s',C2(i));
        fprintf(fid,'   0.000\r\n');
    end
     fprintf(fid,'end\r\n');
     fprintf(fid,'end\r\n');
    fclose(fid);
