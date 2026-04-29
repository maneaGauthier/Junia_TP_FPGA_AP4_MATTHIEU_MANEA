-- On assemble ici 4 blocs 'full_adder' de 1 bit
-- On va "chaîner" les retenues : la sortie Cout du bit N devient le Cin du bit N+1
-- C'est un Ripple-Carry Adder
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_4b is
    Port ( 
        A    : in  STD_LOGIC_VECTOR (3 downto 0); -- Vecteur de 4 bits pour le nombre A
        B    : in  STD_LOGIC_VECTOR (3 downto 0); -- Vecteur de 4 bits pour le nombre B
        Cin  : in  STD_LOGIC;                     -- Retenue initiale
        S    : out STD_LOGIC_VECTOR (3 downto 0); -- Résultat sur 4 bits
        Cout : out STD_LOGIC                      -- Retenue finale si le résultat est plus grand que 15
    );
end full_adder_4b;

architecture Structural of full_adder_4b is

    -- On récupère notre bloc de l'exercice précédent
    component full_adder is
        Port ( 
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    -- Ces signaux servent de "ponts" entre les additionneurs
    -- C(1) transporte la retenue du bit 0 vers le bit 1, etc
    signal C : STD_LOGIC_VECTOR (3 downto 1);

begin

    -- On commence par les bits de poids faible
    FA0: full_adder port map (
        A    => A(0),
        B    => B(0),
        Cin  => Cin,
        S    => S(0),
        Cout => C(1)
    );

    -- Reçoit la retenue du bit 0
    FA1: full_adder port map (
        A    => A(1),
        B    => B(1),
        Cin  => C(1),
        S    => S(1),
        Cout => C(2)
    );

    -- Reçoit la retenue du bit 1
    FA2: full_adder port map (
        A    => A(2),
        B    => B(2),
        Cin  => C(2),
        S    => S(2),
        Cout => C(3)
    );

    -- Le dernier bit. Sa retenue sort vers le port global Cout
    FA3: full_adder port map (
        A    => A(3),
        B    => B(3),
        Cin  => C(3),
        S    => S(3),
        Cout => Cout
    );

end Structural;