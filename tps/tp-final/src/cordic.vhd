library IEEE;
use IEEE.std_logic_1164.all;

entity cordic is
    generic(
        Nxy: natural := 16;
        Nangle: natural := 16
    );
    port(
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

    type xy_signal_arr is array(natural range <>) of std_logic_vector(Nxy-1 downto 0);
    type z_signal_arr is array(natural range <>) of std_logic_vector(Nangle-1 downto 0);

    signal x_aux: xy_signal_arr(Nxy-1 downto 0); 
    signal y_aux: xy_signal_arr(Nxy-1 downto 0);
    signal z_aux: z_signal_arr(Nxy-1 downto 0);     
    
    signal x_aux2: xy_signal_arr(Nxy-1 downto 0); 
    signal y_aux2: xy_signal_arr(Nxy-1 downto 0);
    
    signal x_adder_out: xy_signal_arr(Nxy-1 downto 0);
    signal y_adder_out: xy_signal_arr(Nxy-1 downto 0);
    signal z_adder_out: z_signal_arr(Nxy-1 downto 0);

    signal signo: std_logic;
begin
    -- preprocesamiento


    x_aux(0) <= x_i;
    y_aux(0) <= y_i;
    z_aux(0) <= angle_i;

    --cordic
    step : for i in 0 to Nxy-1 generate

            signo <= x_aux(0)(0);

            --shift x, i posiciones a la izquierda 
            x_aux2 <= (i-1 downto 0 => '0') & x_aux(i)(Nxy-i-1);
            
            --shift y, i posiciones a la izquierda 
            y_aux2 <= (i-1 downto 0 => '0') & y_aux(i)(Nxy-i-1);

            --Sumador angulo Z
            Z_adder: sumNb 
                generic map ( 
                    N => Nangle
                )
                port map (
                    a_i => z_aux(i),
                    b_i => ,--cte
                    control => signo,
                    s_o    => z_adder_out(i),
                    co_o   => open
                ); 

            --Sumador Y
            Y_adder: sumNb 
                generic map ( 
                    N => Nxy
                )
                port map (
                    a_i => y_aux(i),
                    b_i => x_aux2(i),
                    control => signo,
                    s_o    => y_adder_out(i),
                    co_o   => open
                );

            --Sumador X
            X_adder: sumNb 
                generic map ( 
                    N => Nxy
                )
                port map (
                    a_i => x_aux(i),
                    b_i => y_aux2(i),
                    control => signo,
                    s_o    => x_adder_out(i),
                    co_o   => open
                );


            salida: if (i = Nxy-1) generate

            begin
                x_o <= x_adder_out(i);
                y_o <= y_adder_out(i);
                z_o <= z_adder_out(i);

            end generate salida;

            registro: if (i /= Nxy-1) generate
 
                --Registro interetapa X.
                Reg_adder_x: regNb 
                    generic map(
                        N => Nxy
                    )
                    port map(
                        D_i => x_adder_out(i),
                        rst_i => rst_i,
                        clk_i => clk_i,
                        Q_o => x_aux(i+1)
                    );
                --Registro interetapa Y.
                Reg_adder_y: regNb 
                    generic map(
                        N => Nxy
                    )
                    port map(
                        D_i => y_adder_out(i),
                        rst_i => rst_i,
                        clk_i => clk_i,
                        Q_o => y_aux(i+1)
                    );


                --Registro interetapa Z.
                Reg_adder_z: regNb 
                    generic map(
                        N => Nangle
                    )
                    port map(
                        D_i => z_adder_out(i),
                        rst_i => rst_i,
                        clk_i => clk_i,
                        Q_o => z_aux(i+1)
                    );


            end generate registro;


    end generate step; -- step
    

    --post-procesamiento.
end architecture;
