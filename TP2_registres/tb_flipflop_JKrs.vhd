library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_flipflop_JKrs is
-- Banc de test vide pour simulation
end tb_flipflop_JKrs;

architecture behavior of tb_flipflop_JKrs is 

    -- Déclaration du composant à tester
    component flipflop_JKrs
    port(
         J : in  std_logic;
         K : in  std_logic;
         CLK : in  std_logic;
         SETn : in  std_logic;
         RSTn : in  std_logic;
         Q : out  std_logic;
         Qn : out  std_logic
        );
    end component;
    
    -- Signaux internes
    signal J : std_logic := '0';
    signal K : std_logic := '0';
    signal CLK : std_logic := '0';
    signal SETn : std_logic := '1';
    signal RSTn : std_logic := '1';
    
    signal Q : std_logic;
    signal Qn : std_logic;
    
    -- Période d'horloge
    constant CLK_period : time := 10 ns;
    
begin
    -- Instanciation du composant (Unit Under Test)
    uut: flipflop_JKrs port map (
          J => J,
          K => K,
          CLK => CLK,
          SETn => SETn,
          RSTn => RSTn,
          Q => Q,
          Qn => Qn
        );

    -- Processus de génération de l'horloge
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    -- Processus de stimulus
    stim_proc: process
    begin        
        -- Initialisation des signaux asynchrones à l'état inactif (1)
        SETn <= '1';
        RSTn <= '1';
        J <= '0';
        K <= '0';
        wait for 20 ns;
        
        -- =======================================================
        -- 1. Test du Reset Asynchrone initial 
        -- =======================================================
        report "--- DEBUT TEST RESET ASYNCHRONE INITIAL ---";
        RSTn <= '0';
        wait for 2 ns; 
        assert (Q = '0' and Qn = '1') report "Erreur: RSTn asynchrone échoué" severity error;
        wait for 13 ns;
        RSTn <= '1'; -- On relâche le reset
        wait for 5 ns;
        
        -- =======================================================
        -- 2. Tests Synchrones (JK classique) sur fronts montants
        -- =======================================================
        report "--- DEBUT TESTS SYNCHRONES ---";
        wait until rising_edge(CLK);
        
        -- Test Mémorisation (J=0, K=0)
        J <= '0'; K <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns; -- Attente propagation
        assert (Q = '0') report "Erreur: Mémorisation (0) échouée" severity error;
        
        -- Test Mise à 1 (J=1, K=0)
        J <= '1'; K <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert (Q = '1') report "Erreur: Mise à 1 échouée" severity error;
        
        -- Test Mémorisation (J=0, K=0)
        J <= '0'; K <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert (Q = '1') report "Erreur: Mémorisation (1) échouée" severity error;
        
        -- Test Mise à 0 (J=0, K=1)
        J <= '0'; K <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert (Q = '0') report "Erreur: Mise à 0 échouée" severity error;
        
        -- Test Basculement (J=1, K=1)
        J <= '1'; K <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert (Q = '1') report "Erreur: Basculement (0->1) échoué" severity error;
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert (Q = '0') report "Erreur: Basculement (1->0) échoué" severity error;
        
        -- =======================================================
        -- 3. Tests Asynchrones (en dehors des fronts d'horloge)
        -- =======================================================
        report "--- DEBUT TESTS ASYNCHRONES (SETn & RSTn) ---";
        -- On fixe les entrées synchrones à la mémorisation pour éviter les interférences
        J <= '0'; K <= '0'; 
        
        -- On attend explicitement que l'horloge soit à l'état bas
        wait until CLK = '0';
        wait for 2 ns; -- On se décale bien du front descendant
        
        -- Actuellement Q est à 0. On le force à 1 via le signal SETn (Preset asynchrone)
        SETn <= '0';
        wait for 1 ns;
        -- Vérification que Q passe à 1 instantanément sans attendre de front d'horloge
        assert (Q = '1') report "Erreur: Preset asynchrone (SETn) échoué" severity error;
        wait for 2 ns; 
        SETn <= '1'; -- On relâche le preset
        
        wait for CLK_period;
        
        -- On attend à nouveau que l'horloge soit à l'état bas
        wait until CLK = '0';
        wait for 2 ns;
        
        -- Actuellement Q est à 1. On le force à 0 via le signal RSTn (Reset asynchrone)
        RSTn <= '0';
        wait for 1 ns;
        -- Vérification que Q passe à 0 instantanément sans attendre de front d'horloge
        assert (Q = '0') report "Erreur: Reset asynchrone (RSTn) échoué" severity error;
        wait for 2 ns;
        RSTn <= '1'; -- On relâche le reset
        
        report "--- FIN DES TESTS ---";
        -- Fin de la simulation
        wait;
    end process;

end behavior;
