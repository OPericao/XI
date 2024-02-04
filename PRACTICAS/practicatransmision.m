%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%

clear all;
close all;

%=================== Parametros ==================================
N=10;		 % Periodo de simbolo
L=5000;		 % Numero de bits a transmitir
tipopulso=5; % 1: pulso rectangular 
EbNo=3;    % EbNo en dB        


%=================== Generacion del pulso =========================
m=0:N*L-1;

if tipopulso == 1  %pulso rectangular
  n=0:N-1;
  pulso=ones(1,N); 
elseif tipopulso == 2 %escriba un elseif por cda tipo
  n=0:N-1;
  pulso=[ones(1,N/2) zeros(1,N/2)];
elseif tipopulso == 3
  n=0:N-1;
  pulso=[ones(1,N/2) ones(1,N/2)*-1];
elseif tipopulso == 4
  n=0:N-1;
  pulso=(1/N*n);
elseif tipopulso == 5
  n=0:N-1;
  pulso=n/(N-1);
end

%=================== Calculo de la energia del pulso =============
Ep = 0;
for i=1:N
  Ep = Ep + (pulso(i)*pulso(i));
end
Ep
%=================== Generacion de la senal (modulacion) =========rand
bits=rand(1,L) < 0.5; %genera 0 y 1 a partir de un vector de numeros 
                      %aleatorios con distribucion uniforme
array=[];

for k=1:L
  if(bits(k)==0)
    array=[array pulso];
  else
    array=[array pulso*-1];
  end
end

%=================== Generar el ruido ============================

EbNo=10^(EbNo/10);
Eb=Ep;
No=Eb/EbNo;
ruido=sqrt(No/2)*randn(1,N*L);
s_rec=array+ruido;

pulsoinv = pulso(N:-1:1);

ind = 1;
for k = 1:N:L*N-1
s_conv = conv(s_rec(k:k+N-1),pulsoinv);
s_muest = s_conv(N);
bits_rec(ind) = s_muest <= 0;
ind = ind + 1;
end;


%Probabilidad de error real

pe_real = mean(bits_rec ~= bits)
pe_teo = erfc(sqrt(EbNo))/2

%=================== Representacion grafica ===================
figure(1)
stem(n,pulso,'linewidth',2);
axis([-N N -1.5 1.5]);
set(gca, "linewidth", 2, "fontsize", 16);
title('Pulso transmitido: p(n)');
grid;

figure(2)
hold on
%stem(m,s_rec,'linewidth',2);
plot(m,array);
plot(m,s_rec);
axis([-N N -1.5 1.5]);
set(gca, "linewidth", 2, "fontsize", 16);
title('Pulso transmitido: p(n)');
grid;