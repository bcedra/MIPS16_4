library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFF is
    Port ( clk : in STD_LOGIC; --clock
          en : in std_logic; -- enable
          we : in STD_LOGIC; -- write enable
          reset : in STD_LOGIC; --reset
          branch_adr : in STD_LOGIC_VECTOR (15 downto 0);--Adresa de branch
          jump_adr : in STD_LOGIC_VECTOR (15 downto 0);--Adresa de jump
          PCsrc : in STD_LOGIC;-- Semnalul de control PCSrc (pentru branch)
          jmp : in STD_LOGIC; --Semnalul de control Jump
          instruction : out STD_LOGIC_VECTOR (15 downto 0);--Instruc?iunea de executat în ciclul de ceas curent, pe procesorul MIPS
          nextinstruction: out std_logic_vector (15 downto 0));--Adresa urmatoarei instructiuni de executat, mod secvential (PC + 4)
end IFF;

architecture Behavioral of IFF is


---------------------------------  instruction memory
type rom is array (0 to 255) of std_logic_vector(15 downto 0);
signal mem_rom : rom:=(

    --R: opcode(0)_Rs_rt_rd_sa_function
    --I: opcode_rs_rt_imm
    --J: opcode_target addres
	B"000_010_011_001_0_000", --ADD 
	B"000_010_011_001_0_001", --SUB
	B"000_010_011_001_1_010", --SLL
	B"000_010_011_001_1_011", --SLR
	B"000_010_011_001_1_100", --AND	
	B"000_010_011_001_1_101", --OR
	B"000_010_011_001_1_110", --NOR
	B"000_010_011_001_1_111", --XOR
	
	B"001_011_001_0000000", --ADDI
	B"010_011_001_0000000", --LOAD WORD
	B"011_011_001_0000000", --STORE WORD
	B"100_011_001_0000000", --BRANCH ON EQUAL
	B"101_011_001_0000000", --ANDI
	B"110_011_001_0000000", --ORI
	B"111_000_000_000_0001", --JMP
	others=>x"0000");

signal Q : STD_LOGIC_VECTOR(15 downto 0);
signal D : STD_LOGIC_VECTOR(15 downto 0);
signal PCPlusUnu : STD_LOGIC_VECTOR(15 downto 0);
signal mux1 : STD_LOGIC_VECTOR(15 downto 0);
signal mux2 : STD_LOGIC_VECTOR(15 downto 0);
begin

--------------------------------- pc
process (clk)              
begin
   if clk'event and clk='1' then
    if en = '1' then
      Q <= mux2;
      end if;
   end if;
end process;

PCPlusUnu <= Q+1; --deoarece în VHDL memoria ROM am declarat o având cuvântul pe 16 biti (în loc de 8)

--------------------------------- mux1
process(PCsrc)   
begin
    case PCsrc is
        when '0' => mux1 <= PCPlusUnu;  --pc+4
        when '1' => mux1 <= branch_adr; --branch addres
    end case;
end process;

--------------------------------- mux2

process(jmp)   
begin
    case jmp is
        when '0' => mux2 <= mux1;  --Jump = 1 , PC <- jump address
        when '1' => mux2 <= jump_adr; --Jump = 0 , PC <- (PC + 4 daca PCSrc = 0 sau adresa de branch daca PCSrc = 1)
    end case;
end process;
nextinstruction <= Q+1;
instruction <= mem_rom(conv_integer(Q(7 downto 0)));
end Behavioral;