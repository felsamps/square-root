library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity square_root is
	GENERIC( n : INTEGER := 16 );
    PORT( clk, start: IN STD_LOGIC;
           input : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			  done : OUT STD_LOGIC;
           output : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
end square_root;

architecture Behavioral of square_root is

begin

	PROCESS(start)
		VARIABLE r, s, d, i : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		VARIABLE t : STD_LOGIC;
	BEGIN
		IF clk = '1' AND clk'EVENT THEN
			IF start = '1' THEN
				r := conv_std_logic_vector(1,n);
				d := conv_std_logic_vector(2,n);
				s := conv_std_logic_vector(4,n);
				t := '1';
				i := input;
			ELSE
				IF t = '1' THEN
					r := r + 1;
					d := d + 2;
					s := s + d + 1;
					IF s > i THEN
						t := '0';
						done <= '1';
						output <= r;
					ELSE
						t := '1';
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;


end Behavioral;

