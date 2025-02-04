LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity flipflop is

	port( ent : in std_logic;
			clk : in std_logic;
			sai : out std_logic
	);
	
end flipflop;

architecture behv of flipflop is
begin

	process(ent, clk)
	begin
	
		if(falling_edge(clk)) then
			sai <= ent;
		end if;
		
	end process;
	
end behv;