library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Top Level pour l'implémentation sur carte FPGA
entity toplevel_tp2 is
    Port ( 
        SW   : in  STD_LOGIC_VECTOR (9 downto 0); -- Switches de la carte
        KEY  : in  STD_LOGIC_VECTOR (3 downto 0); -- Boutons poussoirs (actifs à l'état bas)
        LEDG : out STD_LOGIC_VECTOR (7 downto 0)  -- LEDs vertes
    );
end toplevel_tp2;

architecture Behavioral of toplevel_tp2 is

    -- Déclaration de notre registre universel 8 bits
    component shift_register_universal8
        Port ( 
            SSR  : in  STD_LOGIC;
            SSL  : in  STD_LOGIC;
            Pi   : in  STD_LOGIC_VECTOR (7 downto 0);
            SEL  : in  STD_LOGIC_VECTOR (2 downto 0);
            CLK  : in  STD_LOGIC;
            SETn : in  STD_LOGIC;
            RSTn : in  STD_LOGIC;
            SOR  : out STD_LOGIC;
            SOL  : out STD_LOGIC;
            Qo   : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Signal pour l'horloge inversée
    signal clk_inv : STD_LOGIC;
    
begin
    
    -- Inversion de KEY0 pour l'horloge (car les boutons sont actifs à l'état bas)
    clk_inv <= not KEY(0);

    -- Instanciation et câblage avec les I/O de la carte
    inst_shift_reg : shift_register_universal8
    port map (
        SSR  => SW(9),            -- SSR connecté à SW9
        SSL  => SW(8),            -- SSL connecté à SW8
        Pi   => (others => '0'),  -- P7-P0 connectés à 0 (chargement parallèle inutilisé)
        SEL  => SW(2 downto 0),   -- SEL connecté à SW2-SW0
        CLK  => clk_inv,          -- CLK connecté à not(KEY0)
        SETn => KEY(2),           -- SETn connecté à KEY2
        RSTn => KEY(3),           -- RSTn connecté à KEY3
        SOR  => open,             -- Non connecté (-)
        SOL  => open,             -- Non connecté (-)
        Qo   => LEDG(7 downto 0)  -- Q7-Q0 connectés à LEDG7-0
    );

end Behavioral;
