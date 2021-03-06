library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--sumador generico de N bits.
entity sumNb is
	generic( N: natural := 4);
	port(
		a_i: 	in std_logic_vector(N-1 downto 0);
		b_i: 	in std_logic_vector(N-1 downto 0);
		ci_i: 	in std_logic;
		s_o: 	out std_logic_vector(N-1 downto 0);
		co_o: 	out std_logic
	);
end entity;


-- Version sin sumador de 1 bit
--architecture sumNb_arq of sumNb is
--	signal res: std_logic_vector(N+1 downto 0) := (others => '0');
--begin
--	res 	<= std_logic_vector(unsigned('0' & a_i & ci_i) + unsigned('0' & b_i & '1'));
--	s_o	<= res(N downto 1);
--	co_o 	<= res(N+1);
--end architecture;


--Version con Sumador de 1 bit

architecture sumNb_arq of sumNb is

	component sum1b is
		port(
			a_i	: in std_logic;
			b_i	: in std_logic;
			ci_i: in std_logic;
			s_o	: out std_logic;
			co_o: out std_logic
		);
	end component;

	signal aux: std_logic_vector(N downto 0);
	
begin

	aux(0) <= ci_i;
	
	sumNbgen: for i in 0 to N-1 generate
			sum1b_inst: sum1b
				port map(
					a_i		=> a_i(i),
					b_i		=> b_i(i),
					ci_i	=> aux(i),
					s_o		=> s_o(i),
					co_o	=> aux(i+1)
				);
	end generate;
	
	co_o <= aux(N);

end architecture;
