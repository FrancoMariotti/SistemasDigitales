library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity multNb_tb is
end;

architecture multNb_tb_arq of multNb_tb is
	component multNb is
		generic(
			N: natural := 4
		);
		port(
			multiplicand: in std_logic_vector(N-1 downto 0);
			multiplier:	in std_logic_vector(N-1 downto 0);
			result:	out std_logic_vector(2*N-1 downto 0)
		);
	end component;

	constant SIM_TIME_NS : time := 400 ns;
	signal clk_tb : std_logic := '0';

	constant N_tb : natural := 5; 
	signal opA_tb : std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(3,N_tb));
	signal opB_tb : std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(2,N_tb));
	signal result_tb: std_logic_vector(2*N_tb-1 downto 0);
begin
	clk_tb  <= not clk_tb after 10 ns;
	opB_tb  <= std_logic_vector(to_unsigned(6,N_tb)) after 100 ns,std_logic_vector(to_unsigned(3,N_tb)) after 300 ns;
	
	DUT: multNb
		generic map(
			N => N_tb
		)
		port map (
			multiplicand	=> opA_tb,
			multiplier		=> opB_tb,
			result			=> result_tb
		);


	stop_simulation : process
		begin
			wait for SIM_TIME_NS; --run the simulation for this duration
			assert false
			report "Simulation finished."
			severity failure;
		end process;
end multNb_tb_arq;
