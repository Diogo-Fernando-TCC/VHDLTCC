LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rede is

	generic(	bx		: natural								:= 9;
				bxw	: natural								:= 19;
				w1		: std_logic_vector(9 downto 0)	:= "0000101100"; --0.7  ----------------------------------------------------
				w2		: std_logic_vector(9 downto 0)	:= "1001111001"; --9.9	----------------------------------------------------
				w3		: std_logic_vector(9 downto 0)	:= "0111110011"; --7.8  ------------4 bits inteiros e 6 decimais------------
				w4		: std_logic_vector(9 downto 0)	:= "0001100110"; --1.6  ---valores negativos sendo considerados nas somas---
				t		: std_logic_vector(9 downto 0)	:= "0110000000"  --6    ----------------------------------------------------
	);

	port	(	swt												: in	std_logic_vector(bx downto 0); 	--entrada dos registradores e x4
				botao1, botao2, botao3						: in std_logic; 								--clock de cada registrador
				led1, led2, led3								: out std_logic;								--vericar apertar do botao
				y													: out std_logic								--saida do perceptron 
	);

end rede;