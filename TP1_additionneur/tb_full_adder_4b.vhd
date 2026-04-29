-- Ce fichier sert à simuler des scénarios d'entrée pour vérifier 
-- que les retenues se propagent correctement entre les 4 étages.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_full_adder_4b is
end tb_full_adder_4b;

architecture Behavior of tb_full_adder_4b is

    -- On déclare l'additionneur 4 bits
    component full_adder_4b is
        Port ( 
            A    : in  STD_LOGIC_VECTOR (3 downto 0);
            B    : in  STD_LOGIC_VECTOR (3 downto 0);
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC_VECTOR (3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- Signaux internes pour piloter les entrées du composant
    signal A_tb   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal B_tb   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal Cin_tb : STD_LOGIC := '0';

    -- Signaux pour récupérer et observer les sorties dans Questa
    signal S_tb    : STD_LOGIC_VECTOR (3 downto 0);
    signal Cout_tb : STD_LOGIC;

begin

    -- Connexion du composant à tester aux signaux du banc de test
    UUT: full_adder_4b port map (
        A    => A_tb,
        B    => B_tb,
        Cin  => Cin_tb,
        S    => S_tb,
        Cout => Cout_tb
    );

    -- On simule différents cas de figure
    stimulus_process: process
    begin
        -- Cas simple : on vérifie que 0 + 0 ne sort rien
        A_tb <= "0000"; B_tb <= "0000"; Cin_tb <= '0';
        wait for 20 ns;
        
        -- Test classique sans retenue (5 + 3 = 8)
        A_tb <= "0101"; B_tb <= "0011"; Cin_tb <= '0';
        wait for 20 ns;

        -- Test avec retenue d'entrée (Cin)
        A_tb <= "0111"; B_tb <= "0111"; Cin_tb <= '1';
        wait for 20 ns;

        -- Test du débordement (15 + 1)
        A_tb <= "1111"; B_tb <= "0001"; Cin_tb <= '0';
        wait for 20 ns;

        -- Dernier test un peu complexe pour pousser la logique
        A_tb <= "1010"; B_tb <= "1010"; Cin_tb <= '1';
        wait for 20 ns;

        wait;
    end process;

end Behavior;