library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EX is
Port(
	PCOut:in std_logic_vector(15 downto 0);
	RD1: in std_logic_vector(15 downto 0);
	RD2: in std_logic_vector(15 downto 0);
	Ext_Imm: in std_logic_vector(15 downto 0);--Imediatul extins
	Func: in std_logic_vector(2 downto 0);--Câmpul func
	SA: in std_logic;--Câmpul sa
	ALUSrc: in std_logic;--selec?ie între Read Data 2 ?i Ext_Imm pentru intrarea a doua din ALU 
	ALUOp: in std_logic_vector(2 downto 0); --codul pentru opera?ia ALU furnizat de unitatea principal? de control UC 
	BranchAddress: out std_logic_vector(15 downto 0);--Adresa de salt Branch Address,
	ALURes: out std_logic_vector(15 downto 0);--Rezultatul ALURes
	ZeroSignal: out std_logic);--Semnalul Zero de 1 bit 
end EX;

architecture Behavioral of EX is

signal AluIn2:std_logic_vector(15 downto 0);
signal ALUControl: std_logic_vector(3 downto 0);
signal ALUResAux:std_logic_vector(15 downto 0);
signal ZeroAux: std_logic;

begin

BranchAddress<=PCOut+Ext_Imm;

with ALUSrc select
	AluIn2<=RD2 when '0',
			  Ext_Imm when others;
			  
process(ALUOp,Func)
begin
	case (ALUOp) is
		when "000"=>
				case (Func) is
					when "000"=> ALUControl<="0000"; 	--ADD
					when "001"=> ALUControl<="0001";		--SUB
					when "010"=> ALUControl<="0010";		--SLL
					when "011"=> ALUControl<="0011";		--SRL
					when "100"=> ALUControl<="0100";		--AND
					when "101"=> ALUControl<="0101";		--OR
				    when "111"=> ALUControl<="0110";		--NOR
					when "110"=> ALUControl<="0111";		--XOR
					when others=> ALUControl<="0000";	
				end case;
		when "001"=> ALUControl<="1000";		--ADDI
		when "010"=> ALUControl<="1001";		--lw
		when "011"=> ALUControl<="1010";        --sw
		when "100"=> ALUControl<="1011";        --beq
		when "101"=> ALUControl<="1100";		--ANDI
		when "110"=> ALUControl<="1101";		--ORI
		when "111"=> ALUControl<="1111";		--JUMP
		when others=> ALUControl<="0000";	
	end case;
end process;

process(ALUControl,RD1,AluIn2,SA)
begin
	case(ALUControl) is
		when "0000" => ALUResAux<=RD1+AluIn2;   --ADD			
		when "0001" => ALUResAux<=RD1-AluIn2;	  --SUB						
		when "0010" => 				--SLL
					case (SA) is
						when '1' => ALUResAux<=RD1(14 downto 0) & "0";
						when others => ALUResAux<=RD1;	
					end case;
		when "0011" => 				--SRL
					case (SA) is
						when '1' => ALUResAux<="0" & RD1(15 downto 1);
						when others => ALUResAux<=RD1;
					end case;						
		when "0100" => ALUResAux<=RD1 and AluIn2;		--AND						
		when "0101" => ALUResAux<=RD1 or AluIn2;		--OR								
		when "0110" => ALUResAux<=RD1 xnor AluIn2;		--XNOR					
		when "0111" => ALUResAux<=RD1 xor AluIn2; --xor
		when "1000" => ALUResAux<=AluIn2+RD1; --addi
		when "1001" => ALUResAux<=AluIn2+RD1; --lw
		when "1010" => ALUResAux<=AluIn2+RD1; --sw
		when "1011" => ALUResAux<=AluIn2-RD1; --beq
		when "1100" => ALUResAux<=AluIn2 and RD1; --andi
		when "1101" => ALUResAux<=AluIn2 or RD1; --ori			
		when "1111" => ALUResAux<=X"0000";		--JUMP		
		when others => ALUResAUx<=X"0000";		
	end case;

	case (ALUResAux) is					--ZERO SIGNAL
		when X"0000" => ZeroAux<='1';
		when others => ZeroAux<='0';
	end case;

end process;

ZeroSignal<=ZeroAux;			--ZERO_OUT
ALURes<=ALUResAux;			--ALU_OUT

end Behavioral;