entity cordic is
    generic(
        Nxy: natural 16
        Nangle: natural 16
    );
    map(
        rst_i: in std_logic;
        clk_i: in std_logic;
        x_i: in std_logic_vector(Nxy-1 downto 0);
        y_i: in std_logic_vector(Nxy-1 downto 0);
        angle_i: in std_logic_vector(Nangle-1 downto 0);
        x_o: out std_logic_vector(Nxy-1 downto 0);
        y_o: out std_logic_vector(Nxy-1 downto 0)
    );
end entity cordic;


--cordic pipeline.
architecture behavioural of cordic is
    --declaracion sumador de N bits.
    component sumNb is
        generic( 
            N: natural := 4
        );
        port(
            a_i:    in std_logic_vector(N-1 downto 0);
            b_i:    in std_logic_vector(N-1 downto 0);
            control:    in std_logic;
            s_o:    out std_logic_vector(N-1 downto 0);
            co_o:   out std_logic
        );
    end component;

    --declaracion registro de N bits.
    component regNb is
        generic(
            N: natural := 4
        );
        port(
            D_i:    in  std_logic_vector(N-1 downto 0);
            rst_i:  in  std_logic;
            clk_i:  in  std_logic;
            Q_o:    out std_logic_vector(N-1 downto 0)
        );
    end component;

    type SIGNAL_ARRAY is array(integer range <>) of std_logic_vector;

    signal aux1: SIGNAL_ARRAY(Nxy-1 downto 0); 
    signal signo: std_logic;
begin
    -- preprocesamiento


    aux1(0) <= x_i;
    aux2(0) <= y_i;

    --cordic
    step : for i in 0 to Nxy-1 generate

            signo <= aux1(0);

            Sum_inst1: sumNb 
                generic map ( 
                    N => Nangle
                )
                port map (
                    a_i => ,
                    b_i => ,
                    control => signo,
                    s_o    => ,
                    co_o   => open
                );

            Sum_inst2: sumNb 
                generic map ( 
                    N => Nxy
                )
                port map (
                    a_i => aux1(i),
                    b_i => ,
                    control => signo,
                    s_o    => ,
                    co_o   => open
                );


            Sum_inst3: sumNb 
                generic map ( 
                    N => Nxy
                )
                port map (
                    a_i => aux2(i),
                    b_i => ,
                    control => signo,
                    s_o    => ,
                    co_o   => open
                );


            RegSal_inst: regNb 
                generic map(
                    N => 
                )
                port map(
                    D_i => ,
                    rst_i => ,
                    clk_i => ,
                    Q_o =>
                );

    end generate ; -- step
    

    --post-procesamiento.
end architecture;
