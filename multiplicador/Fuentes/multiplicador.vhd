library IEEE;
use IEEE.std_logic_1164.all;


entity multiplicador is
	generic(
		N: natural := 4
	);
	port(
		clk_i    : in std_logic;
		load_i   : in std_logic;
		--rst_i   : in std_logic;
		opA_i    : in std_logic_vector(N-1 downto 0);
		opB_i    : in std_logic_vector(N-1 downto 0);
		product_o: out std_logic_vector(2*N-1 downto 0)
	);
end;

architecture multiplicador_arq of multiplicador is
	--declaracion del mponente registro
	component regNb is
		generic(
			N: natural := 4
		);
		port(
			D_i:	in	std_logic_vector(N-1 downto 0);
			rst_i:	in	std_logic;
			ena_i:	in 	std_logic;
			clk_i:	in	std_logic;
			Q_o:	out	std_logic_vector(N-1 downto 0)
		);
	end component;
	
	--declaracion del componente sumador
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
	signal entP,entB,salP,salSum,salB,salA,aux: std_logic_vector(N-1 downto 0);
	signal co: std_logic;
	signal enaRegP,enaRegB: std_logic;
begin
	process(clk_i,load_i) is
		variable counter: natural;
	begin
		if load_i = '1' then
			enaRegP <= '1';	
			enaRegB <= '1';
			counter := 0;
		elsif rising_edge(clk_i) then
			if counter = N-1  then
				enaRegP <= '0';
				enaRegB <= '0';
			else
				counter := counter + 1;
			end if;
		end if;
	end process;
	
	--instancia registro A
	regA_inst: regNb
		generic map(
			N => N		
		)
		port map(
			D_i   => opA_i,
			ena_i => '1',
			rst_i => '0',
			clk_i => clk_i,
			Q_o   => salA	
		);
		
	--instancia registro B
	regB_inst: regNb
		generic map(
			N => N
		)
		port map(
			D_i   => entB,
			ena_i => enaRegB,
			rst_i => '0',
			clk_i => clk_i,
			Q_o   => salB
		);
	--instancia registro P
	regP_inst: regNb
		generic map(
			N => N		
		)
		port map(
			D_i   => entP,
			ena_i => enaRegP,
			rst_i => load_i,
			clk_i => clk_i,
			Q_o   => salP
		);
		
	sum_inst: sumNb
		generic map(
			N => N		
		)
		port map(
			a_i  => salP,
			b_i  => aux,
			ci_i => '0',
			s_o  => salSum,
			co_o => co
		);
	entP <= co & salSum(N-1 downto 1);
	aux  <= salA  when salB(0) = '1' else (N-1 downto 0 => '0');
	entB <= opB_i when load_i = '1' else salSum(0) & salB(N-1 downto 1);
	product_o <= salP & salB; 
end multiplicador_arq;
