--**************************************************************************************************
--
--  
--
--**************************************************************************************************
--  Comprehensive VHDL                  
--  Mumma Radar Lab                 
--  Hamdi Abdelbagi                 
--  Rotator 
--   09/10/2016
--**************************************************************************************************
--
--  
--
--**************************************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Rotator is
  port (
        RotateLeft : in  STD_LOGIC;
        Enable     : in  STD_LOGIC;
        N          : in  STD_LOGIC_VECTOR (1 downto 0); -- number of rotations 
        DIn        : in  STD_LOGIC_VECTOR (3 downto 0);
        DOut       : out STD_LOGIC_VECTOR (3 downto 0));
end;

architecture RTL of Rotator is

begin

    Rotate_proc: process(DIn, RotateLeft, Enable, N) is
    begin
      DOut <= DIn;
      if Enable = '1' then
        if RotateLeft = '1' then
          case N is
          when "00" =>
            DOut <= DIn;
          when "01" =>
            DOut <= DIn(2 downto 0) & DIn(3);
          when "10" =>
            DOut <= DIn(1 downto 0) & DIn(3 downto 2);
          when "11" =>
            DOut <= DIn(0) & DIn(3 downto 1);
          when others =>
            DOut <= "XXXX";
          end case;
        else
          case N is
          when "00" =>
            DOut <= DIn;
          when "01" =>
            DOut <= DIn(0) & DIn(3 downto 1);
          when "10" =>
            DOut <= DIn(1 downto 0) & DIn(3 downto 2);
          when "11" =>
            DOut <= DIn(2 downto 0) & DIn(3);
          when others =>
            DOut <= "XXXX";
          end case;
        end if;
      end if;
    end process Rotate_proc;

end;
