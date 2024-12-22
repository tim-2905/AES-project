library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AES_FSM is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        start       : in  STD_LOGIC; -- Start signal
        round_done  : in  STD_LOGIC; -- Signal from pipeline when a round finishes
        final_done  : out STD_LOGIC; -- Signal indicating encryption is complete
        round_key   : out INTEGER range 0 to 10 -- Current round key index
    );
end AES_FSM;

architecture Behavioral of AES_FSM is
    type state_type is (IDLE, INIT, ROUND, FINAL, DONE);
    signal aes_state : state_type := IDLE;
    signal round     : INTEGER range 0 to 10 := 0;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            aes_state <= IDLE;
            round <= 0;
            final_done <= '0';
        elsif rising_edge(clk) then
            case aes_state is
                when IDLE =>
                    final_done <= '0';
                    if start = '1' then
                        aes_state <= INIT;
                    end if;

                when INIT =>
                    round <= 0;
                    aes_state <= ROUND;

                when ROUND =>
                    if round_done = '1' then
                        if round < 10 then
                            round <= round + 1;
                        else
                            aes_state <= FINAL;
                        end if;
                    end if;

                when FINAL =>
                    aes_state <= DONE;

                when DONE =>
                    final_done <= '1';
                    if start = '1' then
                        aes_state <= INIT;
                    end if;

                when others =>
                    aes_state <= IDLE;

            end case;
        end if;
    end process;

    round_key <= round; -- Output current round key index

end Behavioral;
