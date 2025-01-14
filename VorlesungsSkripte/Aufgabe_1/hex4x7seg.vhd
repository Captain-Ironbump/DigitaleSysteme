LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY hex4x7seg IS
   GENERIC(RSTDEF: std_logic := '0');
   PORT(rst:   IN  std_logic;                       -- reset,           active RSTDEF
        clk:   IN  std_logic;                       -- clock,           rising edge
        data:  IN  std_logic_vector(15 DOWNTO 0);   -- data input,      active high
        dpin:  IN  std_logic_vector( 3 DOWNTO 0);   -- 4 decimal point, active high
        ena:   OUT std_logic_vector( 3 DOWNTO 0);   -- 4 digit enable  signals,                active high
        seg:   OUT std_logic_vector( 7 DOWNTO 1);   -- 7 connections to seven-segment display, active high
        dp:    OUT std_logic);                      -- decimal point output,                   active high
END hex4x7seg;

ARCHITECTURE struktur OF hex4x7seg IS

    CONSTANT RES: std_logic_vector := "11111111111111";
    -- Modulo-2**14-Zaehler
    SIGNAL reg: std_logic_vector(13 DOWNTO 0);
    
    SIGNAL en: std_logic;
    
    SIGNAL sel: std_logic_vector(1 DOWNTO 0);
    
    SIGNAL cc: std_logic_vector(3 DOWNTO 0);
    
    SIGNAL seg_sel: std_logic_vector(3 DOWNTO 0);
    

BEGIN
   
    p1: PROCESS (rst, clk) IS
    BEGIN
        IF rst=RSTDEF THEN
            en <= '0';
            reg <= (OTHERS => '1');
        ELSIF rising_edge(clk) THEN
            en <= '0';
            IF reg=RES THEN 
                en <= '1';
            END IF;
            -- x^14 + x^8 + x^6 + x^1 + 1
            reg(13 DOWNTO 9) <= reg(12 DOWNTO 8);
            reg(8) <= reg(7) XOR reg(13);
            reg(7) <= reg(6);
            reg(6) <= reg(5) XOR reg(13);
            reg(5 DOWNTO 2) <= reg(4 DOWNTO 1);
            reg(1) <= reg(0) XOR reg(13);
            reg(0) <= reg(13);
        END IF;
    END PROCESS;
   
    -- Modulo-4-Zaehler
    p2: PROCESS (rst, clk) IS
    BEGIN
        IF rst=RSTDEF THEN
            sel <= "00";
        ELSIF rising_edge(clk) THEN
            sel <= sel + en;
        END IF;
    END PROCESS;

    -- 1-aus-4-Dekoder als Phasengenerator
    WITH sel SELECT
        cc <=   "0001" WHEN "00",
                "0010" WHEN "01",
                "0100" WHEN "10",
                "1000" WHEN "11",
                "1111" WHEN OTHERS;
        ena <= cc   WHEN rst/=RSTDEF
                    ELSE (OTHERS => '0');
       
    -- 1-aus-4-Multiplexer
    WITH sel SELECT
        dp <=   dpin(0) WHEN "00",
                dpin(1) WHEN "01",
                dpin(2) WHEN "10",
                dpin(3) WHEN OTHERS;

    -- 7-aus-4-Dekoder
    WITH seg_sel SELECT
        seg <=  "0111111" WHEN "0000",                                          
                "0000110" WHEN "0001",                                          
                "1011011" WHEN "0010",                                          
                "1001111" WHEN "0011",                                          
                "1100110" WHEN "0100",                                          
                "1101101" WHEN "0101",                                         
                "1111101" WHEN "0110",                                         
                "0000111" WHEN "0111",                                         
                "1111111" WHEN "1000",                                          
                "1101111" WHEN "1001",                                         
                "1110111" WHEN "1010",                                          
                "1111100" WHEN "1011",                                          
                "0111001" WHEN "1100",                                          
                "1011110" WHEN "1101",                                          
                "1111001" WHEN "1110",                                          
                "1110001" WHEN "1111",                                          
                "0000000" WHEN OTHERS;                                         
    

    -- 1-aus-4-Multiplexer
    WITH sel SELECT
		seg_sel <=  data( 3 DOWNTO 0 ) WHEN "00",                              
                    data( 7 DOWNTO 4 ) WHEN "01",                              
                    data(11 DOWNTO 8 ) WHEN "10",                               
                    data(15 DOWNTO 12) WHEN OTHERS;                             
    

END struktur;