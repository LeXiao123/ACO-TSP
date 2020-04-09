function L=TourLength(tour,model)
%% 线路长度计算
n=numel(tour);

tour=[tour tour(1)];

L=0;
for i=1:n
    L=L+model.D(tour(i),tour(i+1));
end