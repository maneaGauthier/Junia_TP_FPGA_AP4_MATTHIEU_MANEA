library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bistable is
	port(
        -- ENTREES
		clk : in std_logic;
		rst : in std_logic;
		x   : in std_logic;
		-- SORTIES
		y   : out std_logic
	);
end entity bistable;

architecture behavioral of bistable is
	type state_type is (A, B, C, D);
	signal future_state  : state_type;
	signal current_state : state_type;

	begin

	-- Description du registre d'états
	-- Fonction SEQUENTIELLE
	process(clk, rst)
	begin
		if rst = '1' then
			current_state <= A;
		elsif (clk'event and clk ='1') then
			current_state <= future_state;
		end if;
	end process;

	-- Description du calcul de l'état futur
	-- Fonction COMBINATOIRE
	process(x, current_state)
	begin
		case current_state is
			when A =>
				if    x = '1' then future_state <= B;
				else               future_state <= A;
				end if;
			when B =>
				if    x = '0' then future_state <= C;
				else               future_state <= B;
				end if;
            when C =>
				if    x = '1' then future_state <= D;
				else               future_state <= C;
				end if;
            when D =>
				if    x = '0' then future_state <= A;
				else               future_state <= D;
				end if;
			when others =>
				future_state <= A;
		end case;
	end process;

	-- Description du calcul des sorties
	-- Fonction COMBINATOIRE
	process(current_state)
	begin
		case current_state is
			when A => y <= '0';
			when B => y <= '1';
            when C => y <= '1';
			when D => y <= '0';
			when others => y <= '0';
		end case;
	end process;
end behavioral;
