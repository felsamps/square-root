library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY control IS

	PORT (
		clk,reset : in  STD_LOGIC;
		start, t : in  STD_LOGIC;
		rst_d, en_r, load_i, en_d, en_s, load_out, en_t, en_op, op : out  STD_LOGIC;
		sel_mux0, sel_mux1 : out  STD_LOGIC_VECTOR (1 downto 0);
		done : out  STD_LOGIC
	);
END control;

ARCHITECTURE Behavioral OF control IS

	TYPE state IS (rst, s0, s1, s2, s3, s4, s5, s6, s7, s8);
	SIGNAL c_state, n_state : state;
	
BEGIN

	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			c_state <= rst;
		ELSIF clk'EVENT AND clk = '1' THEN
			c_state <= n_state;
		END IF;			
	END PROCESS;
	
	PROCESS(c_state, start)
	BEGIN
		CASE c_state IS
			WHEN rst =>
				en_r <= '0';
				load_i <= '0';
				en_s <= '0';
				en_d <= '0';
				en_op <= '0';
				en_t <= '0';
				load_out <= '0';
				op <= '0';
				sel_mux0 <= "00";
				sel_mux1 <= "00";
				done <= '0';
				rst_d <= '1';
				
				n_state <= s0;
				
			WHEN s0 =>
				
				rst_d <= '1';
				sel_mux0 <= "00";
				sel_mux1 <= "00"; 
				
				IF start = '1' THEN
					n_state <= s1;
				ELSE
					n_state <= s0;
				END IF;
				
			WHEN s1 =>
			  load_i <= '1';
			  
				rst_d <= '0';
				
				n_state <= s2;

				
			WHEN s2 =>
			  load_i <= '0';
			 	IF t = '0' THEN
					n_state <= s3;
				ELSE
					n_state <= s8;
				END IF;
				
			WHEN s3 =>
				load_i <= '0';
				en_r <= '1';
				done <= '0';
				load_out <= '1';
				en_op <= '1';
        
				sel_mux0 <= "00"; --r
				sel_mux1 <= "00"; --1
				
				n_state <= s4;

				
			
			WHEN s4 =>
				en_r <= '0';
				en_d <= '1';
				sel_mux0 <= "01"; --d
				sel_mux1 <= "01"; --2
				
				n_state <= s5;
				
			WHEN s5 =>
				en_d <= '0';
				en_s <= '1';
				
				sel_mux0 <= "01"; --d
				sel_mux1 <= "10"; --s
				
				n_state <= s6;
				
			WHEN s6 =>
				en_s <= '0';
				op <= '1';
				en_t <= '1';
				en_op <= '0';
        				
				sel_mux0 <= "10"; --i
				sel_mux1 <= "10"; --s
				
				n_state <= s7;
				
			WHEN s7 =>
				en_t <= '0';
				op <= '0';
				
				n_state <= s2;
				
			WHEN s8 =>
				done <= '1';
				rst_d <= '1';
				load_out <= '0';
				
				
				n_state <= s0;
				
		END CASE;
	END PROCESS;
	

END Behavioral;
