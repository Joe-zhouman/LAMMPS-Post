function vacf=find_vacf_all(v_all,time_origins,net_time_points)
% v_all(:,:,:): all the velocity data
% time_origins: number of "time origins" used in "time average"
% net_time_points: number of correlation time points
% vacf(:): VACF data
vacf =zeros(net_time_points,3);
for nt=0:net_time_points-1
    for m=1:time_origins
        vacf(nt+1,2)=vacf(nt+1,2)+sum(sum(v_all(:,1:2,m).*v_all(:,1:2,m+nt)));
        vacf(nt+1,3)=vacf(nt+1,3)+sum(sum(v_all(:,3,m).*v_all(:,3,m+nt)));
    end
end
vacf(:,1) = vacf(:,2) + vacf(:,3);
vacf = vacf/vacf(1,1);


