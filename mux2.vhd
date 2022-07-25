library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux2 is
	generic (N:integer := 16);
	port(
          A1      : in  STD_LOGIC_VECTOR(N-1 downto 0);
          A2      : in  STD_LOGIC_VECTOR(N-1 downto 0);
			 SEL     : in  STD_LOGIC;
          B       : out STD_LOGIC_VECTOR(N-1 downto 0)
		  );
end mux2;

architecture rtl of mux2 is
begin
	p_mux : process(A1,A2, SEL)
	begin
	  case SEL is
		 when '0' => B <= A1 ;
		 when '1' => B <= A2 ;
		 when others => B <= A2;
	  end case;
	end process p_mux;
end rtl;