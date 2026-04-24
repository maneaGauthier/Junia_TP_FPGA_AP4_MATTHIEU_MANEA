-- Pour ce module, on n'a pas réécrit de logique brute.
-- On a utiliser l'instanciation de deux 'half_adder' pour
-- gérer la somme et la retenue d'entrée (Cin)
--
-- Le premier demi-additionneur fait A+B, et le deuxième ajoute la retenue Cin 
-- au résultat. La retenue finale (Cout) est activée si l'un des deux étages 
-- génère un débordement (d'où le OR final)
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
    -- On déclare le composant qu'on a fabriqué à juste avant
    component half_adder is
        Port ( 
            A : in  STD_LOGIC;
            B : in  STD_LOGIC;
            S : out STD_LOGIC;
            C : out STD_LOGIC
        );
    end component;

    -- Signaux internes pour "cabler" nos deux demi-additionneurs entre eux
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

    -- Deuxième étage : on ajoute la retenue d'entrée au résultat précédent
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