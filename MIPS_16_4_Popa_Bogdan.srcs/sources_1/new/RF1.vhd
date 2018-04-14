library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_block is
port (
    clk : in std_logic;
    ra1 : in std_logic_vector (3 downto 0);
    ra2 : in std_logic_vector (3 downto 0);
    wa : in std_logic_vector (3 downto 0);
    wd : in std_logic_vector (15 downto 0);
    RegWr : in std_logic;
    rd1 : out std_logic_vector (15 downto 0);
    rd2 : out std_logic_vector (15 downto 0)
);
end reg_block;

architecture Behavioral of reg_block is
    type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
    signal reg_block : reg_array:=(
    "0000000000000001",
    "0000000000000010",
    "0000000000000011",
    "0000000000000100",
    "0000000000000101",
    "0000000000000110",
    "0000000000000111",
    "0000000000001000",
    "0000000000001001",
    "0000000000001010",
    "0000000000001011",
    "0000000000001100",
    others=>"0001000100100001" --1121
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if RegWr = '1' then
                reg_block(conv_integer(wa)) <= wd;
             end if;
        end if;
    end process;
    rd1 <= reg_block(conv_integer(ra1));
    rd2 <= reg_block(conv_integer(ra2));
end Behavioral;