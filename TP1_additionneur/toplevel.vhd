library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    port (
        HEX3 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        SW   : in  std_logic_vector(9 downto 0) 
    );
end toplevel;

architecture Structural of toplevel is

    -- Déclaration de l'additionneur 4 bits (sans le mot-clé 'is')
    component full_adder_4b
        port ( 
            A    : in  std_logic_vector(3 downto 0);
            B    : in  std_logic_vector(3 downto 0);
            Cin  : in  std_logic;
            S    : out std_logic_vector(3 downto 0);
            Cout : out std_logic
        );
    end component;

    -- Déclaration du transcodeur 7 segments (sans le mot-clé 'is')
    component transcodeur_7seg
        port ( 
            BIN : in  std_logic_vector(3 downto 0);
            SEG : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Signaux internes pour connecter les switchs à l'additionneur
    signal sig_A, sig_B, sig_S : std_logic_vector(3 downto 0);
    signal sig_Cin, sig_Cout   : std_logic;

begin

    -- Routage des interrupteurs vers les signaux internes
    sig_A   <= SW(3 downto 0); -- A sur SW0-3
    sig_B   <= SW(7 downto 4); -- B sur SW4-7
    sig_Cin <= SW(9);          -- Cin sur SW9

    -- Instanciation de l'additionneur
    ADDER : full_adder_4b port map (
        A    => sig_A,
        B    => sig_B,
        Cin  => sig_Cin,
        S    => sig_S,
        Cout => sig_Cout
    );

    -- Instanciation des 3 transcodeurs pour l'affichage
    
    -- Afficheur HEX3 pour l'opérande A
    AFF_A : transcodeur_7seg port map (
        BIN => sig_A,
        SEG => HEX3
    );

    -- Afficheur HEX2 pour l'opérande B
    AFF_B : transcodeur_7seg port map (
        BIN => sig_B,
        SEG => HEX2
    );

    -- Afficheur HEX0 pour le résultat S
    AFF_S : transcodeur_7seg port map (
        BIN => sig_S,
        SEG => HEX0
    );

end Structural;