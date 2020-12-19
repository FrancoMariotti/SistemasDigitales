library IEEE;
use IEEE.std_logic_1164.all;

--Es un componente sin entradas ni salidas(osea es un banco de pruebas)
entity logic_gates_tb is
end;

architecture logic_gates_tb_arq of logic_gates_tb is
	component logic_gates is
		port(
			a_i: in std_logic;
			b_i: in std_logic;
			and_o: out std_logic;
			or_o: out std_logic;
			xor_o: out std_logic
		);
	end component;


	signal a_tb: std_logic := '0';
	signal b_tb: std_logic := '0';
	signal and_tb: std_logic;
	signal or_tb: std_logic;
	signal xor_tb: std_logic;
begin

	a_tb <= not a_tb after 100 ns, not a_tb after 300 ns;
	b_tb <= not b_tb after 200 ns;

	DUT: logic_gates
		port map(
			a_i => a_tb,
			b_i => b_tb,
			and_o => and_tb,
			or_o => or_tb,
			xor_o => xor_tb
		);
end logic_gates_tb_arq;
