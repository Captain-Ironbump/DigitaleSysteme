
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.lfsr_lib.ALL;

ENTITY sync_module IS
   GENERIC(RSTDEF: std_logic := '1');
   PORT(rst:   IN  std_logic;  -- reset, active RSTDEF
        clk:   IN  std_logic;  -- clock, risign edge
        swrst: IN  std_logic;  -- software reset, active RSTDEF
        BTN1:  IN  std_logic;  -- push button -> load
        BTN2:  IN  std_logic;  -- push button -> dec
        BTN3:  IN  std_logic;  -- push button -> inc
        load:  OUT std_logic;  -- load,      high active
        dec:   OUT std_logic;  -- decrement, high active
        inc:   OUT std_logic); -- increment, high active
END sync_module;

--
-- Im Rahmen der 2. Aufgabe soll hier die Architekturbeschreibung
-- zur Entity sync_module implementiert werden.
--
ARCHITECTURE behavior OF sync_module IS
    
    COMPONENT sync_buffer IS
		GENERIC(RSTDEF : STD_LOGIC);
		PORT(
			rst : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			en : IN STD_LOGIC;
			swrst : IN STD_LOGIC;
			din : IN STD_LOGIC;
			dout : OUT STD_LOGIC;
			redge : OUT STD_LOGIC;
			fedge : OUT STD_LOGIC);
	END COMPONENT;
    
    CONSTANT    LENDEF: natural := 15;
    CONSTANT    POLY: std_logic_vector(LENDEF DOWNTO 0)   := "1000000000000011";
    CONSTANT    RES:  std_logic_vector(LENDEF-1 DOWNTO 0) := "111111111111111";
    
    SIGNAL      strb: std_logic;
    SIGNAL      reg:  std_logic_vector(LENDEF-1 DOWNTO 0);
    
BEGIN

    p1: PROCESS(rst, clk) IS
    BEGIN
        IF rst = RSTDEF THEN
            strb <= '0';
            reg     <= (OTHERS => '1');
        ELSIF rising_edge(clk) THEN
        
            strb <= '0';
            
            reg <= lfsr(reg, POLY, '0');
            
            IF reg=RES THEN
                strb <= '1';
            END IF;
            
        END IF;
    END PROCESS;
    

    buf1: sync_buffer
    GENERIC MAP(RSTDEF => RSTDEF)
    PORT MAP(   rst => rst,
                clk => clk,
                en  => strb,
                swrst => swrst,
                din => BTN1,
                dout => OPEN,
                redge => OPEN,
                fedge => inc);
    
    
    buf2: sync_buffer
    GENERIC MAP(RSTDEF => RSTDEF)
    PORT MAP(   rst => rst,
                clk => clk,
                en  => strb,
                swrst => swrst,
                din => BTN2,
                dout => OPEN,
                redge => OPEN,
                fedge => dec);
                

    buf3: sync_buffer
    GENERIC MAP(RSTDEF => RSTDEF)
    PORT MAP(   rst => rst,
                clk => clk,
                en  => strb,
                swrst => swrst,
                din => BTN3,
                dout => OPEN,
                redge => load,
                fedge => OPEN);

END behavior;