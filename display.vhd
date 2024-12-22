library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        done      : in  STD_LOGIC; -- Signal indicating encryption completion
        anodes    : out STD_LOGIC_VECTOR(3 downto 0); -- Anodes for 4-digit 7-segment display
        segments  : out STD_LOGIC_VECTOR(6 downto 0)  -- Segments (a-g) for 7-segment display
    );
end Display;

architecture Behavioral of Display is

    -- Characters to display ("AES ")
    constant CHAR_A : STD_LOGIC_VECTOR(6 downto 0) := "0001000"; -- Display 'A'
    constant CHAR_E : STD_LOGIC_VECTOR(6 downto 0) := "0000110"; -- Display 'E'
    constant CHAR_S : STD_LOGIC_VECTOR(6 downto 0) := "0100100"; -- Display 'S'
    constant CHAR_BLANK : STD_LOGIC_VECTOR(6 downto 0) := "1111111"; -- Blank display

    -- Timing control for multiplexing
    signal refresh_counter : integer range 0 to 199999 := 0;
    signal digit_select    : integer range 0 to 3 := 0;
    signal active_digit    : STD_LOGIC_VECTOR(3 downto 0) := "1110"; -- Activate first digit initially
    signal active_segments : STD_LOGIC_VECTOR(6 downto 0);

begin
    -- Refresh rate (1kHz refresh for 100MHz clock)
    process(clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = 199999 then
                refresh_counter <= 0;
                digit_select <= (digit_select + 1) mod 4;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    -- Select which digit to display
    process(digit_select, done)
    begin
        case digit_select is
            when 0 =>
                active_digit <= "1110"; -- Activate first digit
                active_segments <= CHAR_A when done = '1' else CHAR_BLANK;

            when 1 =>
                active_digit <= "1101"; -- Activate second digit
                active_segments <= CHAR_E when done = '1' else CHAR_BLANK;

            when 2 =>
                active_digit <= "1011"; -- Activate third digit
                active_segments <= CHAR_S when done = '1' else CHAR_BLANK;

            when others =>
                active_digit <= "0111"; -- Activate fourth digit (blank)
                active_segments <= CHAR_BLANK;
        end case;
    end process;

    -- Assign outputs
    anodes <= active_digit;
    segments <= active_segments;

end Behavioral;
