library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reg_concat_17bits is
  port (
          clock : in STD_LOGIC;
			 
			 reg_in        : in STD_LOGIC_VECTOR(15 downto 0);
			 bit_concat    : in STD_LOGIC;
			 reg_ld        : in STD_LOGIC;
			 reg_rst       : in STD_LOGIC;
			 reg_out       : out STD_LOGIC_VECTOR(16 downto 0)
       );
end reg_concat_17bits;

architecture rtl of reg_concat_17bits is
begin
  process (reg_in, bit_concat, reg_ld, reg_rst, clock)
  begin
    if (reg_rst = '1') then
	   reg_out <= "00000000000000000";
	 elsif (rising_edge(CLOCK) and reg_ld = '1') then
	   reg_out <= reg_in & bit_concat;
	 end if;
	end process;
end rtl;