library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
    Port(
         Instruction: in std_logic_vector(2 downto 0);
         RegDst: out std_logic;--selecteaza adresa de scriere in rf
         RegWrite: out std_logic;--activarea scrierii in rf
         ExtOp: out std_logic;-- selecteaza tipul de extensie pentru câmpul immediat: cu zero sau cu semn
         ALUSrc: out std_logic;
         MemtoReg: out std_logic; -- selecteaza ce valoare se va scrie înapoi în blocul de regi?trii RF din unitatea ID
         MemWrite: out std_logic;
         Branch: out std_logic;
         Jump: out std_logic);
end UC;

architecture Behavioral of UC is
begin
  process(Instruction)
  begin
  RegDst<='0';
  RegWrite<='0';
  ExtOp<='0';
  ALUSrc<='0';
  MemtoReg<='0';
  MemWrite<='0';
  Branch<='0';
  Jump<='0';
  
      case (Instruction) is
         -- instr de tip R
           when "000" =>
           RegDst <= '1';
           RegWrite <= '1';
            -- addi
           when "001" =>
           ExtOp <= '1';
           ALUSrc <= '1';
           RegWrite <= '1';
           -- lw
           when "010" => 
           ExtOp <= '1';
           ALUSrc <= '1';
           MemtoReg <= '1';
           RegWrite <= '1';
           -- sw
           when "011" =>
           RegDst <= '0';
           ExtOp <= '1';
           ALUSrc <= '1';
           MemWrite <= '1';
           MemtoReg <= '0';
           -- beq        
           when "100" => 
           RegDst <= '0';
           ExtOp <= '1';
           Branch <= '1';
           MemtoReg <= '0';
           -- andi
           when "101" => 
           ExtOp <= '1';
           ALUSrc <= '1';
           RegWrite <= '1';
           -- ori
           when "110" => 
           ExtOp <= '1';
           ALUSrc <= '1';
           RegWrite <= '1';
            -- jump
           when "111" =>
           RegDst <= '0';
           ExtOp <= '1';
           ALUSrc <= '1';
           Jump <= '1';
           MemtoReg <= '0';        
       end case;
  end process;

end Behavioral;