library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_chenillard is
-- Un testbench n'a pas de ports
end tb_chenillard;

architecture Behavioral of tb_chenillard is

    -- Déclaration du composant à tester
    component chenillard
        Port ( 
            CLK  : in  STD_LOGIC;
            RST  : in  STD_LOGIC;
            CHEN : out STD_LOGIC_VECTOR (9 downto 0)
        );
    end component;

    -- Signaux internes
    signal CLK  : STD_LOGIC := '0';
    signal RST  : STD_LOGIC := '0';
    signal CHEN : STD_LOGIC_VECTOR (9 downto 0);

    -- Période de l'horloge
    constant CLK_PERIOD : time := 20 ns;

begin

    -- Instanciation du module
    UUT: chenillard port map (
        CLK  => CLK,
        RST  => RST,
        CHEN => CHEN
    );

    -- Processus d'horloge
    clk_process : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD / 2;
        CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Processus de stimulus
    stim_proc: process
    begin
        -- Initialisation : Reset actif
        RST <= '0';
        wait for 40 ns;
        
        -- Relâchement du Reset
        RST <= '1';
        
        -- Observation du chenillard sur un peu plus d'un cycle complet (10 états)
        -- 12 états * 20 ns = 240 ns
        wait for 300 ns;

        -- Arrêt de la simulation
        assert false report "Fin de la simulation" severity failure;
    end process;

end Behavioral;
