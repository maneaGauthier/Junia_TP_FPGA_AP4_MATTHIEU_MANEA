----------------------------------------------------------------------------------
-- Description du fonctionnement de la bascule JK avec entrées asynchrones (SETn, RSTn) :
-- 
-- Les signaux SETn (Preset) et RSTn (Reset) sont asynchrones et actifs à l'état bas ('0').
-- Ils sont prioritaires sur le fonctionnement synchrone lié à l'horloge (CLK).
-- 
-- Table de vérité simplifiée :
-- RSTn | SETn | CLK | J | K || Q(t+1) | Description
--  0   |  X   |  X  | X | X ||   0    | Reset asynchrone (Priorité max)
--  1   |  0   |  X  | X | X ||   1    | Preset asynchrone
--  1   |  1   |  ^  | 0 | 0 ||  Q(t)  | Mémorisation (Synchrone)
--  1   |  1   |  ^  | 0 | 1 ||   0    | Mise à 0 (Synchrone)
--  1   |  1   |  ^  | 1 | 0 ||   1    | Mise à 1 (Synchrone)
--  1   |  1   |  ^  | 1 | 1 || ~Q(t)  | Basculement (Synchrone)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflop_JKrs is
    Port ( J    : in  STD_LOGIC;
           K    : in  STD_LOGIC;
           CLK  : in  STD_LOGIC;
           SETn : in  STD_LOGIC;
           RSTn : in  STD_LOGIC;
           Q    : out STD_LOGIC;
           Qn   : out STD_LOGIC);
end flipflop_JKrs;

architecture Behavioral of flipflop_JKrs is
    signal Q_int : STD_LOGIC := '0';
begin
    -- Processus sensible à l'horloge et aux signaux asynchrones
    process(CLK, SETn, RSTn)
    begin
        -- Priorité 1: Reset asynchrone actif à l'état bas
        if RSTn = '0' then
            Q_int <= '0';
        -- Priorité 2: Preset (Set) asynchrone actif à l'état bas
        elsif SETn = '0' then
            Q_int <= '1';
        -- Priorité 3: Comportement synchrone sur front montant de l'horloge
        elsif rising_edge(CLK) then
            if (J = '0' and K = '0') then
                Q_int <= Q_int;     -- Mémorisation
            elsif (J = '0' and K = '1') then
                Q_int <= '0';       -- Mise à 0
            elsif (J = '1' and K = '0') then
                Q_int <= '1';       -- Mise à 1
            elsif (J = '1' and K = '1') then
                Q_int <= not Q_int; -- Basculement
            end if;
        end if;
    end process;
    
    -- Assignation des sorties (normale et complémentée)
    Q  <= Q_int;
    Qn <= not Q_int;

end Behavioral;
