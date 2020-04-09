function j=RouletteWheelSelection(P)
%%  ÂÖÅÌ¶ÄÑ¡Ôñº¯Êı
r=rand;

C=cumsum(P);

j=find(r<=C,1,'first');
