LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY datapath IS
	GENERIC( n : INTEGER := 8);
	PORT (
		clk, reset : IN  STD_LOGIC;
		load_i, load_out, en_r, en_s, en_d, en_t, en_op, op : IN STD_LOGIC;
		sel_mux0, sel_mux1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		input : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		t : OUT STD_LOGIC;
		output : OUT  STD_LOGIC_VECTOR (n-1 DOWNTO 0)
	);	
end datapath;

ARCHITECTURE Behavioral OF datapath IS

	SIGNAL diff, op0, op1, op_out, op_out_latch, r, s, d, i : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL clk_r, clk_d, clk_s, clk_t, clk_op : STD_LOGIC;
	
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
				i <= (OTHERS=>'0');
			ELSE					

				IF load_i = '1' THEN
					i <= input;
				END IF;
				IF load_out = '1' THEN
					output <= r;
				END IF;
			END IF;
		END IF;
				
	END PROCESS;
	
	clk_r <= not(clk) AND en_r;
	clk_d <= not(clk) AND en_d;
	clk_s <= not(clk) AND en_s;
	clk_t <= not(clk) AND en_t;
	clk_op <= clk AND en_op;
	
	PROCESS(clk_r, reset)
	BEGIN
	  IF reset = '1' THEN
			r <= conv_std_logic_vector(1, n);
		ELSIF clk_r = '1' THEN
			r <= op_out;
		END IF;
	END PROCESS;
	
	PROCESS(clk_d, reset)
	BEGIN
		IF reset = '1' THEN
			d <= conv_std_logic_vector(2, n);
		ELSIF clk_d = '1' THEN
			d <= op_out;
		END IF;
	END PROCESS;
	
	PROCESS(clk_s, reset)
	BEGIN
	  IF reset = '1' THEN
			s <= conv_std_logic_vector(4, n);
		ELSIF clk_s = '1' THEN
			s <= op_out;
		END IF;
	END PROCESS;
	
	PROCESS(clk_op, reset)
	BEGIN
	  IF reset = '1' THEN
			op_out_latch <= (OTHERS => '0');
		ELSIF clk_op = '1' THEN
			op_out_latch <= op_out;
		END IF;
	END PROCESS;
	
	PROCESS(clk_t, reset)
	BEGIN
	  IF reset = '1' THEN
			diff <= (OTHERS => '0');
		ELSIF clk_t = '1' THEN
			diff <= op_out;
		END IF;
	END PROCESS;
	
END Behavioral;
