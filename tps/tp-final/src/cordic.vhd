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

architecture behavioural of cordic is

begin

end architecture;
