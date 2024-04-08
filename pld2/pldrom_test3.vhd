-- pldrom.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pldrom is
    Port (
		  addr : in std_logic_vector (3 downto 0);
		  data : out std_logic_vector (9 downto 0)	
	 );
end pldrom;

architecture Behavioral of pldrom is 
begin
		data <=
			"00011110000" when addr = "0000" else -- (0) load 16 into the LR
			"0100100100" when addr = "0001" else -- (1) subtract 1 from the LR
			"0110000001" when addr = "0010" else -- (2) check if LR is 0, branch to (5) if true
			"1000000001" when addr = "0011" else -- (3) if not 0, jump back to (1) to continue subtracting
			"0001111111" when addr = "0100" else -- (4) load all 1s into the LR for flashing
			"0111101100" when addr = "0101" else -- (5) toggle LR between all 1s and 0s (start of flash sequence)
			"0101101100" when addr = "0110" else -- (6) toggle LR between all 1s and 0s
			"0101101100" when addr = "0111" else -- (7) toggle LR between all 1s and 0s
			"0101101100" when addr = "1000" else -- (8) toggle LR between all 1s and 0s
			"0101101100" when addr = "1001" else -- (9) toggle LR between all 1s and 0s
			"0101101100" when addr = "1010" else -- (10) toggle LR between all 1s and 0s
			"0101101100" when addr = "1011" else -- (11) toggle LR between all 1s and 0s
			"0101101100" when addr = "1100" else -- (12) toggle LR between all 1s and 0s
			"0101101100" when addr = "1101" else -- (13) toggle LR between all 1s and 0s (end of flash sequence)
			"1000000000" when addr = "1110" else -- (14) jump to instruction 0 to restart the process
			"1111111111";                        -- (15) garbage/default
		  
end Behavioral;