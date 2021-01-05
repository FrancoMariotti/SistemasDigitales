library IEEE;
use IEEE.std_logic_1164.all;

entity sumNb_tb is
end entity ; -- sumNb_tb

architecture sumNb_tb_arq of sumNb_tb is
	
	signal clk: std_logic:= '0';
	signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_del: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_dut: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
	
	signal ciclos: integer := 0;
	signal errores: integer := 0;
	
	-- La senal z_del_aux se define por un problema de conversión
	signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
	
	file datos: text open read_mode is "../test_mul_float_25_7.txt";

	--declaracion componente sumador N bits.
	component sumNb is
		generic( N: natural := 4);
		port(
			a_i: 	in std_logic_vector(N-1 downto 0);
			b_i: 	in std_logic_vector(N-1 downto 0);
			ci_i: 	in std_logic;
			s_o: 	out std_logic_vector(N-1 downto 0);
			co_o: 	out std_logic
		);
	end component;

	constant N_tb: natural  := 8;
	signal ci_tb: std_logic := '0';
	signal co_tb: std_logic;
	signal a_tb: std_logic_vector(N_tb-1 downto 0);
	signal b_tb: std_logic_vector(N_tb-1 downto 0);
	signal s_tb: std_logic_vector(N_tb-1 downto 0);
begin
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
			a_file <= to_unsigned(aux, N_tb); 	-- se carga el valor del operando A
			read(l, ch); 					-- se lee un caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero de la linea
			b_file <= to_unsigned(aux, N_tb); 	-- se carga el valor del operando B
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero
			z_file <= to_unsigned(aux, N_tb); 	-- se carga el valor de salida (resultado)
		end loop;
		
		file_close(datos);		-- se cierra del archivo
		wait for TCK*(DELAY+1);
		assert false report		-- se aborta la simulacion (fin del archivo)
			"Fin de la simulacion" severity failure;
	end process Test_Sequence;

	DUT: sumNb
		generic map(
			N => N_tb
		)
		port map(
			a_i		=> a_tb,
			b_i		=> b_tb,
			ci_i 	=> ci_tb,
			s_o 	=> s_tb,
			co_o 	=> co_tb
		);

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

end architecture ; -- arch