----------------------------------------------------------------------------------
-- Ce module est la brique de base : le demi-additionneur 1-bit.

-- La somme (S) correspond bien à un XOR car on veut '1' uniquement quand les entrées sont différentes.

-- Pour la retenue (C) un simple AND suffit car elle ne s'active que si A et B sont à '1' en même temps.

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    Port ( 
        A : in  STD_LOGIC;
        B : in  STD_LOGIC;
        S : out STD_LOGIC; -- Résultat de l'addition
        C : out STD_LOGIC  -- Retenue générée
    );
end half_adder;

architecture Behavioral of half_adder is
begin
    S <= A xor B;
    C <= A and B;
end Behavioral;