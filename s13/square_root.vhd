library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY square_root IS
	GENERIC( n : INTEGER := 8);
	PORT(
		clk, reset : in  STD_LOGIC;
      start : in  STD_LOGIC;
      input : in  STD_LOGIC_VECTOR (n-1 downto 0);
      output : out  STD_LOGIC_VECTOR (n/2-1 downto 0);
      done : out  STD_LOGIC
	);
END square_root;

ARCHITECTURE Behavioral OF square_root IS

	TYPE state IS (rst, s0, s1, s2, s3, s4, s5, s6, s7, s8);
	SIGNAL c_state, n_state : state;
	SIGNAL r : STD_LOGIC_VECTOR(n/2-1 DOWNTO 0);
	SIGNAL diff, s, i : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL t : STD_LOGIC;

BEGIN

	t <= diff(n-1);

	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			c_state <= rst;
		ELSIF clk'EVENT AND clk = '1' THEN
			c_state <= n_state;
		END IF;			
	END PROCESS;
	
	PROCESS(c_state, start)
		VARIABLE it : INTEGER;
	BEGIN
		CASE c_state IS
			WHEN rst =>
				r <= (OTHERS=>'0');
				diff <= (OTHERS => '0');
				done <= '0';
				output <= (OTHERS => '0');
				it := 0;
				
				n_state <= s0;
				
			WHEN s0 =>
				r <= (OTHERS => '0');
				it := n/2-1;
				i <= input;
				diff <= (OTHERS => '1');
				
				IF start = '1' THEN
					n_state <= s1;
				ELSE
					n_state <= s0;
				END IF;
						
			WHEN s1 =>
				done <= '0';
				output <= (OTHERS=>'0');
				
				n_state <= s2;
				
			WHEN s2 =>
				IF it /= -1 THEN
				  r(it) <= '1';
				END IF;
								
				IF it = -1 THEN
					n_state <= s8;
				ELSE
					n_state <= s3;
				END IF;
			
			WHEN s3 =>
				s <= r * r;
				
				n_state <= s4;
								
			WHEN s4 =>
				diff <= i - s;
				
				n_state <= s5;	
			
			WHEN s5 =>
				
				IF t = '0' THEN	-- i >= s
					n_state <= s7;
				ELSE					-- i < s
					n_state <= s6;
				END IF;
				
			WHEN s6 =>
				r(it) <= '0';
				it := it - 1;
				n_state <= s2;
				
			WHEN s7 =>	
				r(it) <= '1';			
				it := it - 1;
				n_state <= s2;
			
			WHEN s8 =>
				done <= '1';
				output <= r;
				
				n_state <= s0;
				
		END CASE;
	END PROCESS;
	

END Behavioral;