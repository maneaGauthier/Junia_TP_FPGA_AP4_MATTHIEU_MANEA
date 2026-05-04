library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Registre universel 8 bits
entity shift_register_universal8 is
    Port ( 
        SSR  : in  STD_LOGIC;                     -- Shift right serial input
        SSL  : in  STD_LOGIC;                     -- Shift left serial input
        Pi   : in  STD_LOGIC_VECTOR (7 downto 0); -- Parallel input
        SEL  : in  STD_LOGIC_VECTOR (2 downto 0); -- Mode selection
        CLK  : in  STD_LOGIC;                     -- Horloge (sensibilité au front montant)
        SETn : in  STD_LOGIC;                     -- Preset (asynchrone, actif à l'état bas)
        RSTn : in  STD_LOGIC;                     -- Reset (asynchrone, actif à l'état bas)
        SOR  : out STD_LOGIC;                     -- Shift output right
        SOL  : out STD_LOGIC;                     -- Shift output left
        Qo   : out STD_LOGIC_VECTOR (7 downto 0)  -- Parallel outputs
    );
end shift_register_universal8;

architecture Behavioral of shift_register_universal8 is
    -- Signal interne pour stocker l'état du registre
    signal q_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin

    -- Processus gérant les états synchrones et asynchrones
    process(CLK, RSTn, SETn)
    begin
        -- Reset asynchrone (priorité maximale)
        if RSTn = '0' then
            q_reg <= (others => '0');
        
        -- Preset asynchrone
        elsif SETn = '0' then
            q_reg <= (others => '1');
            
        -- Comportement synchrone sur front montant de l'horloge
        elsif rising_edge(CLK) then
            case SEL is
                when "000" | "100" => 
                    q_reg <= q_reg; -- X00 : Mémorisation (Hold)
                    
                when "011" | "111" => 
                    q_reg <= Pi;    -- X11 : Chargement parallèle (Parallel load)
                    
                when "001" => 
                    q_reg <= SSR & q_reg(7 downto 1); -- 001 : Décalage à droite (Shift right)
                    
                when "010" => 
                    q_reg <= q_reg(6 downto 0) & SSL; -- 010 : Décalage à gauche (Shift left)
                    
                when "101" => 
                    q_reg <= q_reg(0) & q_reg(7 downto 1); -- 101 : Rotation à droite (Rotate right)
                    
                when "110" => 
                    q_reg <= q_reg(6 downto 0) & q_reg(7); -- 110 : Rotation à gauche (Rotate left)
                    
                when others =>
                    q_reg <= q_reg; -- Par défaut, on garde la valeur
            end case;
        end if;
    end process;

    -- Assignation des sorties
    Qo  <= q_reg;
    SOR <= q_reg(0); -- La sortie droite est le bit de poids faible (LSB)
    SOL <= q_reg(7); -- La sortie gauche est le bit de poids fort (MSB)

end Behavioral;
