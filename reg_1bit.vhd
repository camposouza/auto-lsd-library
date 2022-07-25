library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reg_1bit is
  port (
          clock : in STD_LOGIC;
			 
			 reg_in  : in STD_LOGIC;
			 reg_ld  : in STD_LOGIC;
			 reg_rst : in STD_LOGIC;
			 
			 reg_out : out STD_LOGIC 
       );
end reg_1bit;

architecture rtl of reg_1bit is
begin
  process (reg_in, reg_ld, reg_rst, clock)
  begin
    if (reg_rst = '1') then
	   reg_out <= '0';
	 elsif (rising_edge(CLOCK) and reg_ld = '1') then
	   reg_out <= reg_in;
	 end if;
	end process;
end rtl;