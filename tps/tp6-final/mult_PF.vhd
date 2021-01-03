library IEEE;
use IEEE.std_logic_1164.all;

--mutiplicador de punto flotante.
entity mult_PF is
	generic(
		WORD_SIZE: natural := 23,
		EXP_SIZE: natural := 6
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

	constant Nsignif:	natural := WORD_SIZE - EXP_SIZE;	--tamanio de los significand
	constant Nmant:		natural := Nsignif-1;				--tamanio de la mantisa
	constant Nprod:		natural := 2*Nsignif;				--tamanio del producto de significands

	constant BIAS:	natural;

	signal x0:					std_logic;
	--signal expResult:			std_logic_vector(EXP_SIZE-1 downto 0);	

	signal significandA:		std_logic_vector(Nsignif-1 downto 0);
	signal significandB:		std_logic_vector(Nsignif-1 downto 0);
	signal salMult:				std_logic_vector(Nprod downto 0);
begin
	significandA <= '1' & a_i(Nmant-1 downto 0);
	significandB <= '1' & b_i(Nmant-1 downto 0);
	
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
			product_o	=> salMult
		);

	--bit mas significativo del resultado de significandA * significandB.
	x0 <= salMult(Nprod-1);

	s_o(Nmant-1 downto 0) <= salMult(Nprod-2 downto Nsignif) when x0 = '1'
								else salMult(Nprod-3 downto Nsignif -1);
														
	-- signo del resultado.
	s_o(WORD_SIZE-1) <= a_i(WORD_SIZE-1) xor b_i(WORD_SIZE-1);
end architecture;