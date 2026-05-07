----------------------------------------------------------------------------------
-- Additionneur complet 1-bit
--
-- Ce module est construit de manière structurelle en instanciant deux
-- demi-additionneurs ('half_adder') pour gérer la somme et la retenue d'entrée (Cin).
-- 
-- Le premier demi-additionneur effectue l'addition A+B.
-- Le deuxième ajoute la retenue entrante (Cin) au résultat.
-- La retenue de sortie (Cout) est activée si l'un des deux étages génère une retenue.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( 
        A    : in  STD_LOGIC;
        B    : in  STD_LOGIC;
        Cin  : in  STD_LOGIC; -- Retenue entrante
        S    : out STD_LOGIC; -- Résultat de la somme
        Cout : out STD_LOGIC  -- Retenue sortante
    );
end full_adder;

architecture Structural of full_adder is
    -- Déclaration du composant half_adder
    component half_adder is
        Port ( 
            A : in  STD_LOGIC;
            B : in  STD_LOGIC;
            S : out STD_LOGIC;
            C : out STD_LOGIC
        );
    end component;

    -- Signaux internes reliant les deux demi-additionneurs
    signal S1 : STD_LOGIC; -- Somme intermédiaire (A+B)
    signal C1 : STD_LOGIC; -- Retenue de A+B
    signal C2 : STD_LOGIC; -- Retenue de S1+Cin

begin

    -- Premier étage : addition de A et B
    HA1: half_adder
    port map(
        A => A,
        B => B,
        S => S1,
        C => C1
    );

    -- Deuxième étage : ajout de la retenue d'entrée au résultat précédent
    HA2: half_adder
    port map(
        A => S1,
        B => Cin,
        S => S,
        C => C2
    );

    -- Logique pour la retenue de sortie :
    -- Si HA1 ou HA2 a généré une retenue, alors l'additionneur complet en sort une.
    Cout <= C1 or C2;

end Structural;