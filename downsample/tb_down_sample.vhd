-- Hamdi Abdelbagi 
-- Down Sampling TB
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use std.textio.all;	 
use std.standard.all;
use work.data_package.all;

entity tb_down_sample is
end;

architecture bench of tb_down_sample is
  
  component down_sample is 
  generic
  (                            	   
    data_width             : integer:= 15                                                                            
  ); 
	port
		( 		
		clk           : in    std_logic;
		rst           : in    std_logic;
		i_data        : in    signed(15 downto 0);
		o_data        :   out data_array
		); 
	
end component;


  signal i_data    		 : signed( 15 downto 0 ):=( others => '0' );
  signal i_clk     		 : std_logic := '1';
  signal i_rst     		 : std_logic := '0';
  signal o_data   		  : data_array ;  
  
begin
  
  uut: down_sample
  generic map 
  (                            
    data_width		  => 15 
    ) 
  port map 
    ( 				  
    clk         => i_clk,
    rst         => i_rst,
    i_data	     => i_data,
    o_data      => o_data
    );
    

  i_clk   <= not i_clk after 5 ns;  --clocking                      
  
  rest1 : process   -- the rest values                            
  begin                                 
    i_rst <= '1';                     
    wait for 20 ns;                   
    i_rst <= '0';                     
    wait;                             
  end process;
  
 stimulus1: process is
		file F 			       : text open read_mode is "data.txt";
		variable l       : line;
		variable i0      : integer;
		variable i00     : integer:= 0;
		variable space   : string (1 to 3);
	begin
		
		while not endfile(F) loop		
			readline(F,l);
			read(l,i00);
			wait until rising_edge(i_clk);
			i_data <= to_signed(i00,16);
		end loop;
		
		wait;
	end process; 
 
  stimulus2: process is
    file file1	    : text open WRITE_MODE is "ds2.txt";
    variable L1    : line;
    variable han0  : integer;
    variable han1  : integer;
    variable space : string (1 to 5);
  begin		
    wait until rising_edge(i_clk) ; 
    han0 :=  to_integer(o_data(0)); 		
    write(L1,han0); 
    writeline(file1 , L1);		
  end process;
  
  stimulus3: process is
    file file1	    : text open WRITE_MODE is "ds4.txt";
    variable L1    : line;
    variable han0  : integer;
    variable han1  : integer;
    variable space : string (1 to 5);
  begin		
    wait until rising_edge(i_clk) ; 
    han0 :=  to_integer(o_data(1)); 		
    write(L1,han0); 
    writeline(file1 , L1);		
  end process;
  
  stimulus4: process is
    file file1	    : text open WRITE_MODE is "ds8.txt";
    variable L1    : line;
    variable han0  : integer;
    variable han1  : integer;
    variable space : string (1 to 5);
  begin		
    wait until rising_edge(i_clk) ; 
    han0 :=  to_integer(o_data(2)); 		
    write(L1,han0); 
    writeline(file1 , L1);		
  end process; 
  
end;

