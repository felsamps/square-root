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
	
	COMPONENT datapath IS
		GENERIC( n : INTEGER := 8);
		PORT (
			clk, rst_datapath : IN STD_LOGIC;
			--R Datapath
			rst_carry_rd, set_carry_rd, en_carry_rd : IN STD_LOGIC;
			ls_rd_op0, ls_rd_op1, en_rd_op0, en_rd_op1 : IN STD_LOGIC;
			
			--S Datapath
			rst_carry_s, set_carry_s, en_carry_s : IN STD_LOGIC;
			ls_s_op0, en_s_op0, en_s_op1 : IN STD_LOGIC;
			
			--T Datapath
			rst_carry_t, set_carry_t, en_carry_t : IN STD_LOGIC;
			ls_t_op0, en_t_op0, en_t_op1 : IN STD_LOGIC;
			en_t : IN STD_LOGIC;
		
			input : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			t : OUT STD_LOGIC;
			output : OUT  STD_LOGIC_VECTOR (n-1 DOWNTO 0)
		);	
	end COMPONENT;
	
	COMPONENT control IS
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
	END COMPONENT;
	
	SIGNAL t : STD_LOGIC;
	SIGNAL rst_datapath : STD_LOGIC;
	SIGNAL rst_carry_rd, set_carry_rd, en_carry_rd : STD_LOGIC;
	SIGNAL ls_rd_op0, ls_rd_op1, en_rd_op0, en_rd_op1 : STD_LOGIC;
	SIGNAL rst_carry_s, set_carry_s, en_carry_s : STD_LOGIC;
	SIGNAL ls_s_op0, en_s_op0, en_s_op1 : STD_LOGIC;
	SIGNAL rst_carry_t, set_carry_t, en_carry_t : STD_LOGIC;
	SIGNAL ls_t_op0, en_t_op0, en_t_op1 : STD_LOGIC;
	SIGNAL en_t : STD_LOGIC;

BEGIN

	DATAPATH_0: datapath GENERIC MAP (n)
		PORT MAP (
			clk => clk,
			rst_datapath => rst_datapath,
			rst_carry_rd => rst_carry_rd,
			set_carry_rd => set_carry_rd,
			en_carry_rd => en_carry_rd,
			ls_rd_op0 => ls_rd_op0,
			ls_rd_op1 => ls_rd_op1,
			en_rd_op0 => en_rd_op0,
			en_rd_op1 => en_rd_op1,
			rst_carry_s => rst_carry_s,
			set_carry_s => set_carry_s,
			en_carry_s => en_carry_s,
			ls_s_op0 => ls_s_op0,
			en_s_op0 => en_s_op0,
			en_s_op1 => en_s_op1,
			rst_carry_t => rst_carry_t,
			set_carry_t => set_carry_t,
			en_carry_t => en_carry_t,
			ls_t_op0 => ls_t_op0,
			en_t_op0 => en_t_op0,
			en_t_op1 => en_t_op1,
			en_t => en_t,
			input => input,
			t => t,
			output => output
		);	
	
	
		CONTROL_0: control GENERIC MAP(n)
		PORT MAP (
			clk => clk,
			reset => reset,
			start => start,
			t => t,
			rst_datapath => rst_datapath,
			rst_carry_rd => rst_carry_rd,
			set_carry_rd => set_carry_rd,
			en_carry_rd => en_carry_rd,
			ls_rd_op0 => ls_rd_op0,
			ls_rd_op1 => ls_rd_op1,
			en_rd_op0 => en_rd_op0,
			en_rd_op1 => en_rd_op1,
			rst_carry_s => rst_carry_s,
			set_carry_s => set_carry_s,
			en_carry_s => en_carry_s,
			ls_s_op0 => ls_s_op0,
			en_s_op0 => en_s_op0,
			en_s_op1 => en_s_op1,
			rst_carry_t => rst_carry_t,
			set_carry_t => set_carry_t,
			en_carry_t => en_carry_t,
			ls_t_op0 => ls_t_op0,
			en_t_op0 => en_t_op0,
			en_t_op1 => en_t_op1,
			en_t => en_t,			
			done => done
		);
	
END Behavioral;
