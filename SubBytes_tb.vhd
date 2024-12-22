library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SubBytes_tb is
end SubBytes_tb;

architecture Behavioral of SubBytes_tb is


    component SubBytes is
        Port (
            clk : in std_logic;
            reset : in std_logic;
            MatrixB_in : in std_logic_vector(127 downto 0);    
            MatrixB_out : out std_logic_vector(127 downto 0)   
        );
    end component;


    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal MatrixB_in : std_logic_vector(127 downto 0) := (others => '0');
    signal MatrixB_out : std_logic_vector(127 downto 0);


    constant Test_Input : std_logic_vector(127 downto 0) := x"40BFABF406EE4D3042CA6B997A5C5816"; 

begin


    SubBytes_inst : SubBytes
        port map(
            clk => clk,
            reset => reset,
            MatrixB_in => MatrixB_in,
            MatrixB_out => MatrixB_out
        );


    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;


    stimulus_process : process
    begin

        reset <= '1';
        wait for 20 ns; 
        reset <= '0';
        wait for 20 ns;

        MatrixB_in <= Test_Input;
        wait for 20 ns; 


        MatrixB_in <= x"F265E8D51FD2397BC3B9976D9076505C";
        wait for 20 ns; 


        reset <= '1';
        wait for 20 ns;
        reset <= '0';


        MatrixB_in <= x"FDF37CDB4B0C8C1BF7FCD8E94AA9BBF8";
        wait for 20 ns;


        wait;
    end process;

end Behavioral;
