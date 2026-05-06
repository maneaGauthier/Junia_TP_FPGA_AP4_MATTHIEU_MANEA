library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel_tp3 is
    port (
        CLOCK_50_B6A : in  std_logic;
        KEY          : in  std_logic_vector(3 downto 0);
        LEDR         : out std_logic_vector(9 downto 0)
    );
end entity toplevel_tp3;

architecture Structural of toplevel_tp3 is

    -- Déclaration du composant clock_divider
    component clock_divider
        Port ( 
            CLKin  : in  STD_LOGIC;
            RST    : in  STD_LOGIC;
            N      : in  STD_LOGIC_VECTOR (4 downto 0);
            CLKout : out STD_LOGIC
        );
    end component;

    -- Déclaration du composant chenillard
    component chenillard
        Port ( 
            CLK  : in  STD_LOGIC;
            RST  : in  STD_LOGIC;
            CHEN : out STD_LOGIC_VECTOR (9 downto 0)
        );
    end component;

    -- Signal intermédiaire pour relier CLKout du diviseur au CLK du chenillard
    signal clk_div : STD_LOGIC;

    -- Choix de la valeur de N pour un affichage visible à l'oeil nu.
    -- Fout = Fin / 2^(N+1)
    -- Avec Fin = 50 MHz = 50 000 000 Hz
    -- Si N = 23 (soit 23 en décimal = "10111" en binaire), 2^(23+1) = 2^24 = 16 777 216
    -- Fout ≈ 50 000 000 / 16 777 216 ≈ 2.98 Hz (environ 3 LED par seconde, ce qui est parfait)
    constant N_VAL : STD_LOGIC_VECTOR(4 downto 0) := "10111"; 

begin

    -- Instanciation du bloc diviseur d'horloge
    -- RST est câblé sur KEY(0) qui est actif à l'état bas (le petit cercle sur le schéma)
    inst_clk_div : clock_divider port map (
        CLKin  => CLOCK_50_B6A,
        RST    => KEY(0),
        N      => N_VAL,
        CLKout => clk_div
    );

    -- Instanciation du bloc chenillard
    -- RST est câblé sur KEY(0) également
    inst_chenillard : chenillard port map (
        CLK  => clk_div,
        RST  => KEY(0),
        CHEN => LEDR
    );

end architecture Structural;
