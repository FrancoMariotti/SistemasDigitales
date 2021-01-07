library IEEE;
use IEEE.std_logic_1164.all;


--Contador de N bits generico
entity contador_Nbits_lento is
	generic(
		N: natural := 4;
		M: natural := 4
	);
	port(
		clk_i:	in std_logic;
		rst_i:	in std_logic;
		ena_i:	in std_logic;
		q_o  :	out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture contador_Nbits_arq of contador_Nbits_lento is
	component contador_Nbits is
		generic(
			N: natural := 4
		);
		port(
			clk_i:	in std_logic;
			rst_i:	in std_logic;
			ena_i:	in std_logic;
			q_o  :	out std_logic_vector(N-1 downto 0)
		);
	end component;

	component genEna is
		generic(
			N: natural := 5
		);
	 	port (
	 		clk_i: in std_logic;
	 		rst_i: in std_logic;
	 		ena_i: in std_logic;
	 		q_o: out std_logic
	 	);
	end component ; -- genEna 

	signal salGenEna: std_logic;
	signal salGenEna_aux: std_logic;

begin
	
	cont_inst: contador_Nbits
		generic map(
			N => N
		)
		port map(
			clk_i	=> clk_i,
			rst_i	=> rst_i,
			ena_i	=> salGenEna_aux,
			q_o  	=> q_o
		);

	gen_inst: genEna
		generic map(
			N => M
		)
		port map(
			clk_i 	=> clk_i,
			rst_i	=> rst_i,
			ena_i	=> '1',
			q_o 	=> salGenEna
		);
	
	salGenEna_aux <= salGenEna and ena_i;
end architecture;
