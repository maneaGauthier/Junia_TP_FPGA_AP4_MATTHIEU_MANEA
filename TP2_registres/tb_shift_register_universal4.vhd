library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_shift_register_universal4 is
end tb_shift_register_universal4;

architecture Behavioral of tb_shift_register_universal4 is

    -- Déclaration du composant à tester
    component shift_register_universal
        Generic ( N : integer );
        Port ( 
            SSR  : in  STD_LOGIC;
            SSL  : in  STD_LOGIC;
            Pi   : in  STD_LOGIC_VECTOR (N-1 downto 0);
            SEL  : in  STD_LOGIC_VECTOR (2 downto 0);
            CLK  : in  STD_LOGIC;
            SETn : in  STD_LOGIC;
            RSTn : in  STD_LOGIC;
            SOR  : out STD_LOGIC;
            SOL  : out STD_LOGIC;
            Qo   : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    -- Constante pour la taille 4 bits
    constant N_BITS : integer := 4;

    -- Signaux d'entrée
    signal SSR  : STD_LOGIC := '0';
    signal SSL  : STD_LOGIC := '0';
    signal Pi   : STD_LOGIC_VECTOR(N_BITS-1 downto 0) := (others => '0');
    signal SEL  : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal CLK  : STD_LOGIC := '0';
    signal SETn : STD_LOGIC := '1';
    signal RSTn : STD_LOGIC := '1';
    
    -- Signaux de sortie
    signal SOR  : STD_LOGIC;
    signal SOL  : STD_LOGIC;
    signal Qo   : STD_LOGIC_VECTOR(N_BITS-1 downto 0);

    -- Période de l'horloge
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciation du registre 4 bits avec l'instruction Generic map
    uut: shift_register_universal 
    generic map (
        N => N_BITS
    )
    port map (
        SSR => SSR, SSL => SSL, Pi => Pi, SEL => SEL,
        CLK => CLK, SETn => SETn, RSTn => RSTn,
        SOR => SOR, SOL => SOL, Qo => Qo
    );

    -- Génération de l'horloge
    clk_process :process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Scénario de test pour le registre 4 bits
    stim_proc: process
    begin
        -- 1. Test du Reset asynchrone
        RSTn <= '0';
        wait for 15 ns;
        RSTn <= '1';
        wait for 10 ns;

        -- 2. Test du Preset asynchrone
        SETn <= '0';
        wait for 15 ns;
        SETn <= '1';
        wait for 10 ns;

        -- 3. Chargement parallèle (X11) - Valeur 4 bits
        Pi <= "1010"; 
        SEL <= "011";
        wait for CLK_PERIOD;

        -- 4. Mémorisation (X00)
        SEL <= "000";
        wait for CLK_PERIOD;

        -- 5. Décalage à droite (001) avec SSR = '1'
        SSR <= '1';
        SEL <= "001";
        wait for CLK_PERIOD * 2;

        -- 6. Décalage à gauche (010) avec SSL = '0'
        SSL <= '0';
        SEL <= "010";
        wait for CLK_PERIOD * 2;

        -- 7. Rotation à droite (101)
        SEL <= "101";
        wait for CLK_PERIOD * 2;

        -- 8. Rotation à gauche (110)
        SEL <= "110";
        wait for CLK_PERIOD * 2;

        -- Fin de la simulation
        wait;
    end process;

end Behavioral;
