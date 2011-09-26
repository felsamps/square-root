LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_square_root IS
END tb_square_root;
 
ARCHITECTURE behavior OF tb_square_root IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT square_root
    PORT(
         clk : IN  std_logic;
         start : IN  std_logic;
         input : IN  std_logic_vector(15 downto 0);
         done : OUT  std_logic;
         output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal input : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal done : std_logic;
   signal output : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: square_root PORT MAP (
          clk => clk,
          start => start,
          input => input,
          done => done,
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
      -- hold reset state for 100ms.
		start <= '1';
      wait for 20ns;	
		input <= conv_std_logic_vector(24,16);
      wait for 20ns;
		start <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
