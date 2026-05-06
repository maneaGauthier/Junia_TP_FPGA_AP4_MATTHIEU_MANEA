library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_divider is
    Port ( 
        CLKin  : in  STD_LOGIC;
        RST    : in  STD_LOGIC;
        N      : in  STD_LOGIC_VECTOR (4 downto 0);
        CLKout : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal counter : STD_LOGIC_VECTOR(23 downto 0);
begin

    -- a. Compteur synchrone 24 bits
    process(CLKin, RST)
    begin
        if RST = '0' then
            counter <= (others => '0');
        elsif rising_edge(CLKin) then
            counter <= counter + 1;
        end if;
    end process;

    -- b. Multiplexage du bit N à la sortie
    process(counter, N)
    begin
        -- L'utilisation de ieee.std_logic_unsigned.all permet l'utilisation
        -- de conv_integer() pour utiliser N comme index du vecteur.
        if conv_integer(N) < 24 then
            CLKout <= counter(conv_integer(N));
        else
            CLKout <= '0'; -- Sécurité au cas où N dépasserait 23
        end if;
    end process;

end Behavioral;
