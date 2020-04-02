

function []=main()

fig=app4;

options=odeset('OutputFcn',@Pbar.odeprog,'Events',@Pbar.odeabort);
% options=odeset('OutputFcn',@odewbar);
[T,S]=ode45(@odedyn,[0:0.001:1000],zeros(4,1),options);



function [dS]=odedyn(t,S);
dS=magic(4)*S+rand(4,1);