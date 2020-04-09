function PlotSolution(tour,model)
%% ��ͼ����
clf
tour=[tour tour(1)];


h(2) =  plot(model.x(tour),model.y(tour),'k-',...
    'MarkerSize',10,...
    'MarkerFaceColor','y',...
    'LineWidth',1.5);  hold on

h(1) = plot(model.x(tour),model.y(tour),'o',...
    'MarkerSize',10,...
    'MarkerFaceColor','y',...
    'LineWidth',1.5);

for i = 1: model.n
    text( model.x(i), model.y(i)  ,  num2str(i) );
    
end


%  [   model.x(tour),model.y(tour) ] ������ܾ���



xlabel('x');    ylabel('y');    axis equal;

alpha = 0.1;

xmin = min(model.x);
xmax = max(model.x);
dx = xmax - xmin;
xmin = floor(   (xmin - alpha*dx)/10   )*10;
xmax = ceil((xmax + alpha*dx)/10)*10;
xlim([xmin xmax]);

ymin = min(model.y);
ymax = max(model.y);
dy = ymax - ymin;
ymin = floor((ymin - alpha*dy)/10)*10;
ymax = ceil((ymax + alpha*dy)/10)*10;
ylim([ymin ymax]);

legend(h, '����','��·');