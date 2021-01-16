library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity multNCiclos_tb is
end entity ; -- multNCiclos_tb


architecture multNCiclos_tb_arq of multNCiclos_tb is
	--declaracion de componente multiplicador.
	component multNCiclos is
		generic(
			N: natural := 4
		);
		port(
			clk_i    : in std_logic;
			load_i   : in std_logic;
			opA_i    : in std_logic_vector(N-1 downto 0);
			opB_i    : in std_logic_vector(N-1 downto 0);
			done_o   : out std_logic;
			result_o: out std_logic_vector(2*N-1 downto 0)
		);
	end component;

	-- Declaracion de la linea de retardo
	component delay_gen is
		generic(
			N: natural:= 26;
			DELAY: natural:= 0
		);
		port(
			clk: in std_logic;
			A: in std_logic_vector(N-1 downto 0);
			B: out std_logic_vector(N-1 downto 0)
		);
	end component;

	--constant SIM_TIME_NS : time := 800 ns;

	constant N_tb :	natural := 5; 
	constant TCK: time:= 20 ns; 		-- periodo de reloj
	constant DELAY: natural:= 5; 		-- retardo de procesamiento del DUT

	signal a_file: unsigned(N_tb-1 downto 0):= (others => '0');
	signal b_file: unsigned(N_tb-1 downto 0):= (others => '0');
	signal z_file: unsigned(2*N_tb-1 downto 0):= (others => '0');
	signal z_del: unsigned(2*N_tb-1 downto 0):= (others => '0');
	signal z_dut: unsigned(2*N_tb-1 downto 0):= (others => '0');
	
	signal ciclos: integer := 0;
	signal errores: integer := 0;
	
	-- La senal z_del_aux se define por un problema de conversión
	signal z_del_aux: std_logic_vector(2*N_tb-1 downto 0):= (others => '0');
	
	file datos: text open read_mode is "../../test_files/test_mult_5_bits_2.txt";

	signal clk_tb : std_logic := '0';
	signal load_tb: std_logic := '0';
	signal opA_tb : std_logic_vector(N_tb-1 downto 0);
	signal opB_tb : std_logic_vector(N_tb-1 downto 0);
	--signal opA_tb : std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(3,N_tb));
	--signal result_tb: std_logic_vector(2*N_tb-1 downto 0);
	signal done_tb : std_logic;

begin

	clk_tb  <= not (clk_tb) after TCK/ 2;
 	
 	--load_tb <= '1' after 100 ns, '0' after 120 ns,'1' after 460 ns, '0' after 480 ns;
	--opB_tb  <= std_logic_vector(to_unsigned(6,N_tb)) after 100 ns,std_logic_vector(to_unsigned(3,N_tb)) after 460 ns;

	--load_tb <= '1' after 2 ns,'0' after 20 ns,'1' after TCK*N_tb + 40 ns;
	
	Test_Sequence: process
		variable l: line;
		variable ch: character:= ' ';
		variable aux: integer;
	begin
		while not(endfile(datos)) loop 		-- si se quiere leer de stdin se pone "input"
			ciclos <= ciclos + 1;			-- solo para debugging
			readline(datos, l); 			-- se lee una linea del archivo de valores de prueba
			read(l, aux); 					-- se extrae un entero de la linea
			a_file <= to_unsigned(aux, N_tb); 	-- se carga el valor del operando A
			read(l, ch); 					-- se lee un caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero de la linea
			b_file <= to_unsigned(aux, N_tb); 	-- se carga el valor del operando B
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero
			z_file <= to_unsigned(aux, 2*N_tb); 	-- se carga el valor de salida (resultado)
			load_tb <= '1','0' after 20 ns;
			wait for TCK * (N_tb+1);
		end loop;
		
		file_close(datos);		-- se cierra del archivo
		wait for TCK*(DELAY+1);
		assert false report		-- se aborta la simulacion (fin del archivo)
			"Fin de la simulacion" severity failure;
	end process Test_Sequence;

	opA_tb <= std_logic_vector(a_file); 
	opB_tb <= std_logic_vector(b_file);

	
	-- Instanciacion del DUT
	DUT: multNCiclos
		generic map(
			N => N_tb
		)
		port map(
			clk_i 		=> clk_tb,
			load_i		=> load_tb,
			--opA_i 		=> opA_tb,
			--opB_i 		=> opB_tb,
			opA_i 		=> opA_tb,
			opB_i 		=> opB_tb,
			done_o		=> done_tb,
			--result_o	=> result_tb
			unsigned(result_o)	=> z_dut
		);
	
	-- Instanciacion de la linea de retardo
	del: delay_gen
			generic map(2*N_tb, DELAY)
			port map(clk_tb, std_logic_vector(z_file), z_del_aux);
				
	z_del <= unsigned(z_del_aux);

	-- Verificacion de la condicion
	verificacion: process(clk_tb,done_tb)
	begin
		if rising_edge(clk_tb) and done_tb = '1' then
--			report integer'image(to_integer(a_file)) & " " & integer'image(to_integer(b_file)) & " " & integer'image(to_integer(z_file));
			assert to_integer(z_del) = to_integer(z_dut) report
				"Error: Salida del DUT no coincide con referencia (salida del dut = " & 
				integer'image(to_integer(z_dut)) &
				", salida del archivo = " &
				integer'image(to_integer(z_del)) & ")"
				severity warning;
			if to_integer(z_del) /= to_integer(z_dut) then
				errores <= errores + 1;
			end if;
		end if;
	end process;
	--frenar_simulacion: process
	--	begin
	--		wait for SIM_TIME_NS;
	--		assert false
	--		report "Simulacion terminada."
	--		severity note;
	--	end process;
end architecture;
