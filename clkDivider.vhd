library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Timer is
  port (
    i_clock      : in  std_logic;
    i_switch_1   : in  std_logic;
    i_switch_2   : in  std_logic;
    o_led_drive  : out std_logic
    );
end Timer;
 
architecture behave of Timer is
 
  -- Constants to create the frequencies needed:
  -- Formula is: (50 MHz / 100 Hz * 50% duty cycle)
  -- So for 100 Hz: 50,000,000 / 100 * 0.5
  constant c_CNT_100HZ : natural := 250000; --constant - константа, переменная, ногда нужен последовательный код
  constant c_CNT_50HZ  : natural := 500000;
  constant c_CNT_10HZ  : natural := 2500000;
  constant c_CNT_1HZ   : natural := 25000000;
 
 
  -- These signals will be the counters:
  signal r_CNT_100HZ : natural range 0 to c_CNT_100HZ; --signal, записывается как <=, ограничиваем размер integer
  signal r_CNT_50HZ  : natural range 0 to c_CNT_50HZ;
  signal r_CNT_10HZ  : natural range 0 to c_CNT_10HZ;
  signal r_CNT_1HZ   : natural range 0 to c_CNT_1HZ;
   
  -- These signals will toggle at the frequencies needed:
  signal r_TOGGLE_100HZ : std_logic := '0'; --записываются битом, std_logic - бит
  signal r_TOGGLE_50HZ  : std_logic := '0';
  signal r_TOGGLE_10HZ  : std_logic := '0';
  signal r_TOGGLE_1HZ   : std_logic := '0';
 
  -- One bit select wire.
  signal w_LED_SELECT : std_logic; --выбор счёта частоты
   
begin
 
  -- All processes toggle a specific signal at a different frequency.
  -- They all run continuously even if the switches are
  -- not selecting their particular output.
  
  p_100HZ : process (i_clock) is
  begin
	if i_clock'event and i_clock = '1' then
	  if r_CNT_100HZ = c_CNT_100HZ-1 then --есть таймер равен 250000-1, то...
		r_TOGGLE_100HZ 	<= not r_TOGGLE_100HZ; --записываем флаг, что условие сработало
		r_CNT_100HZ 	<= 0; --зануляем счётчик
	  else
		r_CNT_100HZ <= r_CNT_100HZ + 1; --прибавляем единичку к счётчику
	  end if;
	end if;
  end process p_100HZ;
--  
--  p_100_HZ : process (i_clock) is
--  begin
--    if rising_edge(i_clock) then
--      if r_CNT_100HZ = c_CNT_100HZ-1 then  -- -1, since counter starts at 0
--        r_TOGGLE_100HZ <= not r_TOGGLE_100HZ;
--        r_CNT_100HZ    <= 0;
--      else
--        r_CNT_100HZ <= r_CNT_100HZ + 1;
--      end if;
--    end if;
--  end process p_100_HZ;
 
 
  p_50_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_CNT_50HZ = c_CNT_50HZ-1 then  -- -1, since counter starts at 0
        r_TOGGLE_50HZ <= not r_TOGGLE_50HZ;
        r_CNT_50HZ    <= 0;
      else
        r_CNT_50HZ <= r_CNT_50HZ + 1;
      end if;
    end if;
  end process p_50_HZ;
 
   
  p_10_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_CNT_10HZ = c_CNT_10HZ-1 then  -- -1, since counter starts at 0
        r_TOGGLE_10HZ <= not r_TOGGLE_10HZ;
        r_CNT_10HZ    <= 0;
      else
        r_CNT_10HZ <= r_CNT_10HZ + 1;
      end if;
    end if;
  end process p_10_HZ;
 
   
  p_1_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_CNT_1HZ = c_CNT_1HZ-1 then  -- -1, since counter starts at 0
        r_TOGGLE_1HZ <= not r_TOGGLE_1HZ;
        r_CNT_1HZ    <= 0;
      else
        r_CNT_1HZ <= r_CNT_1HZ + 1;
      end if;
    end if;
  end process p_1_HZ;
 
   --делаем выбор, что мы пускаем на выход таймера, если 00, то 100гц, 01 - 50гц, 10 - 10гц, 11 - 1 гц
  -- Create a multiplexor based on switch inputs
  w_LED_SELECT <= r_TOGGLE_100HZ when (i_switch_1 = '0' and i_switch_2 = '0') else
                  r_TOGGLE_50HZ  when (i_switch_1 = '0' and i_switch_2 = '1') else
                  r_TOGGLE_10HZ  when (i_switch_1 = '1' and i_switch_2 = '0') else
                  r_TOGGLE_1HZ;
 
   
  -- Only allow o_led_drive to drive when i_enable is high (and gate).
  o_led_drive <= w_LED_SELECT;
 
end behave;
