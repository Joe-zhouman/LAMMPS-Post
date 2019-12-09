function [ overlap_coeff ] = find_overlap_coeff( pdos1,pdos2,omega )
%find_overlap_coeff find the overlap coefficient
%   pdos1   the first pdos
%   pdos2   the second pdos
%   omega   frequecy used to calculate pdos
%   note that the omega used to calculate pdos must be the same
    len_omega = length(omega);
    pdos = zeros(len_omega,3);
    overlap_coeff = zeros(1,3);
    delta_omega = omega(2) - omega(1);
    for idx = 1 : 3
        pdos(:,idx) = min([pdos1(:,idx),pdos2(:,idx)],[],2);
        overlap_coeff(idx) = sum(pdos(:,idx).*omega');
        overlap_coeff(idx + 3) = sum(pdos(:,idx).*delta_omega);
    end
end

