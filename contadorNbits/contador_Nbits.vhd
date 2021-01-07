library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--Contador de N bits generico
entity contador_Nbits is
	generic(
		N: natural := 4
	);
	port(
		clk_i:	in std_logic;
		rst_i:	in std_logic;
		ena_i:	in std_logic;
		q_o  :	out std_logic_vector(N-1 downto 0)
	);
end;

architecture contador_Nbits_arq of contador_Nbits is
	component registro_simple is
		generic(
			N: natural := 4;
			MAX_CUENTA: natural := 16
		);
		port(
			clk_i	: in std_logic;
			d_i	: in std_logic_vector(N-1 downto 0);
			q_o	: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component sumNb is
		generic(
			N: natural := 4
		);
		port(
			a_i	: in std_logic_vector(N-1 downto 0);
			b_i	: in std_logic_vector(N-1 downto 0);
			ci_i	: in std_logic;
			s_o	: out std_logic_vector(N-1 downto 0);
			co_o	: out std_logic
		);
	end component;
	
	signal salReg     : std_logic_vector(N-1 downto 0);
	signal salSum     : std_logic_vector(N-1 downto 0);
	signal salMuxEna  : std_logic_vector(N-1 downto 0);
	signal salMuxRst  : std_logic_vector(N-1 downto 0);
	signal comparador : std_logic;
	signal co_o       : std_logic;
	constant uno      : std_logic_vector(N-1 downto 0) := (N-2 downto 0 => '0') & '1';
begin

	registro_simple_ints: registro_simple
		generic map(
			N => N
		)
		port map(	
			clk_i	=> clk_i,
			d_i	=> salMuxRst,
			q_o	=> salReg
		);
	sumNb_inst: sumNb
		generic map(
			N => N
		)
		port map(	
			a_i	=> uno,
			b_i	=> salReg,
			ci_i	=> '0',
			s_o	=> salSum,
			co_o	=> co_o
		);
	
	--Multiplexor controlador por habilitador
	salMuxEna <=	salSum when ena_i = '1' else
			salReg;
	comparador <= '1' when (unsigned(co_o & salMuxEna)) = MAX_CUENTA else '0';
	--Multiplexor controlador por reset
	salMuxRst <=	(N-1 downto 0 => '0') when (rst_i = '1' or comparador = '1') else 				salMuxEna;			
			
	q_0 <= salReg;
end;
