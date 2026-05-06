library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock_divider is
-- Un testbench n'a pas de ports
end tb_clock_divider;

architecture Behavioral of tb_clock_divider is

    -- Déclaration du composant à tester
    component clock_divider
        Port ( 
            CLKin  : in  STD_LOGIC;
            RST    : in  STD_LOGIC;
            N      : in  STD_LOGIC_VECTOR (4 downto 0);
            CLKout : out STD_LOGIC
        );
    end component;

    -- Signaux internes pour se connecter au composant
    signal CLKin  : STD_LOGIC := '0';
    signal RST    : STD_LOGIC := '0';
    -- On choisit une valeur faible (N=2 -> division par 8) pour que la simu soit courte
    signal N      : STD_LOGIC_VECTOR (4 downto 0) := "00010"; 
    signal CLKout : STD_LOGIC;

    -- Constante pour la période de l'horloge (50 MHz = 20 ns)
    constant CLK_PERIOD : time := 20 ns;

begin

    -- Instanciation de l'UUT (Unit Under Test)
    UUT: clock_divider port map (
        CLKin  => CLKin,
        RST    => RST,
        N      => N,
        CLKout => CLKout
    );

    -- Processus de génération de l'horloge
    clk_process : process
    begin
        CLKin <= '0';
        wait for CLK_PERIOD / 2;
        CLKin <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Processus de stimulus (Reset et changement de N)
    stim_proc: process
    begin
        -- 1. Initialisation : Reset actif (à l'état bas)
        RST <= '0';
        wait for 50 ns;
        
        -- 2. Relâchement du reset
        RST <= '1';
        
        -- Observation du comportement avec N = "00010" (bit 2, division par 8)
        -- Fout = Fin / 2^(2+1) = Fin / 8
        -- Période CLKout = 20 ns * 8 = 160 ns
        wait for 1000 ns;
        
        -- 3. Changement de N en cours de route pour observer une autre fréquence
        -- N = 3 -> division par 16 (Fout = Fin / 2^(3+1))
        N <= "00011";
        wait for 1000 ns;

        -- Fin de la simulation (si on veut l'arrêter)
        -- wait; -- commenter cette ligne si on souhaite laisser tourner indéfiniment
        assert false report "Fin de la simulation" severity failure;
    end process;

end Behavioral;
