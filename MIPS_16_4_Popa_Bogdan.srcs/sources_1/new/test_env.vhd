library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           led : out STD_LOGIC_VECTOR(15 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           sw : in STD_LOGIC_VECTOR(15 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
Port ( clk : in std_logic;
    btn: in std_logic;
    enable: out std_logic);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           Digit0 : in STD_LOGIC_VECTOR(3 downto 0);
           Digit1 : in STD_LOGIC_VECTOR(3 downto 0);
           Digit2 : in STD_LOGIC_VECTOR(3 downto 0);
           Digit3 : in STD_LOGIC_VECTOR(3 downto 0);
           CAT : out STD_LOGIC_VECTOR(6 downto 0);
           AN : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component IFF is
    Port ( clk : in STD_LOGIC;
          we : in STD_LOGIC;
          reset : in STD_LOGIC;
          branch_adr : in STD_LOGIC_VECTOR (15 downto 0);
          jump_adr : in STD_LOGIC_VECTOR (15 downto 0);
          PCsrc : in STD_LOGIC;
          jmp : in STD_LOGIC;
          PC : out STD_LOGIC;
          instruction : out STD_LOGIC_VECTOR (15 downto 0));
end component;

type rom_type is array (255 downto 0) of std_logic_vector (15 downto 0);
signal ROM : rom_type:=(
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
	
signal DO  : std_logic_vector(15 downto 0);
signal ADRESA : std_logic_vector(15 downto 0):=x"0000";


signal count : STD_LOGIC_VECTOR(1 downto 0);
signal digits : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal en : STD_LOGIC := '0';
signal we : STD_LOGIC := '0';
signal reset : STD_LOGIC := '1';

begin
   -- C1 : MPG port map(clk, btn(0), en);
   -- C2 : IFF port map(clk,we,reset,branch_addr,jump_addr,jump,PC,DO(15 downto 0);
  --  C3 : SSD port map(clk, DO(15 downto 12), DO(11 downto 8), DO(7 downto 4), DO(3 downto 0), cat, an);
                          
    process (en) 
    begin
       if rising_edge(en) then
          if sw(0) = '1' then   
             ADRESA <= ADRESA + 1;
          else
             ADRESA <= ADRESA - 1;
          end if;
       end if;
    end process;    

     DO<=ROM(conv_integer(ADRESA));

end Behavioral;