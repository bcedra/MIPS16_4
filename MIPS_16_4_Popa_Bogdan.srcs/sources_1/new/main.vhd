library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_1164.all;


entity main is
Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           led : out STD_LOGIC_VECTOR(15 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           sw : in STD_LOGIC_VECTOR(15 downto 0);
           RX: in std_logic;
           TX: out std_logic);
end main;

architecture Behavioral of main is

component MPG is

	    Port ( clock : in STD_LOGIC;
       btn : in STD_LOGIC;
       en : out STD_LOGIC);
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
    en : in std_logic;
          we : in STD_LOGIC;
          reset : in STD_LOGIC;
          branch_adr : in STD_LOGIC_VECTOR (15 downto 0);
          jump_adr : in STD_LOGIC_VECTOR (15 downto 0);
          PCsrc : in STD_LOGIC;
          jmp : in STD_LOGIC;
          instruction : out STD_LOGIC_VECTOR (15 downto 0);
          nextinstruction: out std_logic_vector (15 downto 0));
end component;

component ID is
    Port ( clk : in STD_LOGIC;
           Instruction : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite: in STD_LOGIC;
           RegDst: in STD_LOGIC;
           ExtOp: in STD_LOGIC;
           en: in std_logic;
           ReadData1 : out STD_LOGIC_VECTOR (15 downto 0);
           ReadData2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           SA : out STD_LOGIC;
           Func : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component UC is
    Port(
         Instruction: in std_logic_vector(2 downto 0);
         RegDst: out std_logic;
         RegWrite: out std_logic;
         ExtOp: out std_logic;
         ALUSrc: out std_logic;
         MemtoReg: out std_logic;
         MemWrite: out std_logic;
         Branch: out std_logic;
         Jump: out std_logic);
end component;

component EX is
Port(
	PCOut:in std_logic_vector(15 downto 0);
	RD1: in std_logic_vector(15 downto 0);
	RD2: in std_logic_vector(15 downto 0);
	Ext_Imm: in std_logic_vector(15 downto 0);
	Func: in std_logic_vector(2 downto 0);
	SA: in std_logic;
	ALUSrc: in std_logic;
	ALUOp: in std_logic_vector(2 downto 0);
	BranchAddress: out std_logic_vector(15 downto 0);
	ALURes: out std_logic_vector(15 downto 0);
	ZeroSignal: out std_logic);
end component;

component MEM is
    Port ( clk : in STD_LOGIC;
           aluRes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           mem_write : in STD_LOGIC;
           aluOutput : out STD_LOGIC_VECTOR (15 downto 0);
           memData : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component TX_FSM is
    Port( 
    TX_DATA: in std_logic_vector(7 downto 0);
    TX_EN: in std_logic;
    RESET: in std_logic;
    BAUD_EN: in std_logic;
    TX: out std_logic;
    TX_RDY: out std_logic;
    clk: in std_logic);
end component;

signal digits , DO,ReadData1,ReadData2,Ext_Imm,aluOutput,memData,branch_addr,nextinstruction,jump_addr,WriteData,ALURes,output : STD_LOGIC_VECTOR(15 downto 0);
signal en,RegWrite,RegDst, ExtOp,SA,ZeroSignal,we,jump,PC,PcSrc,MemtoReg,MemWrite,Branch,AlUSrc,reset: STD_LOGIC;
SIGNAL Func,ALUOp : STD_LOGIC_VECTOR (2 downto 0);
--fsm
signal count : std_logic_vector(13 downto 0);
signal baud_enable : std_logic;
signal TX_EN: std_logic;
signal BAUD_EN: std_logic;
--signal TX: std_logic;
signal TX_RDY: std_logic;
-----
begin

--baud
     process (clk)
     begin
      if clk='1' and clk'event then
         if(count="10100010101111") then
             count<="00000000000000";
             baud_enable <='1';
         else
             count<=count+1;
             baud_enable <='0';
         end if;
     end if;
     end process;
----------------

     
     --fsm-----
     process(clk)
     begin
            if BAUD_EN='1' then 
                TX_EN<='0';
            else if clk='1' and clk'event then
                TX_EN<=en;
            end if;
            end if;
     end process;
     ---------

    C1 : MPG port map(clk,btn(0), en);
    C2 : IFF port map(clk,en,we,reset,branch_addr,jump_addr,PcSrc,jump, DO,nextinstruction);
     C3 : SSD port map(clk, output(3 downto 0), output(7 downto 4), output(11 downto 8), output(15 downto 12), cat, an);
     C4: ID port map(clk,DO,WriteData,RegWrite,RegDst, ExtOp,en,ReadData1,ReadData2,Ext_Imm,SA,Func);
     C5: UC port map(DO(15 downto 13),RegDst,RegWrite,ExtOp,AlUSrc,MemtoReg,MemWrite,Branch,jump);
     C6: EX port map(nextinstruction,ReadData1,ReadData2,Ext_Imm,Func,SA,ALUSrc,DO(15 downto 13),branch_addr,ALURes,ZeroSignal);
     C7: MEM port map(clk,ALURes,ReadData2,MemWrite,aluOutput,memData);
     C8: TX_FSM port map(sw(7 downto 0),TX_EN,'0',BAUD_EN,TX,TX_RDY,clk); 
    
    
    
     jump_addr <= "000" & DO(12 downto 0);
     PcSrc<= Branch and ZeroSignal;
     
     process(output)
         begin
         case sw(7 downto 5) is
         when "000" => output <= DO;
         when "001" => output <= nextinstruction;
         when "010" => output <= ReadData1;
         when "011" => output <= ReadData2;
         when "100" => output <= Ext_Imm;
         when "101" => output <= aluOutput;
         when "110" => output <= branch_addr;
         when others => output <= jump_addr;
         end case;
         end process;
end Behavioral;