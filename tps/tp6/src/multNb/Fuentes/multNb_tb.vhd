library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;


entity multNb_tb is
end;

architecture multNb_tb_arq of multNb_tb is

	constant TCK: time:= 20 ns; 		-- periodo de reloj
	constant DELAY: natural:= 0; 		-- retardo de procesamiento del DUT
	constant WORD_SIZE_T: natural:= 5;	-- tamaño de datos
	
	signal clk: std_logic:= '0';
	signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_file: unsigned(2*WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_del: unsigned(2*WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_dut: unsigned(2*WORD_SIZE_T-1 downto 0):= (others => '0');
	
	signal ciclos: integer := 0;
	signal errores: integer := 0;
	
	-- La senal z_del_aux se define por un problema de conversión
	signal z_del_aux: std_logic_vector(2*WORD_SIZE_T-1 downto 0):= (others => '0');
	
	file datos: text open read_mode is "../test_files/test_mult_5bit.txt";
	
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

	constant SIM_TIME_NS : time := 400 ns;

	--constant N_tb : natural := 5; 
	--signal opA_tb : std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(3,N_tb));
	--signal opB_tb : std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(2,N_tb));
	--signal result_tb: std_logic_vector(2*N_tb-1 downto 0);
begin
	--opB_tb  <= std_logic_vector(to_unsigned(6,N_tb)) after 100 ns,std_logic_vector(to_unsigned(3,N_tb)) after 300 ns;
	-- Generacion del clock del sistema
	clk <= not(clk) after TCK/ 2; -- reloj

	Test_Sequence: process
		variable l: line;
		variable ch: character:= ' ';
		variable aux: integer;
	begin
		while not(endfile(datos)) loop 		-- si se quiere leer de stdin se pone "input"
			wait until rising_edge(clk);
			ciclos <= ciclos + 1;			-- solo para debugging
			readline(datos, l); 			-- se lee una linea del archivo de valores de prueba
			read(l, aux); 					-- se extrae un entero de la linea
			a_file <= to_unsigned(aux, WORD_SIZE_T); 	-- se carga el valor del operando A
			read(l, ch); 					-- se lee un caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero de la linea
			b_file <= to_unsigned(aux, WORD_SIZE_T); 	-- se carga el valor del operando B
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero
			z_file <= to_unsigned(aux, 2*WORD_SIZE_T); 	-- se carga el valor de salida (resultado)
		end loop;
		
		file_close(datos);		-- se cierra del archivo
		wait for TCK*(DELAY+1);
		assert false report		-- se aborta la simulacion (fin del archivo)
			"Fin de la simulacion" severity failure;
	end process Test_Sequence;


	DUT: multNb
		generic map(
			N => WORD_SIZE_T
		)
		port map (
			multiplicand		=> std_logic_vector(a_file),
			multiplier			=> std_logic_vector(b_file),
			unsigned(result)	=> z_dut
		);


	-- Instanciacion de la linea de retardo
	del: delay_gen
			generic map(2*WORD_SIZE_T, DELAY)
			port map(clk, std_logic_vector(z_file), z_del_aux);
				
	z_del <= unsigned(z_del_aux);
	
	-- Verificacion de la condicion
	verificacion: process(clk)
	begin
		if rising_edge(clk) then
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

	--stop_simulation : process
	--	begin
	--		wait for SIM_TIME_NS; --run the simulation for this duration
	--		assert false
	--		report "Simulation finished."
	--		severity failure;
	--	end process;
end multNb_tb_arq;
