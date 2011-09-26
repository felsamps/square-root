library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY control IS
	GENERIC( n : INTEGER := 8);
	PORT (
		clk,reset : in  STD_LOGIC;
		start, t : in  STD_LOGIC;
		
		rst_datapath : OUT STD_LOGIC;
		
		--R Datapath
		rst_carry_rd, set_carry_rd, en_carry_rd : OUT STD_LOGIC;
		ls_rd_op0, ls_rd_op1, en_rd_op0, en_rd_op1 : OUT STD_LOGIC;
			
		--S Datapath
		rst_carry_s, set_carry_s, en_carry_s : OUT STD_LOGIC;
		ls_s_op0, en_s_op0, en_s_op1 : OUT STD_LOGIC;
		
		--T Datapath
		rst_carry_t, set_carry_t, en_carry_t : OUT STD_LOGIC;
		ls_t_op0, en_t_op0, en_t_op1 : OUT STD_LOGIC;
		en_t : OUT STD_LOGIC;
		
		done : out  STD_LOGIC
	);
END control;

ARCHITECTURE Behavioral OF control IS

	TYPE state IS (rst, s0, s1, s11, s2, s3, s4, s5, s6, s7);
	SIGNAL c_state, n_state : state;
	SIGNAL counter_rd, counter_s, counter_t : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	
	
BEGIN

	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			c_state <= rst;
		ELSIF clk'EVENT AND clk = '1' THEN
			c_state <= n_state;
		END IF;			
	END PROCESS;
	
	set_carry_rd <= '0';
	rst_carry_s <= '0';
	set_carry_t <= '0';
	
	PROCESS(c_state, start)
	BEGIN
		CASE c_state IS
			WHEN rst =>
				rst_datapath <= '1';
				rst_carry_rd <= '0';
				en_carry_rd <= '0';
				ls_rd_op0 <= '0';
				ls_rd_op1 <= '0';
				en_rd_op0 <= '0';
				en_rd_op1 <= '0';			
				
				set_carry_s <= '0';
				en_carry_s <= '0';
				ls_s_op0 <= '0';
				en_s_op0 <= '0';
				en_s_op1 <= '0';
			
				rst_carry_t <= '0';
				en_carry_t <= '0';
				ls_t_op0 <= '0';
				en_t_op0 <= '0';
				en_t_op1 <= '0';
				en_t <= '0';
				
				counter_rd <= (OTHERS => '0');
				counter_s <= (OTHERS => '0');
				counter_t <= (OTHERS => '0');
				
				n_state <= s0;
				
			WHEN s0 =>
							
				IF start = '1' THEN
					n_state <= s11;
				ELSE
					n_state <= s0;
				END IF;
							
			WHEN s11 =>
				rst_datapath <= '0';
				rst_carry_rd <= '1';
				en_carry_rd <= '0';
				ls_rd_op0 <= '0';
				ls_rd_op1 <= '0';
				en_rd_op0 <= '1';
				en_rd_op1 <= '1';			
				
				set_carry_s <= '1';
				en_carry_s <= '0';
				ls_s_op0 <= '0';
				en_s_op0 <= '1';
				en_s_op1 <= '0';
			
				rst_carry_t <= '1';
				en_carry_t <= '0';
				ls_t_op0 <= '0';
				en_t_op0 <= '1';
				en_t_op1 <= '0';
				en_t <= '0';
				
				counter_rd <= conv_std_logic_vector(n,n);
				counter_s <= conv_std_logic_vector(n,n);
				counter_t <= conv_std_logic_vector(n,n);
				
				done <= '0';
			
			WHEN s1 =>
					
				IF t = '1' THEN
					n_state <= s2;
				ELSE
					n_state <= s5;
				END IF;
				
			WHEN s2 =>
				counter_rd <= counter_rd - 1;
				--TODO HABILITA OPERAÇÕES NOS REGS R E D
				rst_carry_rd <= '0';
				en_carry_rd <= '1';
				ls_rd_op0 <= '1';
				ls_rd_op1 <= '1';
				en_rd_op0 <= '1';
				en_rd_op1 <= '1';			
				
				n_state <= s3;
				
			WHEN s3 =>
				counter_rd <= counter_rd - 1;
				counter_s <= counter_s - 1;
				--TODO HABILIDA A OPERAÇÃO S;
				set_carry_s <= '0';
				en_carry_s <= '1';
				ls_s_op0 <= '1';
				en_s_op0 <= '1';
				en_s_op1 <= '1';
				
				IF counter_rd = conv_std_logic_vector(0,n) THEN
					--TODO DESABILITA OPERAÇÔES RD SE counter_rd = 0
					rst_carry_rd <= '1';
					en_carry_rd <= '0';
					ls_rd_op0 <= '0';
					ls_rd_op1 <= '0';
					en_rd_op0 <= '0';
					en_rd_op1 <= '0';
				END IF;
					
						
				n_state <= s4;
				
			WHEN s4 =>
				counter_rd <= counter_rd - 1;
				counter_s <= counter_s - 1;
				counter_t <= counter_t - 1;
				--TODO HABILITA A OPERAÇÃO T
				rst_carry_t <= '0';
				en_carry_t <= '1';
				ls_t_op0 <= '1';
				en_t_op0 <= '1';
				en_t_op1 <= '1';
				en_t <= '1';
				
				IF counter_rd = conv_std_logic_vector(0,n) THEN
					--TODO DESABILITA OPERAÇÔES RD SE counter_rd = 0
					rst_carry_rd <= '1';
					en_carry_rd <= '0';
					ls_rd_op0 <= '0';
					ls_rd_op1 <= '0';
					en_rd_op0 <= '0';
					en_rd_op1 <= '0';
				END IF;
				IF counter_s = conv_std_logic_vector(0,n) THEN
					--TODO DESABILITA OPERAÇÃO S SE counter_S = 0
					set_carry_s <= '1';
					en_carry_s <= '0';
					ls_s_op0 <= '0';
					en_s_op0 <= '0';
					en_s_op1 <= '0';
				END IF;
				n_state <= s5;
				
			WHEN s5 =>
				counter_rd <= counter_rd - 1;
				counter_s <= counter_s - 1;
				counter_t <= counter_t - 1;
				
				IF counter_rd = conv_std_logic_vector(0,n) THEN
					--TODO DESABILITA OPERAÇÔES RD SE counter_rd = 0
					rst_carry_rd <= '1';
					en_carry_rd <= '0';
					ls_rd_op0 <= '0';
					ls_rd_op1 <= '0';
					en_rd_op0 <= '0';
					en_rd_op1 <= '0';
				END IF;
				IF counter_s = conv_std_logic_vector(0,n) THEN
					--TODO DESABILITA OPERAÇÃO S SE counter_S = 0
					set_carry_s <= '1';
					en_carry_s <= '0';
					ls_s_op0 <= '0';
					en_s_op0 <= '0';
					en_s_op1 <= '0';					
				END IF;
				IF counter_t = conv_std_logic_vector(0,n) THEN
					rst_carry_t <= '1';
					en_carry_t <= '0';
					ls_t_op0 <= '0';
					en_t_op0 <= '0';
					en_t_op1 <= '0';
					en_t <= '0';
				END IF;
				
				IF ( counter_t = conv_std_logic_vector(0,n) ) THEN
					n_state <= s6;
				ELSE
					n_state <= s7;
				END IF;
				
				
			WHEN s6 =>
				counter_rd <= counter_rd - 1;
				counter_s <= counter_s - 1;
				counter_t <= counter_t - 1;
				
				IF counter_rd = conv_std_logic_vector(0,n) THEN
					--TODO DESABILITA OPERAÇÔES RD SE counter_rd = 0
					rst_carry_rd <= '1';
					en_carry_rd <= '0';
					ls_rd_op0 <= '0';
					ls_rd_op1 <= '0';
					en_rd_op0 <= '0';
					en_rd_op1 <= '0';
				END IF;
				IF counter_s = conv_std_logic_vector(0,n) THEN
					--TODO DESABILITA OPERAÇÃO S SE counter_S = 0
					set_carry_s <= '1';
					en_carry_s <= '0';
					ls_s_op0 <= '0';
					en_s_op0 <= '0';
					en_s_op1 <= '0';					
				END IF;
				IF counter_t = conv_std_logic_vector(0,n) THEN
					rst_carry_t <= '1';
					en_carry_t <= '0';
					ls_t_op0 <= '0';
					en_t_op0 <= '0';
					en_t_op1 <= '0';
					en_t <= '0';
				END IF;
				
				IF ( counter_t = conv_std_logic_vector(0,n) ) THEN
					n_state <= s6;
				ELSE
					n_state <= s7;
				END IF;
				
			WHEN s7 =>
				done <= '1';
				
				n_state <= s0;
				
		END CASE;
	END PROCESS;
	

END Behavioral;

