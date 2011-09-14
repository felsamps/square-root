LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY datapath IS
	GENERIC( n : INTEGER := 8);
	PORT (
		clk, reset : IN  STD_LOGIC;
		load_i, load_out, load_r, load_s, load_d, load_t, op : IN  STD_LOGIC;
		sel_mux0, sel_mux1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		input : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		t : OUT STD_LOGIC;
		output : OUT  STD_LOGIC_VECTOR (n-1 DOWNTO 0)
	);	
end datapath;

ARCHITECTURE Behavioral OF datapath IS

	SIGNAL diff, op0, op1, op_out, r, s, d, i : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	
BEGIN

	t <= diff(n-1);
	
	WITH sel_mux0 SELECT
		op0 <= r WHEN "00",
				d WHEN "01",
				i WHEN OTHERS;
				
	WITH sel_mux1 SELECT
		op1 <= conv_std_logic_vector(0, n) WHEN "00",
				conv_std_logic_vector(1, n) WHEN "01",
				s WHEN OTHERS;
				
	WITH op SELECT
		op_out <= op0 + op1 + 1 WHEN '0',
					 op0 - op1 WHEN OTHERS;

	PROCESS(clk, reset)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF reset = '1' THEN
				r <= conv_std_logic_vector(1, n);
				d <= conv_std_logic_vector(2, n);
				s <= conv_std_logic_vector(2, n);
				diff <= (OTHERS=>'0');
				i <= (OTHERS=>'0');
				output <= (OTHERS=>'0');
			ELSE					
				IF load_r = '1' THEN
					r <= op_out;
				END IF;
				IF load_d = '1' THEN
					d <= op_out;
				END IF;
				IF load_s = '1' THEN
					s <= op_out;
				END IF;
				IF load_t = '1' THEN
					diff <= op_out;
				END IF;
				IF load_i = '1' THEN
					i <= input;
				END IF;
				IF load_out = '1' THEN
					output <= r;
				END IF;
			END IF;
		END IF;
				
	END PROCESS;

END Behavioral;

