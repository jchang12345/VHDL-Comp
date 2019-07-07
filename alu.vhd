--**************************************************************************************************
--
--  
--
--**************************************************************************************************
--  Comprehensive VHDL                  
--  Mumma Radar Lab                 
--  Hamdi Abdelbagi                 
--  ALU homework 
--   9/18/2016
--**************************************************************************************************
--
--  
--
--**************************************************************************************************

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_std.all;

entity ALU is
  port (A    : in    std_logic_vector(7 downto 0);
        B    : in    std_logic_vector(7 downto 0);
        Op   : in    std_logic_vector(3 downto 0);
        F    :   out std_logic_vector(7 downto 0);
        Cout :   out Std_logic;
        Equal:   out Std_logic);
end;

architecture A1 of ALU is

  -- Simple solution...
  -- Easy to read, but relies on resource sharing

  signal Tmp    :   Signed(8 downto 0);
  signal A9     :   Signed(8 downto 0);
  signal B9     :   Signed(8 downto 0);

begin

  A9 <= -- conver to signed and resize (A) to 9 bits
  B9 <= -- conver to signed and resize (B) to 9 bits

  process (A, A9, B9, Op)
  begin
    case Op is
    when "0000" =>
      Tmp <= -- A plus B
    when "0001" =>
      Tmp <= -- A minus B
    when "0010" =>
      Tmp <= -- B minus A
    when "0100" =>
      Tmp <= -- Only A 
    when "0101" =>
      Tmp <= -- Only B
    when "0110" =>
      Tmp <= -- minus A
    when "0111" =>
      Tmp <= -- minus B
    when "1000" =>
      Tmp <= -- Shift left A
    when "1001" =>
      Tmp <= -- Shift right A
    when "1010" =>
      Tmp <= -- Rotate left A
    when "1011" =>
      Tmp <= -- Rotate right A
    when "1110" =>
      Tmp <= -- All Zeros
    when "1111" =>
      Tmp <= -- All Ones
    when others =>
      Tmp <= -- Dummy
    end case;
  end process;

  Equal <= -- check if (A = B) else '0'
  Cout  <= -- asssign carry out of Tmp to Cout
  F     <= -- Assign Tmp to F

end;
