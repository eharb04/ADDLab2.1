----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use work.scopeToHdmi_package.all;

entity scopeToHdmi is
    PORT ( sysClk : in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         btn: in STD_LOGIC_VECTOR(2 downto 0);
         tmdsDataP : out  STD_LOGIC_VECTOR (2 downto 0);
         tmdsDataN : out  STD_LOGIC_VECTOR (2 downto 0);
         tmdsClkP : out STD_LOGIC;
         tmdsClkN : out STD_LOGIC;
         hdmiOen:    out STD_LOGIC);
end scopeToHdmi;


architecture structure of scopeToHdmi is


    signal red, green, blue: STD_LOGIC_VECTOR(7 downto 0);

    signal triggerTime, triggerVolt: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
    signal pixelHorz, pixelVert: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
	    
    signal ch1Wave, ch2Wave: STD_LOGIC;

    signal videoClk, videoClk5x, clkLocked: STD_LOGIC;
    
    signal hs, vs, de: STD_LOGIC; --Intermediate
    signal reset: STD_LOGIC;
    signal prevButton, currButton, activeButton: STD_LOGIC_VECTOR(2 downto 0);

begin


    vsg: videoSignalGenerator
        PORT MAP (clk => videoClk, 
                  resetn => resetn,
                  hs => hs,
                  vs => vs,
                  de => de,
                  pixelHorz => pixelHorz,
                  pixelVert => pixelVert);
                 

    sf: scopeFace
        PORT MAP (clk => videoClk,
                  resetn => resetn,
                  pixelHorz => pixelHorz,
                  pixelVert => pixelVert,
                  triggerVolt => triggerVolt,
                  triggerTime => triggerTime,
                  red => red,
                  green => green,
                  blue => blue,
                  ch1 => ch1Wave,
                  ch1Enb => '1',
                  ch2 => ch1Wave,
                  ch2Enb => '1');
                 

    hdmi_inst: hdmi_tx_0
        PORT MAP (
            pix_clk => videoClk,
            pix_clkx5 => videoClk5x,
            rst => reset,
            hsync => hs,
            vsync => vs,
            vde => de,
            pix_clk_locked => clkLocked,
            red => red,
            green => green,
            blue => blue,
            TMDS_DATA_P => tmdsDataP,
            TMDS_DATA_N => tmdsDataN,
            TMDS_CLK_P => tmdsClkP,
            TMDS_CLK_N => tmdsClkN,
            aux0_din => "0000",
            aux1_din => "0000",
            aux2_din => "0000",
            ade => '0'
            );
            

    vc: clk_wiz_0
	PORT MAP( 
	    clk_out1 => videoClk,
	    clk_out2 => videoClk5x,
	    resetn => resetn,
	    locked => clkLocked,
	    clk_in1 => sysClk);

    ------------------------------------------------------------------------------
    -- Create a process which generates a 3-bit vector which shows if button
    -- has change state.  Use this change vector to determine if you should 
    -- increment/decrement the triggerTime or triggerVolt values
    ------------------------------------------------------------------------------
 
    process(sysclk)
    begin
        if rising_edge (sysclk) then
            currButton <= btn; --Button values taken on clk edge
            activeButton <= currButton xor prevButton; --To see change
            if resetn = '0' then
                activeButton <= "000";
                prevButton <= "111"; --Assume prev was not pressed
                currButton <= "111"; --Active Low, so set to not being pressed
                triggerTime <= STD_LOGIC_VECTOR(TO_UNSIGNED(500, VIDEO_WIDTH_IN_BITS)); --Somewhere around the middle
                triggerVolt <= STD_LOGIC_VECTOR(TO_UNSIGNED(300, VIDEO_WIDTH_IN_BITS)); 
            elsif activeButton > 0 then --Something has changed state
                if (activeButton(0) = '1' and currButton(0) = '1') then --PL_KEY4 changed to being released
                    if (currButton(2) = '1' and triggerTime > 0) then --PL_KEY2 is not being pressed
                        triggerTime <= triggerTime - 10;
                    elsif (currButton(2) = '0' and triggerTime < 1279) then --PL_KEY2 is being pressed
                        triggerTime <= triggerTime + 10;
                    end if;
                end if;
                
                if (activeButton(1) = '1' and currButton(1) = '1') then --PL_KEY3 changed to being released
                    if (currButton(2) = '1' and triggerVolt > 0) then --PL_KEY2 is not being pressed
                        triggerVolt <= triggerVolt - 10;
                    elsif (currButton(2) = '0' and triggerVolt < 719) then --PL_KEY2 is being pressed
                        triggerVolt <= triggerVolt + 10;
                    end if;
                end if;
            end if;
            prevButton <= currButton;
        end if;
    end process;
 
    reset <= not resetn;
    ch1Wave <= '1' when  (pixelHorz = pixelVert) else '0';
    ch2Wave <= '1' when  (pixelVert = triggerVolt) else '0';
    hdmiOen <= '1';

end structure;
