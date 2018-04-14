library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
    port(
        clk:in std_logic;
        ce: in std_logic;
        an: out std_logic_vector(3 downto 0);
        cat: out std_logic_vector(6 downto 0)
        );
end ROM;

architecture Behavioral of ROM is

component MPG 
	port( 
	input: in std_logic;
	clk: in std_logic;
	enable: out std_logic
	);
end component;

component SSD 
    port(
    digit0: in std_logic_vector(3 downto 0);
    digit1: in std_logic_vector(3 downto 0);
    digit2: in std_logic_vector(3 downto 0);
    digit3: in std_logic_vector(3 downto 0);
    clk: in std_logic;
    an: out std_logic_vector(3 downto 0);
    cat: out std_logic_vector(6 downto 0)
    );
end component;

signal count: std_logic_vector(7 downto 0);
signal ce1: std_logic;
signal x: std_logic_vector(15 downto 0);

type rom is array (0 to 255) of std_logic_vector(15 downto 0);
signal mem_rom : rom:=(
	B"000_010_011_001_0_000", --ADD
	B"000_010_011_001_0_001", --SUB
	B"000_010_011_001_1_010", --SLL
	B"000_010_011_001_1_011", --SLR
	B"000_010_011_001_1_100", --AND	
	B"000_010_011_001_1_101", --OR
	B"000_010_011_001_1_110", --NOR
	B"000_010_011_001_1_111", --XOR
	
	B"001_011_001_0000010", --ADDI
	B"010_011_001_0000010", --LOAD WORD
	B"011_011_001_0000010", --STORE WORD
	B"100_011_001_0000010", --BRANCH ON EQUAL
	B"101_011_001_0000010", --BRANCH ON NOT EQUAL
	B"110_011_001_0000010", --SLTIU
	others=>x"0000");
begin
    C1: MPG port map(ce,clk,ce1);
    process(clk)
    begin
        if clk'event and clk='1' then
            if ce1='1' then
                count<=count+1;
            end if;
        end if;
    end process;
    
    x<=mem_rom(conv_integer(count));
    C2: SSD port map(x(15 downto 12) ,x(11 downto 8) ,x(7 downto 4) ,x(3 downto 0),clk,an,cat);
end Behavioral;
