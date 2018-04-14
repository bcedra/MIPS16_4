library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ID is
    Port ( clk : in STD_LOGIC;--clock
           Instruction : in STD_LOGIC_VECTOR (15 downto 0);--instructiunea
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);--datele care se scriu in Rf, write enable data
           RegWrite: in STD_LOGIC;-- activarea scrierii în RF
           RegDst: in STD_LOGIC;-- selecteaza adresa de scriere în RF
           ExtOp: in STD_LOGIC;-- selecteaza tipul de extensie pentru câmpul immediat: cu zero sau cu semn
           en: in std_logic;--enable
           ReadData1 : out STD_LOGIC_VECTOR (15 downto 0);--Registru de la adresa rs, RD1 
           ReadData2 : out STD_LOGIC_VECTOR (15 downto 0);--Registru de la adresa rt,  RD2 
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);--Imediatul extins, Ext_Imm
           SA : out STD_LOGIC;-- Câmpul sa, pe 5 biti
           Func : out STD_LOGIC_VECTOR (2 downto 0));--Câmpul func, pe 6 bi?i
end ID;
architecture Behavioral of ID is

 type memory is array(0 to 7) of std_logic_vector(15 downto 0);
signal mem : memory := (
B"0000000000000000", --adr 0 
B"000_000_000_000_0_001", --1 
B"000_000_000_000_0_010", --2
B"000_000_000_000_0_011", --3
B"000_000_000_000_0_100", --4
B"000_000_000_000_0_101", --5
B"000_000_000_000_0_110", --6
B"000_000_000_000_0_111", --7
others=>(B"100000000000000")
);
    signal ReadAddress1: STD_LOGIC_VECTOR(2 downto 0);
    signal ReadAddress2: STD_LOGIC_VECTOR(2 downto 0);
    signal aux: STD_LOGIC_VECTOR(2 downto 0);
    
    begin
         process(ExtOp, Instruction)
         begin
             case(ExtOp) is
                 when '1' =>
                     case(Instruction(6)) is
                         when '0' => Ext_Imm <= B"000000000" & Instruction(6 downto 0); --ExtOp = 0  imediatul este extins cu zero
                         when '1' => Ext_Imm <= B"111111111" & Instruction(6 downto 0); --ExtOp = 1  imediatul este extins cu semn
                     end case;
                 when others => Ext_Imm <= B"000000000" & Instruction(6 downto 0);
             end case;
         end process;
         
           process(RegDst, Instruction)
           begin
               case(RegDst) is
                   when '0' => aux <=Instruction(9 downto 7);--daca i de tip i, RegDst = 0  pe Write Address din RF ajunge câmpul rt al instructiunii (Instr[9:7])
                   when '1' => aux <= Instruction(6 downto 4);--tip r,  RegDst = 1  pe Write Address din RF ajunge câmpul rd al instructiunii (Instr[6:4])
               end case;
           end process;
           
           process(clk)
           begin
           if clk'event and clk ='1' then
             if RegWrite = '1' and en = '1' then --RegWrite = 1  se activeaza scrierea (front cresc?tor de ceas!) de pe Write Data în registrul dat de Write Address, în RF
              mem(conv_integer(aux)) <= WriteData;
              end if;
              end if;
           end process;
           
           Func <= Instruction(2 downto 0); --ALU Control
           SA <= Instruction (3);          --ShiftAmount
                       
           ReadAddress1 <= Instruction(12 downto 10); --rs
           ReadAddress2 <= Instruction (9 downto 7);   --rt
           
           ReadData1 <= mem(conv_integer(ReadAddress1));
             ReadData2 <= mem(conv_integer(ReadAddress2));
end Behavioral;