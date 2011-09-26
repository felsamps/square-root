library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity square_root is
	GENERIC( n : INTEGER := 8);
    Port ( clk, reset, start : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (n-1 downto 0);
           output : out  STD_LOGIC_VECTOR (n-1 downto 0);
           done : out  STD_LOGIC);
end square_root;

architecture Behavioral of square_root is

	COMPONENT datapath IS
		GENERIC( n : INTEGER := 8);
		PORT (
			clk, reset : IN  STD_LOGIC;
			load_i, load_out, load_r, load_s, load_d, load_t, op : IN  STD_LOGIC;
			sel_mux0, sel_mux1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			input : IN  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			t : OUT STD_LOGIC;
			output : OUT  STD_LOGIC_VECTOR (n-1 DOWNTO 0)
		);	
	end COMPONENT;
	
	COMPONENT control IS
		PORT (
			clk,reset : in  STD_LOGIC;
			start, t : in  STD_LOGIC;
			rst_d, load_r, load_i, load_d, load_s, load_out, load_t, op : out  STD_LOGIC;
			sel_mux0, sel_mux1 : out  STD_LOGIC_VECTOR (1 downto 0);
			done : out  STD_LOGIC
		);
	END COMPONENT;

	SIGNAL rst_d, load_i, load_out, load_r, load_s, load_d, load_t, op : STD_LOGIC;
	SIGNAL sel_mux0, sel_mux1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL t : STD_LOGIC;
	
begin

	DATAPATH_0: datapath GENERIC MAP(n) 
		PORT MAP(
			clk => clk,
			reset => rst_d,
			load_i => load_i,
			load_out => load_out,
			load_r => load_r,
			load_s => load_s,
			load_d => load_d,
			load_t => load_t,
			op => op,
			sel_mux0 => sel_mux0,
			sel_mux1 => sel_mux1,
			input => input,
			t => t,
			output => output
		);	
		
	CONTROL_0: control 
		PORT MAP(
			clk => clk,
			reset => reset,
			start => start,
			t => t,
			rst_d => rst_d,
			load_i => load_i,
			load_out => load_out,
			load_r => load_r,
			load_s => load_s,
			load_d => load_d,
			load_t => load_t,
			op => op,
			sel_mux0 => sel_mux0,
			sel_mux1 => sel_mux1,
			done => done
		);

end Behavioral;

