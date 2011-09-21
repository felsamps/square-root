LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
 
ENTITY tb_square_root IS
END tb_square_root;
 
ARCHITECTURE behavior OF tb_square_root IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT square_root
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         input : IN  std_logic_vector(7 downto 0);
         output : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal input : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: square_root PORT MAP (
          clk => clk,
          reset => reset,
          input => input,
          output => output
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
      reset <= '1';
      wait for 100ns;	
		reset <= '0';

      input <= conv_std_logic_vector(9,8);
		wait for clk_period;
		input <= conv_std_logic_vector(16,8);
      wait;
   end process;

END;
