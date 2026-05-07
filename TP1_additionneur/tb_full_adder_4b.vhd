----------------------------------------------------------------------------------
-- Banc de test pour l'additionneur 4 bits (tb_full_adder_4b)
--
-- Ce module permet de simuler divers scénarios de test pour valider 
-- la logique d'addition et la propagation des retenues sur les 4 bits.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_full_adder_4b is
end tb_full_adder_4b;

architecture Behavior of tb_full_adder_4b is

    -- Déclaration du composant à tester (additionneur 4 bits)
    component full_adder_4b is
        Port ( 
            A    : in  STD_LOGIC_VECTOR (3 downto 0);
            B    : in  STD_LOGIC_VECTOR (3 downto 0);
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC_VECTOR (3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- Signaux internes (stimuli) pour piloter les entrées du composant
    signal A_tb   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal B_tb   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal Cin_tb : STD_LOGIC := '0';

    -- Signaux de sortie observés
    signal S_tb    : STD_LOGIC_VECTOR (3 downto 0);
    signal Cout_tb : STD_LOGIC;

begin

    -- Instanciation du composant (Unit Under Test)
    UUT: full_adder_4b port map (
        A    => A_tb,
        B    => B_tb,
        Cin  => Cin_tb,
        S    => S_tb,
        Cout => Cout_tb
    );

    -- Processus de génération des stimuli
    stimulus_process: process
    begin
        -- Cas nominal : 0 + 0 = 0
        A_tb <= "0000"; B_tb <= "0000"; Cin_tb <= '0';
        wait for 20 ns;
        
        -- Test classique sans retenue entrante (5 + 3 = 8)
        A_tb <= "0101"; B_tb <= "0011"; Cin_tb <= '0';
        wait for 20 ns;

        -- Test avec retenue d'entrée (Cin)
        A_tb <= "0111"; B_tb <= "0111"; Cin_tb <= '1';
        wait for 20 ns;

        -- Test avec débordement (15 + 1)
        A_tb <= "1111"; B_tb <= "0001"; Cin_tb <= '0';
        wait for 20 ns;

        -- Test avec retenue propagée (10 + 10 + 1)
        A_tb <= "1010"; B_tb <= "1010"; Cin_tb <= '1';
        wait for 20 ns;

        wait;
    end process;

end Behavior;