LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

architecture arch of rede is

component registrador is

	port( d							: in std_logic_vector((bx) downto 0);
			clk 						: in std_logic;
		   q						 	: out std_logic_vector((bx) downto 0)
	);
		  
end component;

signal xw1, xw2, xw3, xw4			: std_logic_vector((bxw) downto 0); --multiplicacao das entradas com os pesos
signal soma1, soma2 					: std_logic_vector((bxw) downto 0); --soma dos XWs positivos e negativos
signal x1, x2, x3						: std_logic_vector((bx) downto 0);  --entrada do perceptron

begin

	reg1 : registrador port map (swt, botao1, x1); --registrador para X1
	reg2 : registrador port map (swt, botao2, x2); --registrador para X2
	reg3 : registrador port map (swt, botao3, x3); --registrador para X3
	
	led1 <= botao1; -- LED para verificar apertar botao1
	led2 <= botao2; -- LED para verificar apertar botao2
	led3 <= botao3; -- LED para verificar apertar botao3
	
	xw1 <= w1*x1; 
	xw2 <= w2*x2;
	xw3 <= w3*x3;
	xw4 <= w4*swt;

	soma1 <= xw2 + xw4;
	soma2 <= xw1 + xw3 + t;
	
	y <= 	'0' when soma1 < soma2 else
			'1' when soma1 > soma2;	-- ou >=

end arch;