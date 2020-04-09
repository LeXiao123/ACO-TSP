%% ACO 算法
clc; clear;  close all;
feature jit off
%% Problem Definition
model.D = importdata( 'data4.txt'); 
model.n =  size(model.D, 1  ) ;  % 构建模型
CostFunction=@(tour) TourLength(tour,model);   %  路线长度计算函数
nVar=model.n;  %  点的数量
rand( 'seed' , sum( clock ) )

%% ACO Parameters

MaxIt=800;      % Maximum Number of Iterations  最大迭代次数
nAnt=30;        % Number of Ants (Population Size)  蚂蚁数量
Q=1;
tau0=100*Q/(nVar*mean(model.D(:)));	% Initial Phromone  （初始信息数）
alpha=1;         % Phromone Exponential Weight   (信息素权重)
beta=1;          % Heuristic Exponential Weight  （启发因子权重）
rho=0.05;       % Evaporation Rate   (信息素挥发系数)


%% Initialization

eta=1./model.D;             % Heuristic Information Matrix  (距离倒数)
tau=tau0*ones(nVar,nVar);   % Phromone Matrix  (信息素)
BestCost=zeros(MaxIt,1);    % Array to Hold Best Cost Values

% Empty Ant
empty_ant.Tour=[];
empty_ant.Cost=[];

% Ant Colony Matrix
ant=repmat(empty_ant,nAnt,1);   %%ant

% Best Ant
BestSol.Cost=inf;


%% ACO Main Loop
 
tic
for it=1:MaxIt
    
    % Move Ants
    for k=1:nAnt
                 ant(k).Tour=randi([1 nVar]);  
%         ant(k).Tour=1; % 起始点为 1        
        for l = 2 : nVar
            
            i=ant(k).Tour(end);
            P=tau(i,:).^alpha.*eta(i,:).^beta;
            P(ant(k).Tour)=0;   %   去掉已经选择的点 
          
            [~,ix ] = find(P ==inf  );
            P( ix )=0;
             [~,ix ] = find(P ==NaN  );
            P( ix )=0;
            
            P=P/sum(P);
            j=RouletteWheelSelection(P)  ;  % 基于概率选择
            ant(k).Tour=[ant(k).Tour   j];
        end
        
        ant(k).Cost=CostFunction( ant(k).Tour );
        
        if ant(k).Cost<BestSol.Cost   %  是否超过当前最优
            BestSol=ant(k);
        end
        
    end
    
    % Update Phromones      在所有蚂蚁完成一次TSP旅行后进行  全局的信息素更新
    for k=1:nAnt
        
        tour=ant(k).Tour;
        
        tour=[tour tour(1)]; %#ok
        if numel( tour ) ~= nVar+1
            continue;
        end
        for l=1:nVar
            
            i=tour(l);
            j=tour(l+1);
            
            tau(i,j)=tau(i,j)+Q/ant(k).Cost;
            
        end
        
    end
    
    % Evaporation     （信息素的蒸发） 
    tau=(1-rho)*tau;
    
    % Store Best Cost    最优解赋值
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information  显示第 it 次迭代的目标函数值
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Plot Solution  显示路线
%     figure(2);
%     PlotSolution( BestSol.Tour,model  );
%     pause(0.01);    % 暂停 0.01  秒
%     
end
toc


%%   算法的收敛曲线 
figure(3);
plot(BestCost,'LineWidth',2);
xlabel('迭代次数');
ylabel('每一代最优路径的长度');
grid on;
set(gcf,'Color',[1 1 1]);
box  off
%%  输出最优路径 及目标函数值
disp( ['最优路径的长度：'   num2str( BestSol.Cost)] )
fp = fopen('result.txt','wt');
for i =1 : numel( BestSol.Tour )
    fprintf(fp, '%d  ', BestSol.Tour(i));
end
fclose(fp);



