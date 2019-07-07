----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mult1 is 	
	port
		( 
		i_clk            : in    std_logic;
		i_rst            : in    std_logic;
		i_data1          : in    signed( 15 downto 0 );
		i_data2          : in    signed( 15 downto 0 );
		o_mult           :   out signed( 31 downto 0 )
		);  	
end mult1;	

architecture rtl of mult1 is 
	
	signal s_mult : signed(31 downto 0 );
	
begin 
	
	o_mult <= s_mult;
	
	process( i_clk, i_rst )
	begin
		if ( i_rst = '1' ) then		
			s_mult <=  ( others => '0' ) ; 
		elsif ( rising_edge ( i_clk ) ) then 
			s_mult <= i_data1 * i_data2;
		end if;	
	end process;
	
end rtl;	
