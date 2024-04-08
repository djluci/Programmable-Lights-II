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
		 "0001110000" when addr = "0000" else -- move 11111111 to the LR    
		 "0011100000" when addr = "0001" else -- move 0000 from the IR to the high 4 bits of the ACC
		 "0010100010" when addr = "0010" else -- move 0010 from the IR to the low 4 bits of the ACC
		 "0100000100" when addr = "0011" else -- Add ACC to LR and put it back into the LR
		 "0100000100" when addr = "0100" else -- Add ACC to LR and put it back into the LR
		 "0100100100" when addr = "0101" else -- Subtract ACC from LR and put it back into the LR
		 "0101001100" when addr = "0110" else -- Shift the LR left and write it back to the LR
		 "0101101100" when addr = "0111" else -- Shift the LR right and write it back to the LR
		 "0111101100" when addr = "1000" else -- Rotate the LR right and write it back to the LR
		 "0101101100" when addr = "1001" else -- Shift the LR right and write it back to the LR
		 "0110011100" when addr = "1010" else -- XOR the LR with all 1s and write it back to the LR (bit inversion)
		 "0110110101" when addr = "1011" else -- AND the LR with 01 (sign-extended)
		 "0100010110" when addr = "1100" else -- ADD the LR with 10 (sign-extended)
		 "1111111111";                        -- garbage
		  
		  
end Behavioral;