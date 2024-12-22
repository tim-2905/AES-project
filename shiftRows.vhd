library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRows is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
        state_out : out STD_LOGIC_VECTOR(127 downto 0)
    );
end ShiftRows;

architecture Behavioral of ShiftRows is
    signal temp_state : STD_LOGIC_VECTOR(127 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            temp_state <= (others => '0');
        elsif rising_edge(clk) then
            -- Perform row-wise shifts
            -- Row 0: No shift
            temp_state(127 downto 120) <= state_in(127 downto 120);
            temp_state(119 downto 112) <= state_in(119 downto 112);
            temp_state(111 downto 104) <= state_in(111 downto 104);
            temp_state(103 downto 96)  <= state_in(103 downto 96);

            -- Row 1: Shift left by 1
            temp_state(95 downto 88)   <= state_in(87 downto 80);
            temp_state(87 downto 80)   <= state_in(79 downto 72);
            temp_state(79 downto 72)   <= state_in(71 downto 64);
            temp_state(71 downto 64)   <= state_in(95 downto 88);

            -- Row 2: Shift left by 2
            temp_state(63 downto 56)   <= state_in(47 downto 40);
            temp_state(55 downto 48)   <= state_in(39 downto 32);
            temp_state(47 downto 40)   <= state_in(63 downto 56);
            temp_state(39 downto 32)   <= state_in(55 downto 48);

            -- Row 3: Shift left by 3
            temp_state(31 downto 24)   <= state_in(7 downto 0);
            temp_state(23 downto 16)   <= state_in(31 downto 24);
            temp_state(15 downto 8)    <= state_in(23 downto 16);
            temp_state(7 downto 0)     <= state_in(15 downto 8);
        end if;
    end process;

    -- Output state
    state_out <= temp_state;

end Behavioral;
