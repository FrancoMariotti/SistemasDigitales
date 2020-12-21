library IEEE;
use IEEE.std_logic_1164.all;

entity ffd is
	port(
		D_i:	in	std_logic;
		rst_i:	in 	std_logic;
		clk_i:	in	std_logic;
		Q_o:	out	std_logic
	);
end;

--flip-flop D con reset asincronico.
architecture ffd_arq of ffd is
begin
	process(clk_i,rst_i) is
	begin
		if rst_i = '1' then
			Q_o <= '0';
		elsif rising_edge(clk_i) then
			Q_o <= D_i;
		end if;
	end process;
end ffd_arq;


--flip-flop D con reset sincronico.
architecture ffd_arq_2 of ffd is
begin
	process(clk_i,rst_i) is
	begin
		if rising_edge(clk_i) then
			if rst_i = '1' then
				Q_o <= '0';
			else
				Q_o <= D_i;
			end if;
		end if;
	end process;
end ffd_arq_2;


--flip-flop D con reset sincronico.
--y set asincronico
architecture ffd_arq_3 of ffd is
begin
	process(clk_i,rst_i,set_i) is
	begin
		if set_i = '1' then
			Q_o <= '1'
		else if rising_edge(clk_i) then
			if rst_i = '1' then
				Q_o <= '0';
			else
				Q_o <= D_i;
			end if;
		end if;
	end process;
end ffd_arq_3;



--flip-flop D con reset sincronico.
--y set asincronico
architecture ffd_arq_4 of ffd is
begin
	process(clk_i,rst_i,set_i) is
	begin
		if set_i = '1' then
			Q_o <= '1'
		else if rising_edge(clk_i) then
			if rst_i = '1' then
				Q_o <= '0';
			else
				Q_o <= D_i;
			end if;
		end if;
	end process;
end ffd_arq_4;

--flip-flop D con reset sincronico.
--y set sincronico
architecture ffd_arq_4 of ffd is
begin
	process(clk_i,rst_i,set_i) is
	begin
		else if rising_edge(clk_i) then
			if rst_i = '1' then
				Q_o <= '0';
			else if set_i = '1' then
				Q_o <= '1'
			else
				Q_o <= D_i;
			end if;
		end if;
	end process;
end ffd_arq_4;
