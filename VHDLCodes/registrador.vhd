LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity registrador is

	port( d							: in std_logic_vector(9 downto 0);
			clk 						: in std_logic;
		   q						 	: out std_logic_vector(9 downto 0)
	);
	
end registrador;

architecture behv of registrador is

component flipflop is

	port ( ent : in std_logic;
			 clk : in std_logic;
			 sai : out std_logic);
			 
end component;

begin

ent0: flipflop port map (d(0),clk,q(0));
ent1: flipflop port map (d(1),clk,q(1));
ent2: flipflop port map (d(2),clk,q(2));
ent3: flipflop port map (d(3),clk,q(3));
ent4: flipflop port map (d(4),clk,q(4));
ent5: flipflop port map (d(5),clk,q(5));
ent6: flipflop port map (d(6),clk,q(6));
ent7: flipflop port map (d(7),clk,q(7));
ent8: flipflop port map (d(8),clk,q(8));
ent9: flipflop port map (d(9),clk,q(9));

end architecture behv;