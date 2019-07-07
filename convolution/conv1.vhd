----------------
-- Hamdi Abdelbagi
-- convlution Example
---------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity conv1 is 	
  port
    (
    i_clk            : in    std_logic;
    i_rst            : in    std_logic;
    i_tx             : in    signed( 15 downto 0 );	
    i_rx             : in    signed( 15 downto 0 );	
    o_conv           :   out signed( 31 downto 0 );
    o_conv_max  		   :   out signed( 31 downto 0 )
    );  	
end conv1;	

architecture rtl of conv1 is 
  
  type   t_rx         is array ( 64 downto 1 ) of signed( 15 downto 0 ); 
  signal s_rx         : t_rx := ( others => ( others => '0' ) );	   
  signal s_tx         : t_rx := ( others => ( others => '0' ) );
  type   t_mult       is array ( 64 downto 1 ) of signed( 31 downto 0 );
  signal s_mult       : t_mult := ( others => ( others => '0' ) );
  type   t_out64      is array (   64 downto 1 ) of signed( 31 downto 0 );
  signal s_out64      : t_out64 := ( others => ( others => '0' ) ); 
  type   t_out32      is array (   32 downto 1 ) of signed( 31 downto 0 );
  signal s_out32      : t_out32 := ( others => ( others => '0' ) );
  type   t_out16      is array (   16 downto 1 ) of signed( 31 downto 0 );
  signal s_out16      : t_out16 := ( others => ( others => '0' ) );   
  type   t_out8       is array (    8 downto 1 ) of signed( 31 downto 0 );
  signal s_out8       : t_out8 := ( others => ( others => '0' ) );										 
  type   t_out4       is array (    4 downto 1 ) of signed( 31 downto 0 );
  signal s_out4       : t_out4 := ( others => ( others => '0' ) );	
  type   t_out2       is array (    2 downto 1 ) of signed( 31 downto 0 );
  signal s_out2       : t_out2 := ( others => ( others => '0' ) );	
  signal s_xcorr1     : signed( 31 downto 0 ); 
  signal xcorr_max    : signed( 31 downto 0 );
  signal cnt_64_z 	   : integer range 0 to 65;
  
  component mult1 is 	
    port
      ( 
      i_clk       : in    std_logic;
      i_rst       : in    std_logic;
      i_data1     : in    signed( 15 downto 0 );
      i_data2     : in    signed( 15 downto 0 );
      o_mult      :   out signed( 31 downto 0 )
      );  	
  end component;
  
  component add1 is 
    port
      ( 
      i_clk       : in    std_logic;
      i_rst       : in    std_logic;
      i_data1     : in    signed( 31 downto 0 );
      i_data2     : in    signed( 31 downto 0 );
      o_add       :   out signed( 31 downto 0 )
      );  	
  end component;
  
begin
  
  o_conv      <= s_xcorr1;
  o_conv_max   <= xcorr_max; 
  
  -- showing the peak value
  max_corr1 : process( i_clk )
  begin 
    if ( rising_edge ( i_clk ) ) then
      if ( i_rst = '1' ) then
        xcorr_max <= ( others => '0' );
      elsif (xcorr_max <= s_xcorr1) then 
        xcorr_max <= s_xcorr1;	
      end if;
    end if;
  end process;
  
  Counter2000 : process( i_clk )
  begin 
    if ( rising_edge ( i_clk ) ) then
      if ( i_rst = '1' ) then
        cnt_64_z <= 1;		
      else 
        cnt_64_z <= cnt_64_z + 1; 
        if ( cnt_64_z = 64 ) then 
          cnt_64_z <= 64;	
        end if;
      end if;
    end if;
  end process;
  
  s_tx11:process( i_clk, i_rst )
  begin
    if( i_rst = '1') then		
      s_tx <= ( others => ( others => '0' ) ); 
    elsif ( rising_edge ( i_clk ) ) then  
      s_tx(cnt_64_z) <= i_tx; 
    end if;	
  end process;
  
  s_rx11:process( i_clk, i_rst )
  begin
    if( i_rst = '1') then		
      s_rx <= ( others => ( others => '0' ) ); 
    elsif ( rising_edge ( i_clk ) ) then  
      s_rx <=  s_rx ( 63 downto 1 ) & i_rx; 
    end if;	
  end process;   
  
  uu3:for i in 1 to 64 generate
    mult_2000 : mult1 
    port map
      (
      i_clk   => i_clk,
      i_rst   => i_rst,
      i_data1 => s_tx( 65 - i ),
      i_data2 => s_rx( i ),
      o_mult  => s_mult(i)
      );
  end generate;
  
  add1000:for i in 1 to 32 generate
    add_64 : add1 
    port map
      (
      i_clk   => i_clk,
      i_rst   => i_rst,
      i_data1 => s_mult(i*2 - 1),
      i_data2 => s_mult(i*2),
      o_add   => s_out64(i)
      );
  end generate;
  
  add32:for i in 1 to 16 generate
    add_32 : add1 
    port map
      (
      i_clk   => i_clk,
      i_rst   => i_rst,
      i_data1 => s_out64(i*2 - 1),
      i_data2 => s_out64(i*2),
      o_add   => s_out32(i)		
      );
  end generate;
  
  add16:for i in 1 to 8 generate
    add_16 : add1 
    port map
      (
      i_clk   => i_clk,
      i_rst   => i_rst,
      i_data1 => s_out32(i*2 - 1),
      i_data2 => s_out32(i*2),
      o_add   => s_out16(i)		
      ); 
  end generate;
  
  add8:for i in 1 to 4 generate
    add_8 : add1 
    port map
      (
      i_clk   => i_clk,
      i_rst   => i_rst,
      i_data1 => s_out16(i*2 - 1),
      i_data2 => s_out16(i*2),
      o_add   => s_out8(i)		
      );
  end generate;
  
  add4:for i in 1 to 2 generate
    add_4 : add1 
    port map
      (
      i_clk   => i_clk,
      i_rst   => i_rst,
      i_data1 => s_out8(i*2 - 1),
      i_data2 => s_out8(i*2),
      o_add   => s_out4(i)		
      );
  end generate;
  
  add_final : add1 
  port map
    (
    i_clk   => i_clk,
    i_rst   => i_rst,
    i_data1 => s_out4(1),
    i_data2 => s_out4(2),
    o_add   => s_xcorr1		
    );
  
end rtl;	