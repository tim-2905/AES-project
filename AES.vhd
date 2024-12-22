architecture Behavioral of AES128 is
    signal state : std_logic_vector(127 downto 0);
    signal round_key : std_logic_vector(127 downto 0);
    signal round_counter : integer range 0 to 10 := 0;
    signal done : std_logic := '0';
    

begin
    process(clk, reset)
    begin
        if reset = '1' then
            aes_state <= IDLE;
            state <= (others => '0');
            round_counter <= 0;
            done <= '0';
        elsif rising_edge(clk) then
            case aes_state is
                when IDLE =>
                    if start_button = '1' then
                        aes_state <= INIT;
                    end if;

                when INIT =>
                    state <= plaintext;
                    round_key <= initial_key;
                    aes_state <= ROUND;

                when ROUND =>
                    if round_counter < 10 then
                        state <= next_state; -- Result from SubBytes, ShiftRows, MixColumns, AddRoundKey
                        round_key <= next_round_key;
                        round_counter <= round_counter + 1;
                    else
                        aes_state <= FINAL;
                    end if;

                when FINAL =>
                    state <= state xor round_key; -- Final AddRoundKey
                    aes_state <= DONE;

                when DONE =>
                    done <= '1'; -- Signal completion
                    if reset_button = '1' then
                        aes_state <= IDLE;
                    end if;

                when others =>
                    aes_state <= IDLE;

            end case;
        end if;
    end process;

    -- Output CipherText and Done Signal
    ciphertext <= state when done = '1' else (others => '0');
end Behavioral;
