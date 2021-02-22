library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity multPF_tb is
end;

architecture multPF_tb_arq of multPF_tb is
	constant SIM_TIME_NS: time := 800 ns;
	constant TCK: time := 50 ns; 		-- periodo de reloj
	constant DELAY: natural:= 0; 		-- retardo de procesamiento del DUT
	constant WORD_SIZE_T:	natural	:=	25;
	constant EXP_SIZE_T:	natural	:=	7;
	--constant WORD_SIZE_T:	natural	:=	23;
	--constant EXP_SIZE_T:	natural	:=	6;

	signal	clk_tb:		std_logic := '0';
	signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_del: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_dut: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	
	signal ciclos: integer := 0;
	signal errores: integer := 0;

	--La senal z_del_aux se define por un problema de conversión
	signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
	
	file datos: text open read_mode is "../../test_files/test_mul_float_25_7.txt";


	--declaracion de componente multiplicador de punto flotante.
	component mult_PF is
		generic(
			WORD_SIZE:	natural := 23;
			EXP_SIZE:	natural := 6
		);
		port(
			a_i  :		in std_logic_vector(WORD_SIZE-1 downto 0);
			b_i  :		in std_logic_vector(WORD_SIZE-1 downto 0);
			s_o  :		out std_logic_vector(WORD_SIZE-1 downto 0)
		);
	end component;

	--Declaracion de la linea de retardo
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

	--signal	a_tb:		std_logic_vector(WORD_SIZE_T-1 downto 0);
	--signal	b_tb:		std_logic_vector(WORD_SIZE_T-1 downto 0);
	--signal	s_tb:		std_logic_vector(WORD_SIZE_T-1 downto 0);
	
begin
	
	clk_tb		<= not(clk_tb) after TCK/ 2;
	--a_tb		<= std_logic_vector(to_unsigned(33423359,WORD_SIZE_T)); 
	--b_tb		<= std_logic_vector(to_unsigned(16646144,WORD_SIZE_T));

	--a_tb		<= std_logic_vector(to_unsigned(16646144,WORD_SIZE_T)); 
	--b_tb		<= std_logic_vector(to_unsigned(16646144,WORD_SIZE_T));

	--a_tb		<= std_logic_vector(to_unsigned(33391685,WORD_SIZE_T)); 
	--b_tb		<= std_logic_vector(to_unsigned(25053421,WORD_SIZE_T));

	--a_tb		<= std_logic_vector(to_unsigned(20762451,WORD_SIZE_T)); 
	--b_tb		<= std_logic_vector(to_unsigned(20796580,WORD_SIZE_T));


	--a_tb		<= std_logic_vector(to_unsigned(0,WORD_SIZE_T)); 
	--b_tb		<= std_logic_vector(to_unsigned(0,WORD_SIZE_T));


	Test_Sequence: process
		variable l: line;
		variable ch: character:= ' ';
		variable aux: integer;
	begin
		while not(endfile(datos)) loop 		-- si se quiere leer de stdin se pone "input"
			wait until rising_edge(clk_tb);
			ciclos <= ciclos + 1;			-- solo para debugging
			readline(datos, l); 			-- se lee una linea del archivo de valores de prueba
			read(l, aux); 					-- se extrae un entero de la linea
			a_file <= to_unsigned(aux, WORD_SIZE_T); 	-- se carga el valor del operando A
			read(l, ch); 					-- se lee un caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero de la linea
			b_file <= to_unsigned(aux, WORD_SIZE_T); 	-- se carga el valor del operando B
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero
			z_file <= to_unsigned(aux, WORD_SIZE_T); 	-- se carga el valor de salida (resultado)
		end loop;
		
		file_close(datos);		-- se cierra del archivo
		wait for TCK*(DELAY+1);
		assert false report		-- se aborta la simulacion (fin del archivo)
			"Fin de la simulacion" severity failure;
	end process Test_Sequence;

	--Instanciacion multiplicador de punto flotante.
	DUT: mult_PF
		generic map(
			WORD_SIZE	=> WORD_SIZE_T,
			EXP_SIZE	=> EXP_SIZE_T
		)
		port map(
			--a_i		=> std_logic_vector(a_tb),
			--b_i		=> std_logic_vector(b_tb),
			--s_o 	=> s_tb
			a_i		=> std_logic_vector(a_file),
			b_i		=> std_logic_vector(b_file),
			unsigned(s_o) 	=> z_dut
		);


	 --Instanciacion de la linea de retardo
	del: delay_gen
			generic map(WORD_SIZE_T, DELAY)
			port map(clk_tb, std_logic_vector(z_file), z_del_aux);
				
	z_del <= unsigned(z_del_aux);
	
	--Verificacion de la condicion
	verificacion: process(clk_tb)
	begin
		if rising_edge(clk_tb) then
			--report integer'image(to_integer(a_file)) & " " & integer'image(to_integer(b_file)) & " " & integer'image(to_integer(z_file));
			assert to_integer(z_del) = to_integer(z_dut) report
				"Error: Salida del DUT no coincide con referencia (salida del dut = " & 
				integer'image(to_integer(z_dut)) &
				", salida del archivo = " &
				integer'image(to_integer(z_del)) & ")" &
				" " & integer'image(to_integer(a_file)) 
				& " " & integer'image(to_integer(b_file)) 
				& " " & integer'image(to_integer(z_file))
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
end architecture;
