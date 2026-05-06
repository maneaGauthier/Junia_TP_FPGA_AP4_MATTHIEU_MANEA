library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity chenillard is
    Port ( 
        CLK  : in  STD_LOGIC;
        RST  : in  STD_LOGIC;
        CHEN : out STD_LOGIC_VECTOR (9 downto 0)
    );
end chenillard;

architecture Behavioral of chenillard is
    -- Registre interne pour le décalage, initialisé à 0000001111
    signal shift_reg : STD_LOGIC_VECTOR(9 downto 0);
begin

    process(CLK, RST)
    begin
        -- On suppose un reset actif à l'état bas (comme dans la question précédente)
        if RST = '0' then
            shift_reg <= "0000001111";
        elsif rising_edge(CLK) then
            -- Décalage circulaire vers la gauche
            -- On prend les 9 bits de poids faible et on les place en poids fort,
            -- et le bit de poids fort (bit 9) repasse en poids faible (bit 0)
            shift_reg <= shift_reg(8 downto 0) & shift_reg(9);
        end if;
    end process;

    -- Assignation de la sortie
    CHEN <= shift_reg;

end Behavioral;
