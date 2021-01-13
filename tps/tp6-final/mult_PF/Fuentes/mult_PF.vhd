library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--mutiplicador de punto flotante.
entity mult_PF is
	generic(
		WORD_SIZE:	natural := 23;
		EXP_SIZE:	natural := 6
	);
	port(
		a_i:	in std_logic_vector(WORD_SIZE-1 downto 0);
		b_i:	in std_logic_vector(WORD_SIZE-1 downto 0);
		s_o:	out std_logic_vector(WORD_SIZE-1 downto 0)
	);
end entity;

architecture behavioral of mult_PF is

	constant N_SIGNIF:	natural := WORD_SIZE - EXP_SIZE;	--tamanio de los significAND
	constant N_MANT:	natural := N_SIGNIF-1;	--tamanio de la mantisa
	constant N_PROD:	natural := 2*N_SIGNIF;	--tamanio del producto de significANDs

	constant BIAS:	std_logic_vector(EXP_SIZE-1 downto 0)  := '0' & (EXP_SIZE-2 downto 0 => '1');	--bias
	constant MINUS_BIAS:	std_logic_vector(EXP_SIZE-1 downto 0)  := std_logic_vector(signed(not bias) + 1);	--complemento bias

	constant ZERO_EXP:	std_logic_vector(EXP_SIZE-1 downto 0)  := (others => '0'); 
	constant ONE_EXP:	std_logic_vector(EXP_SIZE-1 downto 0)  := (EXP_SIZE-1 downto 1 => '0') & '1'; 
	constant MAX_EXP:	std_logic_vector(EXP_SIZE-1 downto 0)  := (EXP_SIZE-1 downto 1 => '1') & '0'; 

	constant ZERO_MANT:	std_logic_vector(N_MANT-1 downto 0)  := (others => '0'); 
	constant MAX_MANT:	std_logic_vector(N_MANT-1 downto 0)  := (N_MANT-1 downto 0 => '1'); 

	--declaracion sumador generico de N bits.
	component sumNb is
		generic( 
			N: natural := 4
		);
		port(
			a_i:	in std_logic_vector(N-1 downto 0);
			b_i:	in std_logic_vector(N-1 downto 0);
			ci_i:	in std_logic;
			s_o:	out std_logic_vector(N-1 downto 0);
			co_o:	out std_logic
		);
	end component;

	--declaracion multiplicador.
	component multNb is
		generic(
			N: natural := 4
		);
		port(
			multiplicand:	in std_logic_vector(N-1 downto 0);
			multiplier:		in std_logic_vector(N-1 downto 0);
			result:			out std_logic_vector(2*N-1 downto 0)
		);
	end component;
	
	signal negToNeg:	std_logic;							    
	signal posToNeg:	std_logic;							    
	signal negToPos:	std_logic;							    

	signal resMultMsb:	std_logic;	--bit mas significativo de la salida del multiplicador
	signal underflow:	std_logic;	--bit de underflow
	signal overflow:	std_logic;	--bit de overflow

	signal expA:	std_logic_vector(EXP_SIZE-1 downto 0);	--exponente operador A
	signal expB:	std_logic_vector(EXP_SIZE-1 downto 0);	--exponente operador B
	signal salSumExp:	std_logic_vector(EXP_SIZE-1 downto 0);	--salida sumador de exponentes

	signal salSumBias:	std_logic_vector(EXP_SIZE-1 downto 0);	--salida sumador de bias

	signal entSumInc:	std_logic_vector(EXP_SIZE-1 downto 0);	--entrada incrementador exponente
	signal salSumInc:	std_logic_vector(EXP_SIZE-1 downto 0);	--salida incrementador exponente

	signal significandA:	std_logic_vector(N_SIGNIF-1 downto 0);	--significAND operador A
	signal significandB:	std_logic_vector(N_SIGNIF-1 downto 0);	--significAND operador B
	signal salMult:	std_logic_vector(N_PROD-1 downto 0);		--salida multiplicador de significANDs
	
	signal salRestBiasA:	std_logic_vector(EXP_SIZE-1 downto 0);	--salida restador de bias del operador A
	signal salRestBiasB:	std_logic_vector(EXP_SIZE-1 downto 0);	--salida restador de bias del operador B

	signal salMuxMult:	std_logic_vector(N_MANT-1 downto 0);	--salida del multiplexor que conecta la salida del multiplicador.
	signal salMuxMantisa:	std_logic_vector(N_MANT-1 downto 0);	--salida del multiplexor que conecta la mantisa a la salida.

	signal salMuxExp:	std_logic_vector(EXP_SIZE-1 downto 0);


	function is_all(vector: std_logic_vector; value: std_logic) return std_logic is
		constant aux: std_logic_vector(vector'range) := (others => value);
	begin
		if vector = aux  then 
		return '1';
		end if;

		return '0';  
	end function;

	begin
	expA <= a_i(WORD_SIZE-2 downto N_MANT);
	expB <= b_i(WORD_SIZE-2 downto N_MANT);

	significandA <= '1' & a_i(N_MANT-1 downto 0);
	significandB <= '1' & b_i(N_MANT-1 downto 0);

	-- instancia sumador de BIAS complementado
	restador_biasA: sumNb
		generic map(
			N => EXP_SIZE
		)
		port map(
			a_i	=> MINUS_BIAS,
			b_i	=> expA,
			ci_i	=> '0',
			s_o	=> salRestBiasA,
			co_o	=> open
		);

	-- instancia sumador de BIAS complementado
	restador_biasB: sumNb
		generic map(
			N => EXP_SIZE
		)
		port map(
			a_i	=> MINUS_BIAS,
			b_i	=> expB,
			ci_i	=> '0',
			s_o	=> salRestBiasB,
			co_o	=> open
		);

	-- instancia sumador de exponentes
	sumador_exp: sumNb
		generic map(
			N => EXP_SIZE
		)
		port map(
			a_i	=> salRestBiasA,
			b_i	=> salRestBiasB,
			ci_i	=> '0',
			s_o	=> salSumExp,
			co_o	=> open
		);

	--instancia sumador incrementador
	sumador_inc: sumNb
		generic map(
			N => EXP_SIZE
		)
		port map(
			a_i	=> salSumExp,
			b_i	=> entSumInc,
			ci_i	=> '0',
			s_o	=> salSumInc,
			co_o	=> open
		);

	-- instancia sumador de BIAS	
	sumador_bias: sumNb
		generic map(
			N => EXP_SIZE
		)
		port map(
			a_i	=> salSumInc,
			b_i	=> bias,
			ci_i	=> '0',
			s_o	=> salSumBias,
			co_o	=> open
		);

	--bit mas significativo del producto significandA * significandB.
	resMultMsb <= salMult(N_PROD-1);

	entSumInc <= ONE_EXP when resMultMsb = '1' else ZERO_EXP;
	
	-- instancia multiplicador para enteros sin signo.
	mult_inst: multNb
		generic map(
			N => N_SIGNIF
		)
		port map(
			multiplicand	=> significandA,
			multiplier	=> significandB,
			result	=> salMult
		);

	negToPos <= salRestBiasA(EXP_SIZE-1) AND salRestBiasB(EXP_SIZE-1) AND NOT(salSumExp(EXP_SIZE-1)); 
	posToNeg <= NOT(salRestBiasA(EXP_SIZE-1)) AND NOT(salRestBiasB(EXP_SIZE-1)) AND salSumExp(EXP_SIZE-1);
	negToNeg <= salRestBiasA(EXP_SIZE-1) AND salRestBiasB(EXP_SIZE-1) AND salSumExp(EXP_SIZE-1); 
	
	--logica underflow.
	underflow <= negToPos OR (negToNeg AND salSumExp(EXP_SIZE-1) AND is_all(salSumExp(EXP_SIZE-2 downto 1),'0') 
				 AND (NOT(salSumExp(0)) OR (salSumExp(0) AND NOT(resMultMsb))));

	--logica overflow.
	overflow <= posToNeg OR (resMultMsb AND NOT(salSumExp(EXP_SIZE-1)) AND is_all(salSumExp(EXP_SIZE-2 downto 0),'1'));


	salMuxExp <= ZERO_EXP when (overflow = '0' AND underflow ='1') else
				 MAX_EXP  when (overflow = '1' AND underflow ='0') else
				 salSumBias;

	salMuxMult <= salMult(N_PROD-2 downto N_SIGNIF) when resMultMsb = '1' else 
				  salMult(N_PROD-3 downto N_SIGNIF-1);

	salMuxMantisa <= ZERO_MANT when (overflow = '0' AND underflow ='1') else
					 MAX_MANT  when (overflow = '1' AND underflow ='0') else
					 salMuxMult;

	--mantisa del resultado.
	s_o(N_MANT-1 downto 0) <= salMuxMantisa;

	----exponente del resultado.
	s_o(WORD_SIZE-2 downto N_MANT) <= salMuxExp;

	-- signo del resultado.
	s_o(WORD_SIZE-1) <= a_i(WORD_SIZE-1) xor b_i(WORD_SIZE-1);

	end architecture;