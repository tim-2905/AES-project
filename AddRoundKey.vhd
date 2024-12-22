library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity AddRoundKey is port(
clk: in std_logic;
reset: in std_logic;
PlainText_dataIn: in std_logic_vector(127 downto 0);
-- RoundKey_dataIn: in std_logic_vector(127 downto 0);
MatrixB: out std_logic_vector(127 downto 0);
-- next_key: in std_logic; -- input to choose next key if required
current_key_debug: out std_logic_vector(127 downto 0); -- Debug
xor_result_debug: out std_logic_vector(127 downto 0)  -- Debug 
);
end AddRoundKey;

architecture Behavioral of AddRoundKey is

type key_array_type is array (0 to 10) of std_logic_vector(127 downto 0); -- define new type named key_array_type which is an eleven element array
constant AES_key: key_array_type := ( -- define a constant of type key_array_type
x"2b7e151628aed2a6abf7158809cf4f3c",
x"a0fafe1788542cb123a339392a6c7605",
x"f2c295f27a96b9435935807a7359f67f",
x"3d80477d4716fe3e1e237e446d7a883b",
x"ef44a541a8525b7fb671253bdb0bad00",
x"d4d1c6f87c839d87caf2b8bc11f915bc",
x"6d88a37a110b3efddbf98641ca0093fd",
x"4e54f70e5f5fc9f384a64fb24ea6dc4f",
x"ead27321b58dbad2312bf5607f8d292f",
x"ac7766f319fadc2128d12941575c006e",
x"d014f9a8c9ee2589e13f0cc8b6630ca6" 
);

type matrix_type is array(3 downto 0, 3 downto 0) of std_logic_vector(7 downto 0);
signal PlainTextMatrix: matrix_type;
signal KeyMatrix : matrix_type;
signal MatrixResult: matrix_type;
signal key_number: integer range 0 to 10 := 0; -- actual key number
-- signal prev_next_key: std_logic := '0'; -- for clock edge detection

 
begin

AddRoundKey_process: process(clk, reset)

    variable key : std_logic_vector(127 downto 0);
    variable row, col: integer;

    
    begin
    
    if rising_edge(clk)then
    
        if reset = '1' then -- if reset is set, set all entries to zero
        
            key_number <= 0; -- reset also the actual key number
--            prev_next_key <= '0';
        
            for col in 0 to 3 loop
                for row in 0 to 3 loop
                
                KeyMatrix(row,col) <= (others => '0'); --"00000000"; 
                PlainTextMatrix(row,col) <= (others => '0'); -- "00000000";
                MatrixResult(row,col) <= (others => '0'); --"00000000";
                current_key_debug <= (others => '0');
                xor_result_debug <= (others => '0');

                end loop;
            end loop;    

        else 
          

--                if next_key = '1' and prev_next_key = '0' then -- increment key_number only if it is requested and by rising clock edge 
                
--                      if key_number < 10 then -- check if key not exceed the maximum number of keys 
--                      
--                            key_number <= key_number + 1;
                            
--                      end if;
                      
--                 end if;

--                 prev_next_key <= next_key; -- represents key state of previous clock cycle
                          
            key := AES_key(key_number);
            
             for col in 0 to 3 loop  -- fill in key matrix column-wise with keys stored in constant AES_key
                 for row in 0 to 3 loop
                
                        KeyMatrix(row,col) <= key((127 - (col * 32) - (row * 8)) downto (120 - (col * 32) - (row * 8)));
                        
                 end loop;
              end loop;                 
             
             
             for col in 0 to 3 loop -- fill in PlainTextMatrix column-wise with plainText_data
                for row in 0 to 3 loop  
                
                    PlainTextMatrix(row,col) <= PlainText_dataIn((127 - (col * 32) - (row * 8)) downto (120 - (col * 32) - (row * 8)));
                    
                end loop;
             end loop;
             
             for col in 0 to 3 loop -- XOR plainText and keys elementwise and store in new Matrix
                for row in 0 to 3 loop
             
                    MatrixResult(row, col) <= KeyMatrix(row, col) xor PlainTextMatrix(row, col);
                    
                end loop;
            end loop;        
              
          MatrixB <=       MatrixResult(0, 0) & MatrixResult(1, 0) & MatrixResult(2, 0) & MatrixResult(3, 0) & -- transform matrix back into bit shape
                           MatrixResult(0, 1) & MatrixResult(1, 1) & MatrixResult(2, 1) & MatrixResult(3, 1) &
                           MatrixResult(0, 2) & MatrixResult(1, 2) & MatrixResult(2, 2) & MatrixResult(3, 2) &
                           MatrixResult(0, 3) & MatrixResult(1, 3) & MatrixResult(2, 3) & MatrixResult(3, 3);  
              

            end if;
         end if;   
            
            current_key_debug <= AES_key(key_number); 
            xor_result_debug <= PlainText_dataIn xor AES_key(key_number);      
               
                             
end process;



end Behavioral;
