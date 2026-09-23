----------------------------------------------------------------------------------
-- Include proper comment header block
-- ***Do not use mod operator in this code***
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.scopeToHdmi_package.all;

entity scopeFace is
    PORT ( 	clk: in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         pixelHorz : in  STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
         pixelVert : in  STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS -1 downto 0);
         triggerVolt: in STD_LOGIC_VECTOR (VIDEO_WIDTH_IN_BITS - 1 downto 0);
         triggerTime: in STD_LOGIC_VECTOR (VIDEO_WIDTH_IN_BITS - 1 downto 0);
         red : out  STD_LOGIC_VECTOR(7 downto 0);
         green : out  STD_LOGIC_VECTOR(7 downto 0);
         blue : out  STD_LOGIC_VECTOR(7 downto 0);
         ch1: in STD_LOGIC;
         ch1Enb: in STD_LOGIC;
         ch2: in STD_LOGIC;
         ch2Enb: in STD_LOGIC);
end scopeFace;


architecture Behavioral of scopeFace is

    -- Set these signals to '1' when the features should be drawn at the current pixelHorz, pixelVert 
    -- cordinate.  These act like Feature Booleans which you will use in the process(clk) to set the 
    -- correct RGB for this pixel location. Finish and add more.
    signal borderH, borderV : STD_LOGIC;
    signal gridH, gridV : STD_LOGIC;
    signal triggerTimeMarker, triggerVoltMarker : STD_LOGIC;
    signal hatchH, hatchV: STD_LOGIC;
    signal triggerVoltLevel: STD_LOGIC;
    



begin


    ---------------------------------------------------------------------
    -- Use the Feature Booleans to set the RGB at this pixel location.
    -- The waveforms should sit "on top" of the grid.
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then
                red <= (others => '0');
                green <= (others => '0');
                blue <= (others => '0');
            else
                if ((borderH = '1') or (borderV = '1')) then
                    red <= BORDER_R;
                    green <= BORDER_G;
                    blue <= BORDER_B;
                elsif ((gridV = '1') or (gridH = '1')) then
                    red <= GRID_R;
                    green <= GRID_G;
                    blue <= GRID_B;
                elsif ((hatchH = '1') or (hatchV = '1')) then --blue
                    red <= GRID_R;
                    green <= GRID_G;
                    blue <= GRID_B;
                elsif (triggerVoltLevel = '1') then --Green
                    red <= TRIGGER_R;
                    green <= TRIGGER_G;
                    blue <= TRIGGER_B;
                elsif (ch1 = '1' and ch1Enb = '1') then -- Channel 1 input, red
                    red <= CH1_R;
                    green <= CH1_G;
                    blue <= CH1_B;
                elsif (ch2 = '1' and ch2Enb = '1') then -- Channel 2 input, yellow
                    red <= CH2_R;
                    green <= CH2_G;
                    blue <= CH2_B;
                elsif (triggerTimeMarker = '1' or triggerVoltMarker = '1') then
                    red <= BORDER_R;
                    green <= BORDER_G;
                    blue <= BORDER_B;
                else
                    red <= X"00";
                    green <= X"00";
                    blue <= X"00";
                end if;
            end if;
        end if;
    end process;

    borderH <=	'1' when ((pixelHorz > L_EDGE - BORDER_LINE_WIDTH) and
                         (pixelHorz < R_EDGE + BORDER_LINE_WIDTH)) and --Horizontal bounds
                         (((pixelVert < B_EDGE - BORDER_LINE_WIDTH) and
                         (pixelVert > B_EDGE + BORDER_LINE_WIDTH)) or --Bottom border
                         ((pixelVert < T_EDGE - BORDER_LINE_WIDTH) and
                         (pixelVert > T_EDGE + BORDER_LINE_WIDTH))) --Top border
                         else '0';
    borderV <=	'1' when ((pixelVert > T_EDGE - BORDER_LINE_WIDTH) and
                         (pixelVert < B_EDGE + BORDER_LINE_WIDTH)) and --Horizontal bounds
                         (((pixelHorz < L_EDGE + BORDER_LINE_WIDTH) and
                         (pixelHorz > L_EDGE - BORDER_LINE_WIDTH)) or --Bottom border
                         ((pixelHorz < R_EDGE + BORDER_LINE_WIDTH) and
                         (pixelHorz > R_EDGE - BORDER_LINE_WIDTH))) --Top border
                         else '0';
                         
gridH <= '1' when (((pixelHorz > L_EDGE + BORDER_LINE_WIDTH) and
				pixelHorz < R_EDGE - BORDER_LINE_WIDTH)) and(
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 60 or
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 120 or
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 180 or
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 240 or
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 300 or
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 360 or
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 420 or
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 480 or
				pixelVert = T_EDGE + BORDER_LINE_WIDTH + 540) else '0';
gridV <= '1' when (((pixelVert > T_EDGE + BORDER_LINE_WIDTH) and
				pixelVert < T_EDGE - BORDER_LINE_WIDTH)) and(
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 100 or
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 200 or
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 300 or
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 400 or
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 500 or
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 600 or
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 700 or
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 800 or
				pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 900) else '0';

                    
triggerTimeMarker <= '1' when (
				((pixelVert = (T_EDGE + 1) or
				pixelVert = (T_EDGE + 2) ) and
				(pixelHorz > (triggerTime - std_logic_vector(to_unsigned(5, VIDEO_WIDTH_IN_BITS))) and
				pixelHorz < (triggerTime + std_logic_vector(to_unsigned(5, VIDEO_WIDTH_IN_BITS))))) or 
				((pixelVert = (T_EDGE + 3) or
				pixelVert = (T_EDGE + 4) ) and
				(pixelHorz > (triggerTime - std_logic_vector(to_unsigned(4, VIDEO_WIDTH_IN_BITS))) and
				pixelHorz < (triggerTime + std_logic_vector(to_unsigned(4, VIDEO_WIDTH_IN_BITS))))) or 
				((pixelVert = (T_EDGE + 5) or
				pixelVert = (T_EDGE + 6) ) and
				(pixelHorz > (triggerTime - std_logic_vector(to_unsigned(3, VIDEO_WIDTH_IN_BITS))) and
				pixelHorz < (triggerTime + std_logic_vector(to_unsigned(3, VIDEO_WIDTH_IN_BITS))))) or 
				((pixelVert = (T_EDGE + 7) or
				pixelVert = (T_EDGE + 8) ) and
				(pixelHorz > (triggerTime - std_logic_vector(to_unsigned(2, VIDEO_WIDTH_IN_BITS))) and
				pixelHorz < (triggerTime + std_logic_vector(to_unsigned(2, VIDEO_WIDTH_IN_BITS))))) or 
				((pixelVert = (T_EDGE + 9) or
				pixelVert = (T_EDGE + 10)) and
				pixelHorz = triggerTime)) else '0';
triggerVoltMarker <= '1' when (
				((pixelHorz = (L_EDGE + 1) or
				pixelHorz = (L_EDGE + 2) ) and
				(pixelVert > (triggerVolt - std_logic_vector(to_unsigned(5, VIDEO_WIDTH_IN_BITS))) and
				pixelVert < (triggerVolt + std_logic_vector(to_unsigned(5, VIDEO_WIDTH_IN_BITS))))) or 
				((pixelHorz = (L_EDGE + 3) or
				pixelHorz = (L_EDGE + 4) ) and
				(pixelVert > (triggerVolt - std_logic_vector(to_unsigned(4, VIDEO_WIDTH_IN_BITS))) and
				pixelVert < (triggerVolt + std_logic_vector(to_unsigned(4, VIDEO_WIDTH_IN_BITS))))) or 
				((pixelHorz = (L_EDGE + 5) or
				pixelHorz = (L_EDGE + 6) ) and
				(pixelVert > (triggerVolt - std_logic_vector(to_unsigned(3, VIDEO_WIDTH_IN_BITS))) and
				pixelVert < (triggerVolt + std_logic_vector(to_unsigned(3, VIDEO_WIDTH_IN_BITS))))) or 
				((pixelHorz = (L_EDGE + 7) or
				pixelHorz = (L_EDGE + 8) ) and
				(pixelVert > (triggerVolt - std_logic_vector(to_unsigned(2, VIDEO_WIDTH_IN_BITS))) and
				pixelVert < (triggerVolt + std_logic_vector(to_unsigned(2, VIDEO_WIDTH_IN_BITS))))) or 
				((pixelHorz = (L_EDGE +9) or
				pixelHorz = (L_EDGE +10)) and
				pixelVert = triggerVolt)) else '0';


    
    triggerVoltLevel <= '1' when (pixelVert = triggerVolt) and --Height of level
                                 ((pixelHorz > L_EDGE + BORDER_LINE_WIDTH) and --Stay within horizontal frame
                                 (pixelHorz < R_EDGE - BORDER_LINE_WIDTH))
                                 else '0';                         
                         
                        
hatchH <=	'1' when (
						(pixelVert > T_EDGE + BORDER_LINE_WIDTH + 295) and --Upper and lower bounds
						(pixelVert < T_EDGE + BORDER_LINE_WIDTH + 305)
						) and (
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 20) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 40) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 60) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 80) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 100) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 120) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 140) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 160) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 180) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 200) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 220) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 240) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 260) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 280) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 300) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 320) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 340) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 360) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 380) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 400) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 420) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 440) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 460) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 480) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 500) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 520) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 540) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 560) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 580) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 600) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 620) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 640) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 660) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 680) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 700) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 720) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 740) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 760) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 780) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 800) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 820) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 840) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 860) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 880) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 900) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 920) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 940) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 960) or
						(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 980) --Each individual hatch
						)
						 else '0';
hatchV <=	'1' when (
						(pixelHorz > L_EDGE + BORDER_LINE_WIDTH + 495) and --Left and right bounds
						(pixelHorz < L_EDGE + BORDER_LINE_WIDTH + 505)
						) and (
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 12) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 24) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 36) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 48) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 60) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 72) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 84) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 96) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 108) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 120) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 132) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 144) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 156) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 168) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 180) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 192) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 204) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 216) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 228) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 240) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 252) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 264) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 276) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 288) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 300) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 312) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 324) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 336) or
						(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 588) --Each individual hatch
						)
						 else '0';

end Behavioral;


