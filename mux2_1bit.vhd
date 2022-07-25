library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux2_1bit is
	port(
          A1      : in  STD_LOGIC;
          A2      : in  STD_LOGIC;
			 SEL     : in  STD_LOGIC;
          B       : out STD_LOGIC
		  );
end mux2_1bit;

architecture rtl of mux2_1bit is
begin
	mux2 : process(A1,A2, SEL)
	begin
	  case SEL is
		 when '0' => B <= A1 ;
		 when '1' => B <= A2 ;
		  when others => B <= A2;
	  end case;
	end process mux2;
end rtl;