library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity comp is
	generic (N:integer := 8);
	port (  
			  A  : IN STD_LOGIC_VECTOR(N-1 downto 0);
			  B  : IN STD_LOGIC_VECTOR(N-1 downto 0);
			  eq : OUT STD_LOGIC
			);

end comp;

architecture rtl of comp is
begin
    with A = B select
    eq <= '1' when true,
          '0' when others;
end rtl;