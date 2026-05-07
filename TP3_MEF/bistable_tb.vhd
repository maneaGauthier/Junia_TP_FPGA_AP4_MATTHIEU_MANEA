library ieee;
use ieee.std_logic_1164.all;

entity bistable_tb is
end bistable_tb;

architecture behavior of bistable_tb is

    -- Déclaration du composant à tester
    component bistable
    port(
         clk : in std_logic;
         rst : in std_logic;
         x   : in std_logic;
         y   : out std_logic
        );
    end component;

   -- Entrées
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal x   : std_logic := '0';

   -- Sorties
   signal y : std_logic;

   -- Définition de la période d'horloge
   constant clk_period : time := 20 ns;

BEGIN

   -- Instanciation de l'UUT (Unit Under Test)
   uut: bistable port map (
          clk => clk,
          rst => rst,
          x   => x,
          y   => y
        );

   -- Processus de génération d'horloge
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;

   -- Processus de stimulus
   stim_proc: process
   begin
      -- Reset initial
      rst <= '1';
      wait for 40 ns;
      rst <= '0';
      wait for clk_period*2;

      -- Test: 1er appui sur le bouton (allume les LEDs)
      -- A -> B -> C
      x <= '1';
      wait for clk_period*3;
      x <= '0';
      wait for clk_period*3;

      -- Test: 2ème appui sur le bouton (éteint les LEDs)
      -- C -> D -> A
      x <= '1';
      wait for clk_period*3;
      x <= '0';
      wait for clk_period*3;

      -- Test: 3ème appui (rallume les LEDs)
      x <= '1';
      wait for clk_period*3;
      x <= '0';
      wait for clk_period*3;

      -- Fin de simulation
      wait;
   end process;

END behavior;
