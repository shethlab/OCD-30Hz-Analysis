function h=tfmap_grid(fig,axe,t,f,tf,pos,dw,dh,channame,sl,sh,freq,smooth_x,smooth_y,auto_scale,units)
%TFMAP_GRID Summary of this function goes here
%   Detailed explanation goes here
%Orign of postion is top left corner
x=pos(1)-dw/2;
y=1-(pos(2)+dh/2);

text(x+dw/2,y+dh/1.1,channame,...
    'fontsize',max(8,80*dh),'horizontalalignment','center','parent',axe,'interpreter','none','tag','names','FontWeight','bold');

h=axes('parent',fig,'units','normalized','Position',[x,y,dw,dh/1.2],'Visible','off');

if smooth_x~=0&&smooth_y~=0
tf = cnelab_TF_Smooth(tf,'gaussian',[smooth_x,smooth_y]);
end


% if strcmpi(units,'CWT')
%     surf(t,f,tf);
%     shading('interp');
%     view(0, 90);
% %  axis square
% else
imagesc('XData',t,'YData',f,'CData',tf,'Parent',h);
% end

if ~auto_scale
    set(h,'CLim',[sl sh]);
end

set(h,'XLim',[min(t) max(t)]);
if strcmpi(units,'CWT')
    set(h,'XLim',[min(t)+0.05 max(t)-0.05]);
end
set(h,'YLim',freq);

colormap(h,jet);
% 
% if strcmpi(units,'CWT')
%     
%     oldcmap = colormap(h);
%     colormap( flipud(oldcmap) );
% 
%  end
set(h,'Tag',['TFMapAxes-' channame]);


drawnow
end

