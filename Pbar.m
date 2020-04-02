classdef Pbar
    
    
    properties
        
    end
    
    methods (Static)
        %%%%%%%%%%%%%%
        function status = odeprog(t,y,flag,varargin)
            %status = odebarplot(t,y,flag,varargin)
            %   ODE progress display function with interrupt control
            %   Displays a vertical bar plot that fills as the simulation
            %   nears its completion.  Also displays time ellapsed and estimates
            %   time remaining in the simulation.  To avoid computation burden
            %   refreshes are limited to every 0.5 seconds.
            %
            
            global odeprogglobvar
            global ph
            global th
            
            
            if nargin < 3 || isempty(flag)
                if(etime(clock,odeprogglobvar(8:13))>0.5) % end
                    tfin=odeprogglobvar(1); % number of der
                    sstrt=odeprogglobvar(2:7); % start
                    perc=t(end)/tfin;
                    ph.XData = [0 perc perc 0];
                    th.String = [num2str(perc*100) '%'];
                    
                    
                    odeprogglobvar(8:13)=clock; % Update time
                    
                    set(findobj(allchild(0),'Tag','ElapseTimeOde'),'Text',...
                        ['Elapse Time: ' '' ' ' Pbar.etimev(clock,sstrt)]);
                    
                    set(findobj(allchild(0),'Tag','TimeRemainingOde'),'Text',...
                        ['Time Remaining: ' '' ' ' Pbar.etimev(etime(clock,sstrt)/perc*(1-perc))]);
                end
            else
                switch(flag)
                    case 'init'
                        odeprogglobvar=zeros(1,13);
                        odeprogglobvar(1)=t(end);
                        odeprogglobvar(2:7)=clock;
                        odeprogglobvar(8:13)=clock;
                        
                        
                        PnlProgBar=findobj(allchild(0),'Tag','PanelProgV');
                        PnlProgBar.AutoResizeChildren = 'off';
                        ax = subplot(1,1,1,'Parent',PnlProgBar);
                        
                        
                        
                        ax.Position=[.1 .4 .8 .05];
                        ax.Box='on';
                        ax.XTick=[];
                        ax.YTick=[];
                        ax.Color=[0.9375 0.9375 0.9375];
                        ax.XAxis.Limits=[0,1];
                        ax.YAxis.Limits=[0,1];
                        
                        title(ax,'Progress')
                        ph = patch(ax,[0 0 0 0],[0 0 1 1],[0.67578 1 0.18359]); %greenyellow
                        th = text(ax,1,1,'0%','VerticalAlignment','bottom','HorizontalAlignment','right');
                        %                         pause(0.1);
                    case 'done'
                        ButtonOde=findobj(allchild(0),'Tag','ButtonOde');

                        if ButtonOde.UserData.x==1
                            ph.XData = [0 1 1 0];
                            th.String = 'Discarded';
                                                set(findobj(allchild(0),'Tag','TimeRemainingOde'),'Text',...
                        'Time Remaining: Discarded');
                        else
                            ph.XData = [0 1 1 0];
                            th.String = '100%';
                        end
                end
            end
            status = 0;
            drawnow;
        end
        function [S] = etimev(t1,t0)
            %ETIMEV  Verbose Elapsed time.
            %   ETIMEV(T1,T0) returns string of the days, hours, minutes, seconds that have elapsed
            %   between vectors T1 and T0.  The two vectors must be six elements long, in
            %   the format returned by CLOCK:
            %
            %       T = [Year Month Day Hour Minute Second]
            %   OR
            %   ETIMEV(t), t in seconds
            if(exist('t1')&exist('t0')&length(t1)>2&length(t0)>2)
                t=etime(t1,t0);     %Time in seconds
                if(t<0)
                    t=-t;
                end
            elseif(length(t1)==1)
                t=t1;
            else
                t=0;
            end
            days=floor(t/(24*60*60));
            t=t-days*24*60*60;
            hours=floor(t/(60*60));
            t=t-hours*60*60;
            mins=floor(t/60);
            t=floor(t-mins*60);
            if(days>0)
                S=[num2str(days) 'd ' num2str(hours) 'h ' num2str(mins) 'm ' num2str(t) 's'];
            elseif(hours>0)
                S=[num2str(hours) 'h ' num2str(mins) 'm ' num2str(t) 's'];
            elseif(mins>0)
                S=[num2str(mins) 'm ' num2str(t) 's'];
            else
                S=[num2str(t) 's'];
            end
        end
        %%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%% Start
        
        function [value,isterminal,direction]=odeabort(~,~,varargin)
            
            ButtonOde=findobj(allchild(0),'Tag','ButtonOde');
            
            try
                value(1)=ButtonOde.UserData.x;
                
            catch ME
                if (strcmp(ME.identifier,'MATLAB:noSuchMethodOrField'))||(strcmp(ME.identifier,'MATLAB:structRefFromNonStruct'))
                    
                    value(1)=0;
                else
                    value(1)=0;
                end
                
            end
            
            isterminal=[1];
            direction=[0];
        end
        
        %%%%%%%%%%% End
    end
end

