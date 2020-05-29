
clear all;
close all;
clc;

%% Leitura dos arquivos contendo os padroes (entradas)

%%% As entradas associadas aos biases {-1 ou 1} podem aparecer no arquivo ou não. 
%%%% Essas entradas são características particulares associadas aos biases (pesos adicionais).
% ----- ## FORMATO DO ARQUIVO ## -----
% <Numero de caracteristicas>
% [Entrada 1]: <Caracteristica_1> <Caracteristica_2> ... <Caracteristica_n>  <Classe_1> <Classe_2> ... <Classe_c>
% ...
% [Entrada k]: <Caracteristica_1> <Caracteristica_2> ... <Caracteristica_n>	 <Classe_1> <Classe_2> ... <Classe_c>
% ----- ## FORMATO DO ARQUIVO ## -----

% Lê nome do arquivo
file_path = input('Forneca o nome do arquivo de entrada (sem extensão): ', 's');
filename = strcat(file_path, '.txt');

% Lê nome do arquivo até o '.'
for i = 1:length(filename)
    if (strcmp(filename(i),'.') == 1)
        break;
    end
    namefile(i) = filename(i);
end
diary(strcat('.\RESULTADOS_GRAFICOS\result_',filename));
filename

%%% b = load(filename); % data = importdata(filename);

% Tratamento para erro de leitura
fid = fopen(filename, 'r');
if(fid == -1)
    disp('fid = -1 => Nao foi possivel abrir o arquivo');
    return
end

% Coloca numa matriz conteudo do arquivo
data = [];
while(~feof(fid))
    b = str2num(fgets(fid));    % b = fscanf(fid,'%f %f %f');
    if (length(b) ~= 1)
        data = [data b'];
    else
        num_caracterist = b;
    end
end
arq = data';
data_bck = data;

%% Algoritmo de Aprendizagem

[num_elem, num_padroes] = size(data);

%%% vetor de classes (saidas desejadas, targets)
class = data(num_caracterist+1,:);  % vetor de classes

%%% vetor de entradas (padroes): dimensão => (num_caracteristicas+input_bias) x (num padroes)
x = data(1:num_caracterist,:); % vetor de caracteristicas (input_bias já incluso no vetor ou não)

%% Tratamento do input_bias:
% Caso o input_bias não esteja incorporado no vetor de características, ele é acrescentado 
%%% (escolhido, por convenção, o valor -1 no final do vetor).
x_bckp = x;
if( all(x(num_caracterist,:) == -1) == 0 ) % verifica se todos os últimos elementos do vetor de entrada são diferentes de -1
    if( all(x(num_caracterist,:) == 1) == 0 ) % verifica se todos os últimos elementos do vetor de entrada são diferentes de 1
        if( all(x(1,:) == -1) == 0 ) % verifica se todos os primeiros elementos do vetor de entrada são diferentes de -1
            if( all(x(1,:) == 1) == 0 ) % verifica se todos os primeiros elementos do vetor de entrada são diferentes de 1
                x = [x; -ones(1,size(x,2))];
            end
        end
    end
end
% [caract, padr] = size(x);
%%
%%% Vetor de pesos inicial
disp( strcat('Tamanho do vetor de pesos = tamanho dos padrões = ', num2str(size(x,1)) ) );
w = input('Forneca o vetor coluna de peso inicial [w1; w2; w3; ...; wd]: ');
%%%

%% Trata a compatibilidade de tamanhos da entrada e do vetor de pesos
%%% vetor de entrada e de pesos devem ter o mesmo tamanho
if (size(x,1) == 1) % (num_caracterist == 1, já incluso o input_bias)
    return;
else
    if (size(x,1) == 2) % (num_caracterist == 2, já incluso o input_bias)
        if (length(w) >= 2)
            w_atual = w(1:2);
        else % (length(w) == 1)
            w_atual = [w;0]; % acrescenta-se um elemento nulo (defini valor nulo como convenção) ao final do vetor de pesos
        end
    else
        if (size(x,1) == 3) % (num_caracterist == 3, já incluso o input_bias)
            if (length(w) >= 3)
                w_atual = w(1:3);
            else
                if (length(w) == 2)
                    w_atual = [w; 0];
                else % (length(w) == 1)
                    w_atual = [w; 0; 0]; % acrescenta-se dois elementos nulos (defini valores nulos como convenção) ao final do vetor de pesos
                end
            end
        else % (size(x,1) > 3) (num_caracterist > 3, já incluso o input_bias)
            if (length(w) >= size(x,1))
                w_atual = w(1:size(x,1));
            else
                w_atual = [w; zeros(size(x,1)-length(w),1)]; % acrescenta-se elementos nulos (defini como convenção) ao final do vetor de pesos
            end
        end
    end
end
%%%

vet_w = [w_atual];
line_separable = 0;
arquivo_data = data
x
w_inicial = w_atual

%% Plotagem da configuracao inicial do espaco de entrada 2-D ou 3-D (n-D nao plotavel para todos os elementos)
%%% No caso n-D, plota-se somente os tres primeiros elementos (3D).
erro_classific = 1;
if (size(x,2) <= 10) % numero de padroes
%     if (size(x,1) <= 4) % exibe somente se cada vetor de entradas possui tamanho menor que 5
        plota_espaco_entrada (num_padroes, class, x, w_atual, erro_classific)
%     end
end

%% Determinação e Validação do vetor de pesos ótimo
%%% Fase de treino => determinação do vetor de pesos ótimo
%%% Fase de teste => validação do vetor de pesos ótimo (quando a rede classifica todos os padrões corretamente, 
%%%%% sem erros -> y = d)
n = 0;
erro = 0;
k = 0;
while (n ~= num_padroes)
    
    if (k == num_padroes)
        k = 1;
    else
        k = k + 1;
    end
    y(k) = sign(w_atual' * x(:,k)); % saida calculada 
    d(k) = class(k);                % saida desejada (target): assume valores {-1 e 1}
    if (y(k) ~= d(k)) % erro de classificação
        w_novo = w_atual + d(k)*x(:,k);
        n = 0;
        erro_classific = 1;
        if (erro > 10000) % Estabelece um threshold (limite máximo) para o numero de classificacoes erradas 
            disp(' ');   %% ao longo do treinamento (não precisam ser consecutivas).
            disp('#### O algoritmo nao convergiu ####'); % Caso esse limiar é ultrapassado, é considerado 
            break;                                       %% que o algoritmo não converge.
        else
            erro = erro + 1;
        end
    else % (y(k) == d(k)) acertou
        erro_classific = 0;
        w_novo = w_atual;
        n = n + 1;
    end
    vet_w = [vet_w w_novo];
    w_atual = w_novo;
    
    % Plotagem da configuracao (iteracao) atual do espaco de entrada 2-D ou 3-D (n-D nao plotavel)
    if (size(x,2) <= 10) % exibe somente se a base de dados possui numero de padroes <= 10
            if (erro <= 20) % exibe até o vigésimo erro
                plota_espaco_entrada (num_padroes, class, x, w_atual, erro_classific) 
            end
    end
    
end

% o algoritmo de aprendizado nao convergiu para um vetor de pesos
if (n ~= num_padroes)
    disp('Erro: O algoritmo nao conseguiu obter um hiperplano separador (separacao linear)');
        plota_espaco_entrada (num_padroes, class, x, w_atual, erro_classific)
    disp(' ');
else % o algoritmo de aprendizado convergiu para um vetor de pesos
        plota_espaco_entrada (num_padroes, class, x, w_atual, erro_classific) 
        filename_result = strcat('.\RESULTADOS_GRAFICOS\result_',namefile);
        saveas(gcf, filename_result);
    disp(' ');
    disp( strcat('===> O algoritmo convergiu para w = ', mat2str(w_atual)) );
    disp(' ');
end

erro
diary off


