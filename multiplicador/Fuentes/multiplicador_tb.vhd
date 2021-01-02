library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity multiplicador_tb is
end;

architecture multiplicador_tb_arq of multiplicador_tb is
	component multiplicador is
		generic(
			N: natural := 4
		);
		port(
			clk_i    : in std_logic;
			load_i   : in std_logic;
			--rst_i    : in std_logic;
			opA_i    : in std_logic_vector(N-1 downto 0);
			opB_i    : in std_logic_vector(N-1 downto 0);
			product_o: out std_logic_vector(2*N-1 downto 0)
		);
	end component;
	
	constant N_tb : natural := 5; 
	signal clk_tb : std_logic := '0';
	signal load_tb: std_logic := '0';
	signal rst_tb : std_logic := '1';
	signal opA_tb : std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(3,N_tb));
	signal opB_tb : std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(0,N_tb));
	signal product_tb: std_logic_vector(2*N_tb-1 downto 0);
begin
	clk_tb  <= not clk_tb after 10 ns;
	rst_tb  <= '0' after 20 ns;
 	
 	load_tb <= '1' after 100 ns, '0' after 120 ns,'1' after 460 ns, '0' after 480 ns;
	opB_tb  <= std_logic_vector(to_unsigned(6,N_tb)) after 100 ns,std_logic_vector(to_unsigned(2,N_tb)) after 460 ns;
	
	DUT: multiplicador
		generic map(
			N => N_tb
		)
		port map(
			clk_i     => clk_tb,
			load_i    => load_tb,
			--rst_i     => rst_tb,
			opA_i     => opA_tb,
			opB_i     => opB_tb,
			product_o => product_tb
		);
end multiplicador_tb_arq;
