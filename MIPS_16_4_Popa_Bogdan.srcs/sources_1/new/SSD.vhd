library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    port(
    digit0: in std_logic_vector(3 downto 0);
    digit1: in std_logic_vector(3 downto 0);
    digit2: in std_logic_vector(3 downto 0);
    digit3: in std_logic_vector(3 downto 0);
    clk: in std_logic;
    an: out std_logic_vector(3 downto 0);
    cat: out std_logic_vector(6 downto 0)
    );
end SSD;

architecture Behavioral of SSD is
signal count: std_logic_vector(15 downto 0);
signal outm: std_logic_vector(3 downto 0);
begin
    process(clk) -- process pentru numarator
    begin
        if clk='1' and clk'event then
            count<= count+1;
        end if;
    end process;
    
    process( count, digit0, digit1,digit2, digit3 )-- process mux 1
    begin
        case count(15 downto 14) is
            when "00" => outm<=digit0;
            when "01" => outm<=digit1;
            when "10" => outm<=digit2;
            when "11" => outm<=digit3;
        end case;
    end process;
    
    process( count)-- process mux2 - anod
        begin
            case count(15 downto 14) is
                when "00" => an<="1110";
                when "01" => an<="1101";
                when "10" => an<="1011";
                when "11" => an<="0111";
            end case;
        end process;
        
        -- segment encoinputg
        --      0
        --     ---
        --  5 |   | 1
        --     ---   <- 6
        --  4 |   | 2
        --     ---
        --      3
        
       with outm SELect -- pentru afisor
       cat<= "1111001" when "0001",   --1
             "0100100" when "0010",   --2
             "0110000" when "0011",   --3
             "0011001" when "0100",   --4
             "0010010" when "0101",   --5
             "0000010" when "0110",   --6
             "1111000" when "0111",   --7
             "0000000" when "1000",   --8
             "0010000" when "1001",   --9
             "0001000" when "1010",   --A
             "0000011" when "1011",   --b
             "1000110" when "1100",   --C
             "0100001" when "1101",   --d
             "0000110" when "1110",   --E
             "0001110" when "1111",   --F
             "1000000" when others;   --0     

end Behavioral;
