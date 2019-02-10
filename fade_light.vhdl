library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fade_light is
	generic( n_bit : integer := 12);
	port( 	clk : in std_logic;
		 	rst : in std_logic;
		  	led : out std_logic_vector(2 downto 0)
		 );
end entity;

architecture fade of fade_light is
	signal div_clk : std_logic;
	signal div_counter : integer;
	signal counter : integer;
	signal fade_timer : integer;
	signal fade : integer := 1;
	signal sign : integer := 1;
	signal led_switch : std_logic_vector(2 downto 0) := "000";

begin

	clk_divider : process(clk)
	begin
		if (rising_edge(clk)) then
			div_counter <= div_counter + 1;
			
			if( div_counter = 2400) then
				div_counter <= 0;
				div_clk <= not div_clk;
			end if;
		end if;		
	end process;
	
	pwm : process(div_clk)
	begin
		if (rising_edge(div_clk)) then			
			
			if(counter = 32) then
				counter <= 0;
			else
				counter <= counter + 1;
			end if;

			if(fade_timer = 100) then
				--if(led_switch = "111") then
				--	led_switch <= "000";
				--else
				--	led_switch <=  std_logic_vector ( unsigned ( led_switch ) + 1 );
				--end if;

				fade_timer <= 0;
				fade <=  fade + sign;
			else
				fade_timer <= fade_timer + 1;
			end if;

			if(fade = 32) then
				sign <= (-1);
			elsif(fade = 0) then
				sign <= 1;
			end if;

			if(counter > fade) then
				led <= led_switch;
			else
				led <= "111";
			end if;	
		end if;	
	end process;	


end fade;