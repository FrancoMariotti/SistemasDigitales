library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
	port(
		x0:   in std_logic_vector(3 downto 0);
		x1:   in std_logic_vector(3 downto 0);
		x2:   in std_logic_vector(3 downto 0);
		x3:   in std_logic_vector(3 downto 0);
		sel:  in std_logic_vector(1 downto 0);
		sal:  out std_logic_vector(3 downto 0)
	);
end;

architecture mux_arq of mux is
	--parte declarativa
begin
	--parte descriptiva
	process(sel,x0,x1,x2,x3) is
	begin
		case sel is
		 when "00" => sal <= x0;
		 when "01" => sal <= x1;
		 when "10" => sal <= x2;
		 when others => sal <= x3;
		end case;
	end process;
end mux_arq;
 