library IEEE;
use IEEE.std_logic_1164.all;

entity detector_secuencia is
	port(
		secuencia_i:	in std_logic;
		clk_i:		in std_logic;
		rst_i:		in std_logic;
		det_flag_o:	out std_logic
	);
end;

architecture behavioral of detector_secuencia is
	type estados is(A,B,C,D,E,F,G); 
	signal estado_actual,estado_siguiente: estados; 
begin
	registros: process(clk_i,rst_i) is
	begin
		if rst_i = '1' then
			estado_actual <= A;
		elsif rising_edge(clk_i) then
			estado_actual <= estado_siguiente;
		end if;
	end process;
	
	
	PROX_ESTADO: process(secuencia_i,estado_actual) is
	begin
		if estado_actual = A then
			if secuencia_i = '0' then
				estado_siguiente <= B;
				det_flag_o <= '0';
			end if;
		elsif estado_actual = B then
			if secuencia_i = '0' then
				estado_siguiente <= C;
				det_flag_o <= '0';
			else
				estado_siguiente <= A;
				det_flag_o <= '0';
			end if;
		elsif estado_actual = C then
			if secuencia_i = '1' then
				estado_siguiente <= D;
				det_flag_o <= '0';
			else
				estado_siguiente <= A;
				det_flag_o <= '0';
			end if;
		elsif estado_actual = D then
			if secuencia_i = '0' then
				estado_siguiente <= E;
				det_flag_o <= '0';
			else
				estado_siguiente <= A;
				det_flag_o <= '0';
			end if;
		elsif estado_actual = E then
			if secuencia_i = '1' then
				estado_siguiente <= F;
				det_flag_o <= '0';
			else
				estado_siguiente <= A;
				det_flag_o <= '0';
			end if;
		elsif estado_actual = F then
			if secuencia_i = '1' then
				estado_siguiente <= G;
				det_flag_o <= '0';
			else
				estado_siguiente <= A;
				det_flag_o <= '0';
			end if;	
		elsif estado_actual = G then
			if secuencia_i = '0' then
				estado_siguiente <= B;
				det_flag_o <= '1';
			else
				estado_siguiente <= A;
				det_flag_o <= '0';
			end if;
		end if;
	end process;
end behavioral;

--codificacion one hot.
architecture one_hot of detector_secuencia is
	constant CANT_ESTADOS: natural := 7;
	constant STATE0: std_logic_vector(CANT_ESTADOS-1 downto 0) := "0000001";
	constant STATE1: std_logic_vector(CANT_ESTADOS-1 downto 0) := "0000010";
	constant STATE2: std_logic_vector(CANT_ESTADOS-1 downto 0) := "0000100";
	constant STATE3: std_logic_vector(CANT_ESTADOS-1 downto 0) := "0001000";
	constant STATE4: std_logic_vector(CANT_ESTADOS-1 downto 0) := "0010000";
	constant STATE5: std_logic_vector(CANT_ESTADOS-1 downto 0) := "0100000";
	constant STATE6: std_logic_vector(CANT_ESTADOS-1 downto 0) := "1000000";
	signal estado: std_logic_vector(CANT_ESTADOS-1 downto 0); 
	signal detected: bit := '0'; 
begin
	process(clk_i,rst_i) is
	begin
		if rst_i = '1' then
			estado <= STATE0;
		elsif rising_edge(clk_i) then
			if estado = STATE0 then
				if secuencia_i = '0' then
					estado <= STATE1;
				end if;
			elsif estado = STATE1 then
				if secuencia_i = '0' then
					estado <= STATE2;
				else
					estado <= STATE0;
				end if;
			elsif estado = STATE2 then
				if secuencia_i = '1' then
					estado <= STATE3;
				else
					estado <= STATE0;
				end if;
			elsif estado = STATE3 then
				if secuencia_i = '0' then
					estado <= STATE4;
				else
					estado <= STATE0;
				end if;
			elsif estado = STATE4 then
				if secuencia_i = '1' then
					estado <= STATE5;
				else
					estado <= STATE0;
				end if;
			elsif estado = STATE5 then
				if secuencia_i = '1' then
					estado <= STATE6;
				else
					estado <= STATE0;
				end if;
			elsif estado = STATE6 then
				if secuencia_i = '0' then
					estado <= STATE1;
					detected <= '1';
				else
					estado <= STATE0;
				end if;
			end if;
		end if;
	end process;
	
	det_flag_o <= '1' when detected = '1' else '0';
end one_hot;

--implementacion con shift register y compuertas logicas.
architecture shift_register of detector_secuencia is 
	constant N: natural := 7;
	
	component regd is
		generic( N: natural := 4);
		port(
			ena_i:		in	std_logic;
			rst_i:		in 	std_logic;
			clk_i:		in	std_logic;
			D_i:		in 	std_logic;
			load_i:	in	std_logic;
			value_i:	in	std_logic_vector(N-1 downto 0);
			Q_o:		out 	std_logic_vector(N-1 downto 0)
		);
	end component;
	
	constant SECUENCIA: std_logic_vector(N-1 downto 0) := "0010110";
	signal aux: std_logic_vector(N-1 downto 0);
begin
	regd_inst: regd
		generic map(
			N => N
		)
		port map(
			ena_i		=> '1',
			rst_i		=> rst_i,
			clk_i		=> clk_i,
			D_i		=> secuencia_i,
			load_i		=> '0',
			value_i	=> open,
			Q_o:		=> aux
		);
	
	det_flag_o <= '1' when (aux = SECUENCIA) else '0';
end shift_register;
