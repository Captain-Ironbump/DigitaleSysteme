
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

BEGIN

   -- Modulo-2**14-Zaehler
   SIGNAL reg: std_logic_vector(13 DOWNTO 0);
   
   2_14_mod_counter: PROCESS (rst, clk) IS
   BEGIN
    IF rst=RSTDEF THEN
        reg <= (OTHERS => '1');
    ELSIF rising_edge(clk) THEN
        -- x^14 + x^8 + x^6 + x^1 + 1
        reg(13 DOWNTO 9) <= reg(12 DOWNTO 8);
        reg(8) <= reg(7) XOR reg(13);
        reg(7) <= reg(6);
        reg(6) <= reg(5) XOR reg(13);
        reg(5 DOWNTO 2) <= reg(4 DOWNTO 1);
        reg(1) <= reg(0) XOR reg(13);
        reg(0) <= reg(13);
    END IF;
   END PROCESS
   
   -- Modulo-4-Zaehler

   -- 1-aus-4-Dekoder als Phasengenerator
       
   -- 1-aus-4-Multiplexer

   -- 7-aus-4-Dekoder

   -- 1-aus-4-Multiplexer

END struktur;