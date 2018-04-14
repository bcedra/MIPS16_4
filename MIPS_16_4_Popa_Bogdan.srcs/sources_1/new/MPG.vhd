library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_1164.all;

entity MPG is
    Port ( clock : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal count_int : std_logic_vector(31 downto 0) :=x"00000000";
signal Q1 : std_logic;
signal Q2 : std_logic;
signal Q3 : std_logic;

begin

en <= Q2 AND (not Q3);


process (clock)
begin
 if clock='1' and clock'event then
 count_int <= count_int + 1;
 end if;
end process;


process (clock)
begin
 if clock'event and clock='1' then
 if count_int(15 downto 0) = "1111111111111111" then
 Q1 <= btn;
 end if;
 end if;
end process;




process (clock)
begin
 if clock'event and clock='1' then
 Q2 <= Q1;
 Q3 <= Q2;
 end if;
end process;


end Behavioral;
