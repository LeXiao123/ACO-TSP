function j=RouletteWheelSelection(P)
%%  ���̶�ѡ����
r=rand;

C=cumsum(P);

j=find(r<=C,1,'first');
