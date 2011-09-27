library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity inv_clock_gated_latch is
	GENERIC ( n : INTEGER := 8 );
	PORT (
		clk, reset, en : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
end inv_clock_gated_latch;

architecture Behavioral of inv_clock_gated_latch is
	
	SIGNAL gated_clk : STD_LOGIC;
	
begin

	gated_clk <= clk AND en;

	PROCESS(gated_clk,reset)
	BEGIN
		IF reset = '1' THEN
			q <= (OTHERS => '0');
		ELSIF clk = '0' THEN
			q <= d;
		END IF;
			
	END PROCESS;


end Behavioral;

