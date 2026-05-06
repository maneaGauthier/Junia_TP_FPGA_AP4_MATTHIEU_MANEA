library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    Port (
        CLOCK_50_B6A : in  STD_LOGIC;
        KEY          : in  STD_LOGIC_VECTOR(3 downto 0);
        LEDG         : out STD_LOGIC_VECTOR(7 downto 0)
    );
end toplevel;

architecture Behavioral of toplevel is

    component bistable
        Port (
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            x   : in  STD_LOGIC;
            y   : out STD_LOGIC
        );
    end component;

    signal y_out : STD_LOGIC;
    signal x_in  : STD_LOGIC;
    signal rst_in: STD_LOGIC;

begin

    -- Les boutons KEY sont actifs à l'état bas, on les inverse
    x_in   <= not KEY(0); -- Bouton d'action
    rst_in <= not KEY(1); -- Bouton de reset

    -- Instanciation du bistable
    inst_bistable : bistable port map (
        clk => CLOCK_50_B6A,
        rst => rst_in,
        x   => x_in,
        y   => y_out
    );

    -- Allumer/éteindre toutes les LEDs vertes de la carte
    LEDG <= (others => y_out);

end Behavioral;
