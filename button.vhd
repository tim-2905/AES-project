library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ButtonControl is
    Port (
        clk          : in  STD_LOGIC; -- 100 MHz clock
        reset        : in  STD_LOGIC; -- Reset input
        btn_start    : in  STD_LOGIC; -- Central button (start encryption)
        btn_reset    : in  STD_LOGIC; -- Right button (reset system)
        start        : out STD_LOGIC; -- Synchronized start signal
        reset_sync   : out STD_LOGIC  -- Synchronized reset signal
    );
end ButtonControl;

architecture Behavioral of ButtonControl is
    signal btn_start_sync : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal btn_reset_sync : STD_LOGIC_VECTOR(2 downto 0) := "000";
begin

    -- Debounce and synchronize start button
    process(clk)
    begin
        if rising_edge(clk) then
            btn_start_sync <= btn_start_sync(1 downto 0) & btn_start;
        end if;
    end process;

    start <= btn_start_sync(2) and not btn_start_sync(1); -- Detect rising edge

    -- Debounce and synchronize reset button
    process(clk)
    begin
        if rising_edge(clk) then
            btn_reset_sync <= btn_reset_sync(1 downto 0) & btn_reset;
        end if;
    end process;

    reset_sync <= btn_reset_sync(2); -- Synchronized reset

end Behavioral;
