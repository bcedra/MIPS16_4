library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
    Port ( clk : in STD_LOGIC;
           aluRes : in STD_LOGIC_VECTOR (15 downto 0);--furnizeaza adresa pentru memorie (are efect doar pentru load sau store word)
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);--- a doua ie?ire din blocul de regi?trii RF (doar pentru instruc?iunea store word) care merge pe câmpul Write Data (portul de scriere) al memoriei
           mem_write : in STD_LOGIC;
           aluOutput : out STD_LOGIC_VECTOR (15 downto 0);--, acest semnal reprezint? de asemenea rezultatul opera?iilor aritmetico-logice, care trebuie stocat în blocul de regi?trii, deci trebuie furnizat la ie?irea unit??ii MEM ca intrare pentru unitatea urm?toare, WB

           memData : out STD_LOGIC_VECTOR (15 downto 0));-- reprezint? datele de pe portul de citire Read Data al memoriei de date (doar pentru instruc?iunea load word)

end MEM;

architecture Behavioral of MEM is
type memory is array(0 to 255) of std_logic_vector(15 downto 0);
signal ram : memory:=(others=>x"1234");
begin

aluOutput <= aluRes;

process(clk)
begin
  if clk'event and clk='1' then 
    if mem_write = '1' then --Valoarea din semnalul RD2 este scris? la adresa de memorie indicat? de valoarea semnalului ALURess
       ram(conv_integer(aluRes)) <= rd2;
       end if; --if memwrite = 0 Nu se scrie nimic în memoria de date
       end if;
end process;
memData <= ram(conv_integer(aluRes));       

end Behavioral;
