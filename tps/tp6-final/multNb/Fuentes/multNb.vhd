library IEEE;
use IEEE.std_logic_1164.all;

--Multiplicador Generico.
entity multNb is
	generic(
		N: natural := 4
	);
	port(
		multiplicand: in std_logic_vector(N-1 downto 0);
		multiplier:	in std_logic_vector(N-1 downto 0);
		result:	out std_logic_vector(2*N-1 downto 0)
	);
end entity ; -- multNb

architecture multNb_arq of multNb is

	component sumNb is
		generic( N: natural := 4);
		port(
			a_i: 	in std_logic_vector(N-1 downto 0);
			b_i: 	in std_logic_vector(N-1 downto 0);
			ci_i: 	in std_logic;
			s_o: 	out std_logic_vector(N-1 downto 0);
			co_o: 	out std_logic
		);
	end component;

	type auxi is array(0 to N-2) of std_logic_vector(N-1 downto 0);
	type co_i is array(0 to N-2) of std_logic;


	signal aux: std_logic_vector(N-1 downto 0);
	signal a_aux: auxi;
	signal b_aux: auxi;
	signal salSum: auxi;
	signal salCo: co_i;
begin
	
	aux <= (N-1 downto 0 => multiplier(0)) and multiplicand;
	a_aux(0) <= '0' & aux(N-1 downto 1);
	result(0) <= aux(0);

	gen_multiplicador: for i in 0 to N-2 generate
		b_aux(i) <= (N-1 downto 0 => multiplier(i+1)) and multiplicand;
		result(i+1) <= salSum(i)(0);
		
		mult2_bit: if i = 0 generate
			adder_inst: sumNb
				generic map(
					N => N
				)
				port map(
					a_i 	=> a_aux(i),
					b_i 	=> b_aux(i),	
					ci_i	=> '0', 	
					s_o		=> salSum(i),
					co_o	=> salCo(i) 	
				);
		end generate;

		multN_bit: if i > 0 generate
			a_aux(i) <= salCo(i-1) & salSum(i-1)(N-1 downto 1);
			adder_inst: sumNb
				generic map(
					N => N
				)
				port map(
					a_i 	=> a_aux(i),
					b_i 	=> b_aux(i),	
					ci_i	=> '0', 	
					s_o		=> salSum(i),
					co_o	=> salCo(i) 	
				);
			result(i+1) <= salSum(i)(0);
		end generate;
	end generate ; -- gen_multiplicadors

	result(2*N-1 downto N)  <= salCo(N-2) & salSum(N-2)(N-1 downto 1);

end architecture ; -- multNb_arq