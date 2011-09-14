LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY datapath IS
	GENERIC( n : INTEGER := 8);
	PORT (
		clk, rst_datapath : IN STD_LOGIC;
		--R Datapath
		rst_carry_r, set_carry_r, en_carry_r : IN STD_LOGIC;
		ls_r_op0, ls_r_op1, en_r_op0, en_r_op1 : IN STD_LOGIC;
		
		--D Datapath
		rst_carry_d, set_carry_d, en_carry_d : IN STD_LOGIC;
		ls_d_op0, ls_d_op1, en_d_op0, en_d_op1 : IN STD_LOGIC;
		
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
end datapath;

ARCHITECTURE Behavioral OF datapath IS

	COMPONENT shift_register is
		GENERIC( n : INTEGER := 8 );
		PORT (
			clk, reset : IN STD_LOGIC;
			en, load_shift : IN  STD_LOGIC;
			sd : IN  STD_LOGIC;
			d : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			sq : OUT STD_LOGIC;
			q : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT one_bit_register is
		GENERIC( n : INTEGER := 8 );
		PORT (
			clk, reset, set : IN STD_LOGIC;
			en : IN STD_LOGIC;
			d : IN  STD_LOGIC;
			q : OUT STD_LOGIC		
		);
	END COMPONENT;

	--R INTERNAL SIGNALS
	SIGNAL carry_in_r, op0_r, op1_r : STD_LOGIC;
	SIGNAL add_r : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	--D INTERNAL SIGNALS
	SIGNAL carry_in_d, op0_d, op1_d : STD_LOGIC;
	SIGNAL add_d : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	--S INTERNAL SIGNALS
	SIGNAL carry_in_s, op0_s, op1_s : STD_LOGIC;
	SIGNAL add_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	--T INTERNAL SIGNALS
	SIGNAL carry_in_t, op0_t, op1_t : STD_LOGIC;
	SIGNAL sub_t : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

	--R DATA PATH--------------------------------------------------------------------
	OP_0_R_SR: shift_register GENERIC MAP (n) PORT MAP(
		clk => clk,
		reset => rst_datapath, 
		en => en_r_op0, 
		load_shift => ls_r_op0, 
		sd => add_r(0), 
		d => conv_std_logic_vector(1,n), 
		sq => op0_r, 
		q => output
	);
	
	OP_1_R_SR: shift_register GENERIC MAP (n) PORT MAP(
		clk => clk,
		reset => rst_datapath, 
		en => en_r_op1, 
		load_shift => ls_r_op1, 
		sd => op1_r, 
		d => conv_std_logic_vector(1,n), 
		sq => op1_r, 
		q => open
	);
	
	CARRY_REG_R: one_bit_register PORT MAP( clk => clk, reset => rst_carry_r, set => set_carry_r, en => en_carry_r, d => add_r(1), q => carry_in_r);
	
	add_r <= ('0'&op0_r) + ('0'&op1_r) + ('0'&carry_in_r);
	
	--D DATA PATH--------------------------------------------------------------------
	OP_0_D_SR: shift_register GENERIC MAP (n)	PORT MAP(
		clk => clk,
		reset => rst_datapath, 
		en => en_d_op0, 
		load_shift => ls_d_op0, 
		sd => add_d(0), 
		d => conv_std_logic_vector(2,n), 
		sq => op0_d, 
		q => open
	);
	
	OP_1_D_SR: shift_register GENERIC MAP (n)	PORT MAP(
		clk => clk,
		reset => rst_datapath, 
		en => en_d_op1, 
		load_shift => ls_d_op1, 
		sd => op1_d, 
		d => conv_std_logic_vector(2,n), 
		sq => op1_d, 
		q => open
	);
	
	CARRY_REG_D: one_bit_register PORT MAP( clk => clk, reset => rst_carry_d, set => set_carry_d, en => en_carry_d, d => add_d(1), q => carry_in_d);
	
	add_d <= ('0'&op0_d) + ('0'&op1_d) + ('0'&carry_in_d);
	
	--S DATA PATH--------------------------------------------------------------------
	OP_0_S_SR: shift_register GENERIC MAP (n)	PORT MAP(
		clk => clk,
		reset => rst_datapath, 
		en => en_s_op0, 
		load_shift => ls_s_op0, 
		sd => add_s(0), 
		d => conv_std_logic_vector(4,n), 
		sq => op0_s, 
		q => open
	);
	
	OP_1_S_REG: one_bit_register PORT MAP( clk => clk, reset => rst_datapath, set => '0', en => en_s_op1, d => add_d(0), q => op1_s);
	
	CARRY_REG_S: one_bit_register PORT MAP( clk => clk, reset => rst_carry_s, set => set_carry_s, en => en_carry_s, d => add_s(1), q => carry_in_s);
	
	add_s <= ('0'&op0_s) + ('0'&op1_s) + ('0'&carry_in_s);
	
	--T DATA PATH--------------------------------------------------------------------
	OP_0_T_SR: shift_register GENERIC MAP (n)	PORT MAP(
		clk => clk,
		reset => rst_datapath, 
		en => en_t_op0, 
		load_shift => ls_t_op0, 
		sd => sub_t(0), 
		d => input, 
		sq => op0_t, 
		q => open
	);
	
	OP_1_T_REG: one_bit_register PORT MAP( clk => clk, reset => rst_datapath, set => '0', en => en_t_op1, d => add_s(0), q => op1_t);
	
	CARRY_REG_T: one_bit_register PORT MAP( clk => clk, reset => rst_carry_t, set => set_carry_t, en => en_carry_t, d => sub_t(1), q => carry_in_t);
	
	sub_t <= ('0'&op0_t) + ('0'&op1_t) + ('0'&carry_in_t);
	
	REG_T: one_bit_register PORT MAP( clk => clk, reset => rst_datapath, set => '0', en => en_t, d => sub_t(0), q => t);

END Behavioral;

