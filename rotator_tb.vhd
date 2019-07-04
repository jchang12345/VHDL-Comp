--**************************************************************************************************
--
--  
--
--**************************************************************************************************
--  Comprehensive VHDL                  
--  Mumma Radar Lab                 
--  Hamdi Abdelbagi                 
--  Rotator TB
--   09/10/2016
--**************************************************************************************************
--
--  
--
--**************************************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Rotator_TB is
end;

architecture Bench of Rotator_TB is

  signal DIn, DOut : STD_LOGIC_VECTOR(3 downto 0);
  signal N : STD_LOGIC_VECTOR(1 downto 0);
  signal Enable, RotateLeft : STD_LOGIC;
  signal OK : BOOLEAN;

begin

  UUT: entity work.Rotator(RTL)
     port map ( RotateLeft => RotateLeft,
                N => N,
                Enable => Enable,
                DIn    => DIn,
                DOut => DOut);

   test_proc: process is
   begin
     Enable <= '0';
     N <= "00";
     RotateLeft <= '0';
     DIn <= "0000";
     OK <= TRUE;

     -- nothing enabled
     -- all these tests should return DOut = DIn
     wait for 10 ns;
     if DOut /= DIn then
       OK <= FALSE;
     end if;

     DIn <= "0001";
     wait for 10 ns;
     if DOut /= DIn then
       OK <= FALSE;
     end if;

     DIn <= "0010";
     wait for 10 ns;
     if DOut /= DIn then
       OK <= FALSE;
     end if;

     DIn <= "0110";
     wait for 10 ns;
     if DOut /= DIn then
       OK <= FALSE;
     end if;

     DIn <= "1111";
     wait for 10 ns;
     if DOut /= DIn then
       OK <= FALSE;
     end if;

     -- enable with rotate left
    Enable <= '1';
    DIn <= "0001";
    RotateLeft <= '1';
    N <= "00";
    wait for 10 ns;
    if DOut /= DIn then
      OK <= FALSE;
    end if;


    N <= "01";
    wait for 10 ns;
    if DOut /= "0010" then
      OK <= FALSE;
    end if;

    N <= "10";
    wait for 10 ns;
    if DOut /= "0100" then
      OK <= FALSE;
    end if;

    N <= "11";
    wait for 10 ns;
    if DOut /= "1000" then
      OK <= FALSE;
    end if;


     -- enable with rotate right
    RotateLeft <= '0';
    N <= "00";
    wait for 10 ns;
    if DOut /= DIn then
      OK <= FALSE;
    end if;


    N <= "01";
    wait for 10 ns;
    if DOut /= "1000" then
      OK <= FALSE;
    end if;

    N <= "10";
    wait for 10 ns;
    if DOut /= "0100" then
      OK <= FALSE;
    end if;

    N <= "11";
    wait for 10 ns;
    if DOut /= "0010" then
      OK <= FALSE;
    end if;



    -- end of test, suspend forever
    wait;
  end process test_proc;

end;
