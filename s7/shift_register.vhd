LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY shift_register is
	GENERIC( n : INTEGER := 8 );
	PORT (
		clk, reset : IN STD_LOGIC;
		en, load_shift : IN  STD_LOGIC;
		sd : IN  STD_LOGIC;
		d : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		sq : OUT STD_LOGIC;
		q : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
END shift_register;

ARCHITECTURE Behavioral OF shift_register IS

	SIGNAL reg : STD_LOGIC_VECTOR(n-1 DOWNTO 0);

BEGIN

	sq <= reg(0);
	q <= reg;
	
	--			  MODUS OPERANDI 				--
	-- EN - LOAD_SHIFT - OPERANDI 		--
	-- 0  - X  			 - do nothing		--
	-- 1  - 0  			 - parallel load	--
	-- 1  - 1  			 - shift data		--

	PROCESS(clk)
	BEGIN
		
		IF clk'EVENT and clk='1' THEN
			IF reset = '1' THEN
				reg <= (OTHERS=>'0');
			ELSE
				IF en = '1' THEN
					IF load_shift = '0' THEN  -- parallel data load --
						reg <= d;
					ELSE
						reg(n-1) <= sd;
						FOR i IN n-1 DOWNTO 1 LOOP
							reg(i-1) <= reg(i);
						END LOOP;
					END IF;
				END IF;					
			END IF;
		END IF;
		
		
	END PROCESS;

END Behavioral;

