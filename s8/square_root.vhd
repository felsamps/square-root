LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY square_root IS
	GENERIC( n : INTEGER := 4);
	PORT(
		clk, reset : IN STD_LOGIC;
		input : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
END square_root;

ARCHITECTURE Behavioral OF square_root IS

	CONSTANT MAX_N_IT : INTEGER := (2**(n/2));

	TYPE op_array IS ARRAY (0 TO MAX_N_IT-1) OF STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL r, s, d, diff, mux : op_array;
	SIGNAL t : STD_LOGIC_VECTOR(0 TO MAX_N_IT-1);
	
	SIGNAL rin, rout : STD_LOGIC_VECTOR(n-1 DOWNTO 0);

BEGIN

	--ARCHITECTURE CORE
	r(0) <= conv_std_logic_vector(1, n);
	d(0) <= conv_std_logic_vector(2, n);
	s(0) <= conv_std_logic_vector(4, n);
	diff(0) <= rin - s(0);
	
	OP_GEN: FOR i IN 1 TO MAX_N_IT-1 GENERATE
		r(i)	<= r(i-1) + 1;
		d(i) <= d(i-1) + 2;
		s(i) <= s(i-1) + d(i) + 1;
		diff(i) <= rin - s(i);
	END GENERATE OP_GEN;
	
	--MULTIPLEXER CHAIN
	T_ASS: FOR i IN 0 TO MAX_N_IT-1 GENERATE
		t(i) <= diff(i)(n-1);
	END GENERATE T_ASS;
	
	mux(MAX_N_IT-1) <= r(MAX_N_IT-1);
	
	MUX_OUT: FOR i IN MAX_N_IT-2 DOWNTO 0 GENERATE
		WITH t(i) SELECT
			mux(i) <= mux(i+1) WHEN '0',
						  r(i) WHEN OTHERS;
	END GENERATE MUX_OUT;
	
	rout <= mux(0);
				
	--IN/OUT REGISTERS
	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			rin <= (OTHERS => '0');
			output <= (OTHERS => '0');
		ELSIF clk'EVENT AND clk = '1' THEN
			rin <= input;
			output <= rout;
		END IF;
	END PROCESS;
			
END Behavioral;

