library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AddRoundKey_tb is 
end AddRoundKey_tb;

architecture Behavioral of AddRoundKey_tb is

-- define component
component AddRoundKey is port (
clk: in std_logic;
reset: in std_logic;
PlainText_dataIn: in std_logic_vector(127 downto 0);
-- RoundKey_dataIn: in std_logic_vector(127 downto 0);
MatrixB: out std_logic_vector(127 downto 0);
-- next_key: in std_logic;
current_key_debug: out std_logic_vector(127 downto 0); -- Debug
xor_result_debug: out std_logic_vector(127 downto 0)  -- Debug 
);
end component;


-- internal wires
signal clk: std_logic := '0';
signal reset: std_logic := '0';
signal PlainText_dataIn: std_logic_vector(127 downto 0) := (others => '0');
-- signal RoundKey_dataIn: std_logic_vector(127 downto 0) := (others => '0');
signal MatrixB: std_logic_vector(127 downto 0);
-- signal next_key: std_logic := '0';

-- 512-Bit Plaintext (4 blocks of 128 Bits)
constant PlainText : std_logic_vector(127 downto 0) := x"6BC1BEE22E409F96E93D7E117393172A";
--  & x"AE2D8A571E03AC9C9EB76FAC45AF8E51" & x"30C81C46A35CE411E5FBC1191A0A52EF" & x"F69F2445DF4F9B17AD2B417BE66C3710";

-- split up into 128-Bit-blocks
-- signal PlainText_Block_0 : std_logic_vector(127 downto 0);
-- signal PlainText_Block_1 : std_logic_vector(127 downto 0);
-- signal PlainText_Block_2 : std_logic_vector(127 downto 0);
-- signal PlainText_Block_3 : std_logic_vector(127 downto 0);
signal current_key_debug: std_logic_vector(127 downto 0);
signal xor_result_debug: std_logic_vector(127 downto 0);

begin

-- PlainText_Block_0 <= PlainText_512(511 downto 384); -- first block
-- PlainText_Block_1 <= PlainText_512(383 downto 256); -- second block
-- PlainText_Block_2 <= PlainText_512(255 downto 128); -- third block
-- PlainText_Block_3 <= PlainText_512(127 downto 0);   -- fourth block

-- create instance
AddRoundKey_instance: AddRoundKey port map(
clk => clk,
reset => reset,
PlainText_dataIn => PlainText_dataIn,
MatrixB => MatrixB,
-- next_key => next_key,
current_key_debug => current_key_debug,
xor_result_debug => xor_result_debug
);


-- clock process
clk_process: process
begin
    while true loop
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end loop;
end process;


-- stimuli process
stimuli_process: process
begin
   
   
  -- first block 
  PlainText_dataIn <= PlainText; 
  wait for 40 ns; 
   
  reset <= '1';
  wait for 20 ns;
  reset <= '0'; 
   
-- second block
--    PlainText_dataIn <= PlainText_Block_1;
--    wait for 20 ns;

 -- third block
--    PlainText_dataIn <= PlainText_Block_2;
--    wait for 20 ns;

 -- fourth block
--    PlainText_dataIn <= PlainText_Block_3;
--    wait for 20 ns;
      
     
--     wait for 20 ns;
--     next_key <= '1';
--     wait for 40 ns;
--     next_key <= '0';
--     wait for 40 ns;

     wait;
     
     end process;

end Behavioral;
