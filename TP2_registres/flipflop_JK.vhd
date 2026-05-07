library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------------
-- Bascule JK synchrone
--
-- Table caractéristique de la bascule JK (sur front montant de l'horloge) :
-- CLK | J | K | Q suivant | Explication
--  ^  | 0 | 0 | Q actuel  | Mémorisation (maintien de l'état précédent)
--  ^  | 0 | 1 | 0         | Reset (Mise à 0)
--  ^  | 1 | 0 | 1         | Set (Mise à 1)
--  ^  | 1 | 1 | non Q     | Basculement (inversion de l'état)
----------------------------------------------------------------------------------

entity flipflop_JK is
    Port ( 
        J   : in  STD_LOGIC; 
        K   : in  STD_LOGIC; 
        CLK : in  STD_LOGIC; -- Horloge (sensible au front montant)
        Q   : out STD_LOGIC; -- Sortie normale
        Qn  : out STD_LOGIC  -- Sortie inversée
    );
end flipflop_JK;

architecture Behavioral of flipflop_JK is
    -- Signal interne nécessaire car une sortie (Q) ne peut pas être lue pour effectuer l'inversion
    signal q_internal : STD_LOGIC := '0';
begin

    -- Processus synchrone déclenché par l'horloge
    process(CLK)
    begin
        -- Détection du front montant sur CLK
        if rising_edge(CLK) then
            
            -- Application de la table de vérité
            if (J = '0' and K = '0') then
                q_internal <= q_internal;     -- Mémorisation
            elsif (J = '0' and K = '1') then
                q_internal <= '0';            -- Mise à 0
            elsif (J = '1' and K = '0') then
                q_internal <= '1';            -- Mise à 1
            elsif (J = '1' and K = '1') then
                q_internal <= not q_internal; -- Basculement
            end if;
            
        end if;
    end process;

    -- Affectation de la valeur du signal interne aux sorties
    Q  <= q_internal;
    Qn <= not q_internal;

end Behavioral;
