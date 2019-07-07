library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
--use ieee.std_logic_unsigned.all;
use work.data_package.all;

entity down_sample is 
   generic
  (                            	   
    data_width             : integer:= 15                                                                            
  ); 
	port
		( 		
		clk           : in    std_logic;
		rst           : in    std_logic;
		i_data        : in    signed(data_width downto 0);
		o_data        :   out data_array
		); 
	
end down_sample;

architecture rtl of down_sample is 
	
	signal cnt         : integer range 0 to 10;
	--type   data_array  is array ( 2 downto 0 ) of signed( 15 downto 0 ); 
	signal f_data      : data_array := ( others => ( others => '0' ) );
	
	
begin 
	
	o_data	 <=	f_data;
	
	process(clk,rst)
	begin
		if( rst='1') then		
			cnt <= 0;
		elsif(clk'event and clk='1') then 
			cnt <=  cnt + 1 ; 
			if ( cnt = 7 ) then 
        cnt <= 0;	
      end if;
		end if;	
	end process;
	
	process(clk,rst)
	begin
		if( rst ='1') then	
			f_data <= ( others => ( others => '0' ) );
		elsif(clk'event and clk='1') then 
			if((cnt = 0) or (cnt = 2) or (cnt = 4) or (cnt = 6) )then
				f_data(0) <=  i_data ;
			end if;
			if((cnt = 0) or (cnt = 4) )then
				f_data(1) <=  i_data ;
			end if;
			if(cnt = 0 )then
				f_data(2) <=  i_data ;
			end if;
		end if;	
	end process;
	
end rtl;