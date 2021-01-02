library IEEE;
use IEEE.std_logic_1164.all;

--mutiplicador de punto flotante.
entity mult_PF is
	generic(
		WORD_SIZE: natural := 23,
		EXP_SIZE: natural := 6
	);
	port(
		a_i:	in std_logic_vector(WORD_SIZE-1 downto 0);
		b_i:	in std_logic_vector(WORD_SIZE-1 downto 0);
		s_o:	out std_logic_vector(WORD_SIZE-1 downto 0)
	);
end entity;

architecture behavioral of mult_PF is

	--declaracion multiplicador.
	component multiplicador is
		generic(
			N: natural := 4
		);
		port(
			clk_i    : in std_logic;
			load_i   : in std_logic;
			opA_i    : in std_logic_vector(N-1 downto 0);
			opB_i    : in std_logic_vector(N-1 downto 0);
			product_o: out std_logic_vector(2*N-1 downto 0)
		);
	end component;

	constant SIGNIFICAND_SIZE:	natural := WORD_SIZE - EXP_SIZE;
	constant MANTISA_SIZE:		natural := SIGNIFICAND_SIZE-1;
	constant RESULT_SIZE:		natural := 2*SIGNIFICAND_SIZE;

	signal x0:					std_logic;
	signal exponentResult:		std_logic_vector(EXP_SIZE-1 downto 0);	

	signal significandA:		std_logic_vector(SIGNIFICAND_SIZE-1 downto 0);
	signal significandB:		std_logic_vector(SIGNIFICAND_SIZE-1 downto 0);
	signal significandResult:	std_logic_vector(RESULT_SIZE downto 0);
begin
	
	significandA <= '1' & a_i(MANTISA_SIZE-1 downto 0);
	significandB <= '1' & b_i(MANTISA_SIZE-1 downto 0);
	
	-- instancia multiplicador para enteros sin signo.
	mult_inst: multiplicador
		generic map(
			N => SIGNIFICAND_SIZE
		)
		port map(
			clk_i		=> , 
			load_i		=> ,
			opA_i		=> significandA,
			opB_i		=> significandB,
			product_o	=> significandResult
		);

	--falta tener en cuenta que el multiplicador tarda N ciclos en obtener el resultado.
	--bit mas significativo del resultado de significandA * significandB.
	x0 <= significandResult(RESULT_SIZE-1);

	s_o(MANTISA_SIZE-1 downto 0) <=	significandResult(RESULT_SIZE-2 downto SIGNIFICAND_SIZE) when x0 = '1' else
									else significandResult(RESULT_SIZE-3 downto SIGNIFICAND_SIZE+1)
														
	-- signo del resultado.
	s_o(WORD_SIZE-1) <= a_i(WORD_SIZE-1) xor b_i(WORD_SIZE-1);
end architecture ;