library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity square_root is
	GENERIC( n : INTEGER := 8 );
    PORT( start : IN STD_LOGIC;
           input : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           output : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
end square_root;

architecture Behavioral of square_root is

begin

	PROCESS(start)
		VARIABLE r, s, d, i : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		VARIABLE t : STD_LOGIC;
	BEGIN
		IF start = '1' THEN
			r := "00000001";
			d := "00000010";
			s := "00000100";
			t := '1';
			i := input;
				
			WHILE(t = '1') LOOP
				r := r + 1;
				d := d + 2;
				s := s + d + 1;
				IF s > i THEN
					t := '0';
				ELSE
					t := '1';
				END IF;
			END LOOP;
				
			output <= r;		
		END IF;
	END PROCESS;


end Behavioral;

