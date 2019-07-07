----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add1 is 	
	port
		( 
		i_clk            : in    std_logic;
		i_rst            : in    std_logic;
		i_data1          : in    signed( 31 downto 0 );
		i_data2          : in    signed( 31 downto 0 );
		o_add            :   out signed( 31 downto 0 )
		);  	
end add1;	

architecture rtl of add1 is 
	
	signal s_add : signed(31 downto 0 );
	
begin 
	
	o_add <= s_add;
	
	process( i_clk, i_rst )
	begin
		if ( i_rst = '1' ) then		
			s_add <=  ( others => '0' ) ; 
		elsif ( rising_edge ( i_clk ) ) then 
			s_add <= i_data1 + i_data2;
		end if;	
	end process;
	
end rtl;	
