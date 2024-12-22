library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SubBytes is
    Port (
        clk : in std_logic;                                
        reset : in std_logic;                              
        MatrixB_in : in std_logic_vector(127 downto 0);    -- output matrix of AddRoundKey
        MatrixB_out : out std_logic_vector(127 downto 0)   -- output of SubBytes
    );
end SubBytes;

architecture Behavioral of SubBytes is

    type byte_array is array(0 to 15) of std_logic_vector(7 downto 0);

    -- internal signals
    signal input_bytes : byte_array;
    signal output_bytes : byte_array;

begin

    -- decomposition of input matrix in bytes
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
           
                for i in 0 to 15 loop
                    input_bytes(i) <= (others => '0');
                end loop;
                        
            else
                for i in 0 to 15 loop
                    input_bytes(i) <= MatrixB_in((127 - i * 8) downto (120 - i * 8));
                end loop;
            end if;
        end if;
    end process;
    

    -- use component S_box
gen_sbox: for i in 0 to 15 generate
    S_box_inst: entity work.S_box
        port map(
            byte_in => input_bytes(i),
            byte_out => output_bytes(i)
        );
end generate;


    -- create output matrix
    process(clk)
    begin
        if rising_edge(clk) then 
        
--                if reset = '0' then
                    
                 MatrixB_out <= output_bytes(0) & output_bytes(1) & output_bytes(2) & output_bytes(3) &
                                   output_bytes(4) & output_bytes(5) & output_bytes(6) & output_bytes(7) &
                                   output_bytes(8) & output_bytes(9) & output_bytes(10) & output_bytes(11) &
                                   output_bytes(12) & output_bytes(13) & output_bytes(14) & output_bytes(15);
   
--                else
                
--                    MatrixB_out <= (others => '0');
                    
--                end if;    
        end if;
        
    end process;

end Behavioral;
