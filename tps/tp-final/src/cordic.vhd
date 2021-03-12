entity cordic is
    generic()
    map(
        clk_i: in std_logic,
        rst_i: in std_logic,
        x_i: in std_logic_vector(),
        y_i: in std_logic_vector(),
        angle_i: in std_logic_vector(),
        x_o: out std_logic_vector(),
        y_o: out std_logic_vector()
    )
end entity cordic;

architecture behavioural of cordic is

begin

end architecture;
