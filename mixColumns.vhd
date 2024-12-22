library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MixColumns is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
        state_out : out STD_LOGIC_VECTOR(127 downto 0)
    );
end MixColumns;

architecture Behavioral of MixColumns is

    -- Internal signals
    signal temp_state : STD_LOGIC_VECTOR(127 downto 0);

    -- Components for GF multiplications
    component LUT_mul2
        Port (
            byte_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            byte_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component LUT_mul3
        Port (
            byte_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            byte_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Function to XOR 4 bytes
    function xor4(a, b, c, d: STD_LOGIC_VECTOR(7 downto 0)) return STD_LOGIC_VECTOR is
    begin
        return a xor b xor c xor d;
    end function;

begin
    process(clk, reset)
        variable col : STD_LOGIC_VECTOR(31 downto 0); -- Each column is 32 bits
        variable result : STD_LOGIC_VECTOR(31 downto 0); -- Result after MixColumns
        variable mul2_out, mul3_out : STD_LOGIC_VECTOR(7 downto 0);
    begin
        if reset = '1' then
            temp_state <= (others => '0');
        elsif rising_edge(clk) then
            -- Process each of the 4 columns
            for i in 0 to 3 loop
                col := state_in((i * 32) + 31 downto i * 32); -- Extract 32-bit column

                -- Perform MixColumns operations for each byte in the column
                result(31 downto 24) <= xor4(
                    LUT_mul2(col(31 downto 24)), 
                    LUT_mul3(col(23 downto 16)), 
                    col(15 downto 8), 
                    col(7 downto 0)
                );

                result(23 downto 16) <= xor4(
                    col(31 downto 24), 
                    LUT_mul2(col(23 downto 16)), 
                    LUT_mul3(col(15 downto 8)), 
                    col(7 downto 0)
                );

                result(15 downto 8) <= xor4(
                    col(31 downto 24), 
                    col(23 downto 16), 
                    LUT_mul2(col(15 downto 8)), 
                    LUT_mul3(col(7 downto 0))
                );

                result(7 downto 0) <= xor4(
                    LUT_mul3(col(31 downto 24)), 
                    col(23 downto 16), 
                    col(15 downto 8), 
                    LUT_mul2(col(7 downto 0))
                );

                -- Update the state
                temp_state((i * 32) + 31 downto i * 32) <= result;
            end loop;
        end if;
    end process;

    -- Output state
    state_out <= temp_state;

end Behavioral;
