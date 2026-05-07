----------------------------------------------------------------------------------
-- Demi-additionneur 1-bit
--
-- Ce module réalise l'addition de deux bits.
-- La somme (S) est obtenue par une porte logique XOR.
-- La retenue (C) est générée par une porte logique AND, active si A et B valent '1'.
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