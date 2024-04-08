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
		  "0001100000" when addr = "0000" else -- move 0s to LR   00000000/00000000
		  "0001110000" when addr = "0001" else -- move 1s to LR   11111111/00000000
		  "0001101010" when addr = "0010" else -- move 1010 to LR 11111010/00000000
		  "0010101000" when addr = "0011" else -- move 8 to ACC   11111010/00001000
		  "0101001100" when addr = "0100" else -- shift LR left   
		  "0100011000" when addr = "0101" else -- add -1 to ACC  
		  "1100001000" when addr = "0110" else -- branch if  zero  
		  "1000000100" when addr = "0111" else -- branch  
		  "0001110000" when addr = "1000" else -- set LR to 1s    11111111/00000000
		  "1000000000" when addr = "1001" else -- branch to zero  11111111/00000000
		  "0101010101" when addr = "1010" else -- garbage
		  "1010101010" when addr = "1011" else -- garbage
		  "1100110011" when addr = "1100" else -- garbage
		  "0011001100" when addr = "1101" else -- garbage
		  "0000000000" when addr = "1110" else -- garbage
		  "1111111111";                        -- garbage	
		  
end Behavioral;