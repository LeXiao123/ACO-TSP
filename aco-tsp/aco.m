%% ACO �㷨
clc; clear;  close all;
feature jit off
%% Problem Definition
model.D = importdata( 'data4.txt'); 
model.n =  size(model.D, 1  ) ;  % ����ģ��
CostFunction=@(tour) TourLength(tour,model);   %  ·�߳��ȼ��㺯��
nVar=model.n;  %  �������
rand( 'seed' , sum( clock ) )

%% ACO Parameters

MaxIt=800;      % Maximum Number of Iterations  ����������
nAnt=30;        % Number of Ants (Population Size)  ��������
Q=1;
tau0=100*Q/(nVar*mean(model.D(:)));	% Initial Phromone  ����ʼ��Ϣ����
alpha=1;         % Phromone Exponential Weight   (��Ϣ��Ȩ��)
beta=1;          % Heuristic Exponential Weight  ����������Ȩ�أ�
rho=0.05;       % Evaporation Rate   (��Ϣ�ػӷ�ϵ��)


%% Initialization

eta=1./model.D;             % Heuristic Information Matrix  (���뵹��)
tau=tau0*ones(nVar,nVar);   % Phromone Matrix  (��Ϣ��)
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
%         ant(k).Tour=1; % ��ʼ��Ϊ 1        
        for l = 2 : nVar
            
            i=ant(k).Tour(end);
            P=tau(i,:).^alpha.*eta(i,:).^beta;
            P(ant(k).Tour)=0;   %   ȥ���Ѿ�ѡ��ĵ� 
          
            [~,ix ] = find(P ==inf  );
            P( ix )=0;
             [~,ix ] = find(P ==NaN  );
            P( ix )=0;
            
            P=P/sum(P);
            j=RouletteWheelSelection(P)  ;  % ���ڸ���ѡ��
            ant(k).Tour=[ant(k).Tour   j];
        end
        
        ant(k).Cost=CostFunction( ant(k).Tour );
        
        if ant(k).Cost<BestSol.Cost   %  �Ƿ񳬹���ǰ����
            BestSol=ant(k);
        end
        
    end
    
    % Update Phromones      �������������һ��TSP���к����  ȫ�ֵ���Ϣ�ظ���
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
    
    % Evaporation     ����Ϣ�ص������� 
    tau=(1-rho)*tau;
    
    % Store Best Cost    ���Ž⸳ֵ
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information  ��ʾ�� it �ε�����Ŀ�꺯��ֵ
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Plot Solution  ��ʾ·��
%     figure(2);
%     PlotSolution( BestSol.Tour,model  );
%     pause(0.01);    % ��ͣ 0.01  ��
%     
end
toc


%%   �㷨���������� 
figure(3);
plot(BestCost,'LineWidth',2);
xlabel('��������');
ylabel('ÿһ������·���ĳ���');
grid on;
set(gcf,'Color',[1 1 1]);
box  off
%%  �������·�� ��Ŀ�꺯��ֵ
disp( ['����·���ĳ��ȣ�'   num2str( BestSol.Cost)] )
fp = fopen('result.txt','wt');
for i =1 : numel( BestSol.Tour )
    fprintf(fp, '%d  ', BestSol.Tour(i));
end
fclose(fp);



