function [vacf]=find_vacf(v_all,time_origins,net_time_points)
% v_all(:,:,:): all the velocity data
% time_origins: number of "time origins" used in "time average"
% net_time_points: number of correlation time points
% vacf(:): VACF data
vacf=zeros(net_time_points,1);
for nt=0:net_time_points-1
    for m=1:time_origins
        vacf(nt+1,:)=vacf(nt+1,:)+sum(sum(v_all(:,:,m+0).*v_all(:,:,m+nt)));
    end
end
vacf=vacf/vacf(1);

