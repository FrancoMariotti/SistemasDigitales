
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

	constant SIGNIFICAND_SIZE: natural := WORD_SIZE - EXP_SIZE;

	signal significandA:		std_logic_vector(SIGNIFICAND_SIZE-1 downto 0);
	signal significandB:		std_logic_vector(SIGNIFICAND_SIZE-1 downto 0);
	signal significandResult:	std_logic_vector(SIGNIFICAND_SIZE-1 downto 0);
begin

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

	s_o(WORD_SIZE-1) <= a_i(WORD_SIZE-1) xor b_i(WORD_SIZE-1);
end architecture ;