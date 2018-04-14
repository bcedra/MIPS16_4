library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_1164.all;

entity TX_FSM is
    Port( 
    TX_DATA: in std_logic_vector(7 downto 0);
    TX_EN: in std_logic;
    RESET: in std_logic;
    BAUD_EN: in std_logic;
    TX: out std_logic;
    TX_RDY: out std_logic;
    clk: in std_logic);
end TX_FSM;

architecture Behavioral of TX_FSM is
    type state_type is (start, bitt, stop, idle);
    signal state : state_type; 
    signal bit_cnt:STD_LOGIC_VECTOR(2 downto 0):="000";
begin

    process (clk,tx_data, tx_en, reset, baud_en,bit_cnt)
    begin
        if (reset ='1') then
            state <=idle;
            bit_cnt<="000";
        elsif (clk='1' and clk'event) then 
            if baud_en='1' then
                case state is
                    when idle => if tx_en='1' then state <= start;end if;
                    when start => if bit_cnt<7 then 
                                    bit_cnt<=bit_cnt+1;
                        else 
                            state<=bitt;
                        end if;
                    
                    
                    when bitt => if bit_cnt=7 then state <= stop;bit_cnt<="000"; end if;
                    when stop => state <= idle;
                end case;
            end if;
        end if;
    end process;
    
    process (state)
    begin
            case state is
                when idle => tx<='1'; tx_rdy<='0';
                when start => tx<='0'; tx_rdy<='0';
                when bitt => tx<=tx_data(conv_integer(bit_cnt)); tx_rdy<='0';
                when stop => tx<='1'; tx_rdy<='1';
            end case;
    end process;


end Behavioral;