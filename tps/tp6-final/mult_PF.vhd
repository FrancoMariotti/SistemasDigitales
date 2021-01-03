library IEEE;
use IEEE.std_logic_1164.all;

--mutiplicador de punto flotante.
entity mult_PF is
	generic(
		WORD_SIZE:	natural := 23,
		EXP_SIZE:	natural := 6
	);
	port(
		clk_i:		in std_logic;
		start_i:	in std_logic;
		a_i  :		in std_logic_vector(WORD_SIZE-1 downto 0);
		b_i  :		in std_logic_vector(WORD_SIZE-1 downto 0);
		s_o  :		out std_logic_vector(WORD_SIZE-1 downto 0)
	);
end entity;

architecture behavioral of mult_PF is

	--declaracion sumador generico de N bits.
	component sumNb is
		generic( 
			N: natural := 4
		);
		port(
			a_i: 	in std_logic_vector(N-1 downto 0);
			b_i: 	in std_logic_vector(N-1 downto 0);
			ci_i: 	in std_logic;
			s_o: 	out std_logic_vector(N-1 downto 0);
			co_o: 	out std_logic
		);
	end component;

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
			done_o   : out std_logic;
			product_o: out std_logic_vector(2*N-1 downto 0)
		);
	end component;

	constant Nsignif:			natural := WORD_SIZE - EXP_SIZE;	--tamanio de los significand
	constant Nmant:				natural := Nsignif-1;				--tamanio de la mantisa
	constant Nprod:				natural := 2*Nsignif;				--tamanio del producto de significands

	signal pN:					std_logic;
	signal bias:				std_logic_vector(EXP_SIZE-1 downto 0) := std_logic_vector(to_signed(-(2**(EXP_SIZE)-1),EXP_SIZE));

	signal expA:				std_logic_vector(EXP_SIZE-1 downto 0);
	signal expB:				std_logic_vector(EXP_SIZE-1 downto 0);
	signal salSumExp:			std_logic_vector(EXP_SIZE-1 downto 0);
	signal coSumExp:			std_logic;


	signal salSumBias:			std_logic_vector(EXP_SIZE-1 downto 0);

	signal entSumInc:			std_logic_vector(EXP_SIZE-1 downto 0);
	signal salSumInc:			std_logic_vector(EXP_SIZE-1 downto 0);

	signal significandA:		std_logic_vector(Nsignif-1 downto 0);
	signal significandB:		std_logic_vector(Nsignif-1 downto 0);
	signal salMult:				std_logic_vector(Nprod downto 0);
begin
	expA <= a_i(WORD_SIZE-2 downto Nmant);
	expB <= b_i(WORD_SIZE-2 downto Nmant);

	significandA <= '1' & a_i(Nmant-1 downto 0);
	significandB <= '1' & b_i(Nmant-1 downto 0);

	-- instancia sumador de exponentes
	sumador_exp: sumNb
		generic map(
			N => EXP_SIZE
		)
		port map(
			a_i		=> expA,
			b_i		=> expB,
			ci_i	=> '0',
			s_o		=> salSumExp,
			co_o	=> coSumExp
		);


	-- instancia sumador de bias
	sumador_bias: sumNb
		generic map(
			N => EXP_SIZE
		)
		port map(
			a_i		=> bias,
			b_i		=> salSumExp,
			ci_i	=> '0',
			s_o		=> salSumBias,
			co_o	=> open
		);

	--instancia sumador incrementador
	sumador_inc: sumNb
		generic map(
			N => EXP_SIZE
		)
		port map(
			a_i		=> salSumBias,
			b_i		=> entSumInc,
			ci_i	=> '0',
			s_o		=> salSumInc,
			co_o	=> open
		);
	
	-- instancia multiplicador para enteros sin signo.
	mult_inst: multiplicador
		generic map(
			N => Nsignif
		)
		port map(
			clk_i		=> clk_i, 
			load_i		=> not start_i,
			opA_i		=> significandA,
			opB_i		=> significandB,
			done_o		=> open,
			product_o	=> salMult
		);

	--bit mas significativo del producto significandA * significandB.
	pN <= salMult(Nprod-1);
	
	entSumInc <= std_logic_vector(to_unsigned(1,EXP_SIZE)) when pN = '1' else 
				 std_logic_vector(to_unsigned(0,EXP_SIZE));

	-- mantisa del resultado.
	s_o(Nmant-1 downto 0) <= salMult(Nprod-2 downto Nsignif) when pN = '1' else 
							 salMult(Nprod-3 downto Nsignif-1);

	s_o(WORD_SIZE-2 downto Nmant) <= salSumInc;
														
	-- signo del resultado.
	s_o(WORD_SIZE-1) <= a_i(WORD_SIZE-1) xor b_i(WORD_SIZE-1);
end architecture;