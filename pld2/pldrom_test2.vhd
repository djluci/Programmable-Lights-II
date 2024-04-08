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
		"0010001000" when addr = "0000" else --0) initialize ACC with 0 (0000 in high and low)
		"0100000000" when addr = "0001" else --1) clear LR before starting the program
		"0111100000" when addr = "0010" else --2) load 16 into the LR
		"0001000000" when addr = "0011" else --3) check if LR is 0, if so branch to instruction 8 to start flashing
		"0111011111" when addr = "0100" else --4) subtract 1 from LR (count down)
		"1100000010" when addr = "0101" else --5) branch back to instruction 2 to continue countdown
		"0111111111" when addr = "0110" else --6) load all 1s into LR (start flash)
		"0010001000" when addr = "0111" else --7) reinitialize ACC for counter
		"0101010101" when addr = "1000" else --8) subtract 1 from ACC to count 8 flashes
		"0001000000" when addr = "1001" else --9) check if ACC is 0, if so branch to instruction 1 to restart program
		"0100000000" when addr = "1010" else --10) load all 0s into LR (continue flash)
		"1100001000" when addr = "1011" else --11) branch back to instruction 8 if ACC is not 0 to continue flashing
		"1100000001" when addr = "1100" else --12) branch back to instruction 1 to clear LR and start countdown again
		"1111111111";
		
end Behavioral;