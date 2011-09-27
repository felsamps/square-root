LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
ENTITY tb_square_root IS
END tb_square_root;
 
ARCHITECTURE behavior OF tb_square_root IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT square_root
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         input : IN  std_logic_vector(7 downto 0);
         output : OUT  std_logic_vector(7 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';
   signal input : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(7 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: square_root PORT MAP (
          clk => clk,
          reset => reset,
          start => start,
          input => input,
          output => output,
          done => done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
		reset <= '1';
      wait for 100ns;	
		reset <= '0';
		wait for clk_period;
		wait for clk_period;
		wait for clk_period;

		input <= conv_std_logic_vector(4, 8);
		start <= '1';
		wait for clk_period;
		start <= '0';
		wait until (done = '1');
		wait for clk_period;
		wait for clk_period;
		
		input <= conv_std_logic_vector(25, 8);
		start <= '1';
		wait for clk_period;
		start <= '0';
		wait until (done = '1');
		wait for clk_period;
		wait for clk_period;
		
      -- insert stimulus here 

      wait;
   end process;

END;