library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multPF_tb is
end;

architecture behavioral of multPF_tb is
	component mult_PF is
		generic(
			WORD_SIZE:	natural := 23;
			EXP_SIZE:	natural := 6
		);
		port(
			clk_i:		in std_logic;
			start_i:	in std_logic;
			a_i  :		in std_logic_vector(WORD_SIZE-1 downto 0);
			b_i  :		in std_logic_vector(WORD_SIZE-1 downto 0);
			s_o  :		out std_logic_vector(WORD_SIZE-1 downto 0)
		);
	end component;


	constant SIM_TIME_NS: time := 300 ns;
	constant TCK: time := 20 ns; 		-- periodo de reloj
	constant WORD_SIZE_T:	natural	:=	23;
	constant EXP_SIZE_T:	natural	:=	6;

	signal	clk_tb:		std_logic;
	signal	start_tb:	std_logic	:= '0';
	signal	a_tb:		std_logic_vector(WORD_SIZE_T-1 downto 0);
	signal	b_tb:		std_logic_vector(WORD_SIZE_T-1 downto 0);
	signal	s_tb:		std_logic_vector(WORD_SIZE_T-1 downto 0);
	
begin
	
	clk_tb		<= not(clk_tb) after TCK/ 2;
	a_tb		<= std_logic_vector(to_unsigned(8323071,WORD_SIZE_T));
	b_tb		<= std_logic_vector(to_unsigned(2007961,WORD_SIZE_T));
	start_tb	<= '1' after 10 ns;

	DUT: mult_PF
		generic map(
			WORD_SIZE	=> WORD_SIZE_T,
			EXP_SIZE	=> EXP_SIZE_T
		)
		port map(
			clk_i	=> clk_tb,
			start_i => start_tb,
			a_i		=> a_tb,
			b_i		=> b_tb,
			s_o 	=> s_tb
		);

	stop_simulation : process
		begin
			wait for SIM_TIME_NS; --run the simulation for this duration
			assert false
			report "Simulation finished."
			severity failure;
		end process;
end architecture;