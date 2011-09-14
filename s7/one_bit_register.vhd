LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY one_bit_register is
	GENERIC( n : INTEGER := 8 );
	PORT (
		clk, reset, set : IN STD_LOGIC;
		en : IN STD_LOGIC;
		d : IN  STD_LOGIC;
		q : OUT STD_LOGIC		
	);
END one_bit_register;

architecture Behavioral of one_bit_register is

begin

	PROCESS(clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF reset = '1' THEN
				q <= '0';
			ELSIF set = '1' THEN
				q <= '1';
			ELSE
				IF en = '1' THEN
					q <= d;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
end Behavioral;

