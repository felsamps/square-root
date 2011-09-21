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
      output : out  STD_LOGIC_VECTOR (n-1 downto 0);
      done : out  STD_LOGIC
	);
END square_root;

ARCHITECTURE Behavioral OF square_root IS

	TYPE state IS (rst, s0, fake, s1, s2, s3, s4, s5, s6);
	SIGNAL c_state, n_state : state;
	SIGNAL r, d, s, diff, i : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
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
	
	PROCESS(c_state)
	BEGIN
		CASE c_state IS
			WHEN rst =>
				r <= (OTHERS=>'0');
				s <= (OTHERS=>'0');
				d <= (OTHERS=>'0');
				i <= (OTHERS=>'0');
				diff <= (OTHERS => '0');
				done <= '0';
				output <= (OTHERS => '0');
				n_state <= s0;
			WHEN s0 =>
				r <= conv_std_logic_vector(1, n);
				d <= conv_std_logic_vector(2, n);
				s <= conv_std_logic_vector(4, n);
				i <= input;
				
				diff <= (OTHERS => '1');
				IF start = '1' THEN
					n_state <= s1;
				ELSE
					n_state <= fake;
				END IF;
			
			WHEN fake =>  --TODO fix this work around
				r <= conv_std_logic_vector(1, n);
				d <= conv_std_logic_vector(2, n);
				s <= conv_std_logic_vector(4, n);
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
				r <= r + 1;
				d <= d + 2;
				n_state <= s3;
				
			WHEN s3 =>
				r <= r + 1;
				d <= d + 2;
				s <= s + d + 1;
				n_state <= s4;
				
			WHEN s4 =>
				r <= r + 1;
				d <= d + 2;
				s <= s + d + 1;
				diff <= s - i;
				IF t = '1' THEN
					n_state <= s5;
				ELSE
					n_state <= s6;
				END IF;
				
			WHEN s5 =>
				r <= r + 1;
				d <= d + 2;
				s <= s + d + 1;
				diff <= s - i;
				IF t = '1' THEN
					n_state <= s4;
				ELSE
					n_state <= s6;
				END IF;
							

				
			WHEN s6 =>
				done <= '1';
				output <= r - 2;
				n_state <= s0;
				
		END CASE;
	END PROCESS;
	

END Behavioral;

