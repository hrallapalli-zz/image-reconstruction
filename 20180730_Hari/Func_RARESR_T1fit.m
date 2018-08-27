function [ fval ] = Func_RARESR_T1fit(x, t_RARESR, data)

T1=x(1);
S0=x(2);
absolute_bias=x(3);

S=absolute_bias+S0.*(1-exp(-t_RARESR./T1));

fval=sum((data-S).^2);

% figure(100);
% plot(S, 'r-o')
% hold on
% plot(data, 'b-x')
% pause
% clf


end

