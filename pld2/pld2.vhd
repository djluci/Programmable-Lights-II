library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity pld2 is

	port(
		clk	 : in	std_logic;
		reset	 : in	std_logic;
		lightsig : out	std_logic_vector(7 downto 0);
		IRView : out std_logic_vector(9 downto 0)
		--PCView : out std_logic_vector(3 downto 0)
	);

end entity;

architecture rtl of pld2 is

	component pldrom
		port 
		(
			--address of instruction to return
			addr : in std_logic_vector(3 downto 0);
			--instruction to be executed
			data : out std_logic_vector (9 downto 0)
		);
	end component;

	--Build an enumerated type for the state machine
	type state_type is (sFetch, sExecute1, sExecute2);

	--Register to hold the current state
	signal state : state_type;
	
	signal IR   : std_logic_vector(9 downto 0);
	signal PC	: UNSIGNED(3 downto 0);
	signal LR	: UNSIGNED(7 downto 0);
	signal ROMvalue : std_logic_vector(9 downto 0);
	
	signal ACC	: UNSIGNED(7 downto 0);
	signal SRC	: UNSIGNED(7 downto 0);

	

begin

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '0' then
			state <= sFetch;
			PC <= (others => '0');
			IR <= "0000000000";
			LR <= (others => '0');
		elsif (rising_edge(clk)) then
			case state is
				when sFetch=>
					IR <= ROMvalue;
					PC <= PC + 1;
					state <= sExecute1;
				when sExecute1=>
					case IR(9 downto 8) is 
					
						--move
						when "00" => 
							case IR(5 downto 4) is
								when "00" =>
									SRC <= ACC;
								when "01" =>
									SRC <= LR;
								when "10" =>
									SRC <= UNSIGNED(IR(3) & IR(3) & IR(3) & IR(3) & IR(3 downto 0));
								when others => 
									SRC <= "11111111";
							end case;
						
						--Binary operations
						when "01" => 
							case IR(4 downto 3) is	
								when "00" =>
									SRC <= ACC;
								when "01" => 
									SRC <= LR;
								when "10" => 
									SRC <= UNSIGNED(IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1 downto 0));
								when others => 
									SRC <= "11111111";
							end case;
							
						--unconditional branching
						when "10" => 
							PC <= UNSIGNED(IR(3 downto 0));
							
						--conditional branching 
						when "11" =>
							if IR(7) ='0' then
								if ACC = "00000000" then
									PC <= UNSIGNED(IR(3 downto 0));
								end if;
							else 
								if LR = "00000000" then
									PC <= UNSIGNED(IR(3 downto 0));
								end if;
							end if;
						
						when others=>
							NULL;		
									
					end case;
					
				state <= sExecute2;
					
				when sExecute2 =>
					case IR(9 downto 8) is
					
						--move instruction
						when "00" =>
							case IR(7 downto 6) is
								when "00" =>
									ACC <= SRC;
								when "01" =>
									LR <= SRC;
								when "10" =>
									ACC(3 downto 0) <= SRC(3 downto 0);
								when others =>
									ACC(7 downto 4) <= SRC(3 downto 0);
							end case;
							
						--binary operation
						when "01" =>
							case IR(7 downto 5) is
							
								--add operation
								when "000" =>
									if IR(2) = '0' then
										--ACC destination
										ACC <= ACC + SRC;
									else
										--LR destination
										LR <= LR + SRC;
									end if;
									
								--sub operation
								when "001" =>
									if IR(2) = '0' then
										--ACC destination
										ACC <= ACC - SRC;
									else
										--LR destination
										LR <= LR - SRC;
									end if;
								
								--shift left operation
								when "010" => 
									if IR(2) = '0' then 
										--ACC destination
										ACC <= SRC(6 downto 0) & '0';
									else
										--LR destination
										LR <= SRC(6 downto 0) & '0';
									end if;
									
								--shift right maintain sign bit operation
								when "011" =>
									if IR(2) = '0' then 
										--ACC destination
										ACC <= SRC(0) & SRC(7 downto 1);
									else
										--LR destination
										LR <= SRC(0) & SRC(7 downto 1);
									end if;
								
								--XOR operation
								when "100" =>
									if IR(2) = '0' then
										--ACC destination
										ACC <= ACC xor SRC;
									else
										--LR destination
										LR <= LR xor SRC;
									end if;
					
								--AND operation
								when "101" =>
									if IR(2) = '0' then
										--ACC destination
										ACC <= ACC and SRC;
									else
										--LR destination
										LR <= LR and SRC;
									end if;
									
								--rotate left 
								when "110" =>
									if IR(2) = '0' then 
										--ACC destination
										ACC <= SRC(0) & SRC(7 downto 1);
									else
										--LR destination
										LR <= SRC(0) & SRC(7 downto 1);
									end if;
								
								--rotate right
								when others =>
									if IR(2) = '0' then 
										--ACC destination
										ACC <= SRC(6 downto 0) & SRC(7);
									else
										--LR destination
										LR <= SRC(6 downto 0) & SRC(7);
									end if;
								
							end case;
						
						--branch instructions do nothing in sExecute2
						when others => 
							NULL;
					
					end case;
					state <= sFetch;
			end case;
		end if;
	end process;

	
	IRView <= IR;
	lightsig <= std_logic_vector(LR);
	
	--instantiate lightrom component using portmap statement
	pldrom1: pldrom port map(addr => std_logic_vector(PC), data => ROMvalue);

end rtl;