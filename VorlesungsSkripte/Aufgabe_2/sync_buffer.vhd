
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY sync_buffer IS
   GENERIC(RSTDEF:  std_logic := '1');
   PORT(rst:    IN  std_logic;  -- reset, RSTDEF active
        clk:    IN  std_logic;  -- clock, rising edge
        en:     IN  std_logic;  -- enable, high active
        swrst:  IN  std_logic;  -- software reset, RSTDEF active
        din:    IN  std_logic;  -- data bit, input
        dout:   OUT std_logic;  -- data bit, output
        redge:  OUT std_logic;  -- rising  edge on din detected
        fedge:  OUT std_logic); -- falling edge on din detected
END sync_buffer;

--
-- Im Rahmen der 2. Aufgabe soll hier die Architekturbeschreibung
-- zur Entity sync_buffer implementiert werden.
--
ARCHITECTURE behavior OF sync_buffer IS
    SIGNAL q1:  std_logic;
    SIGNAL q2:  std_logic;
    SIGNAL q3:  std_logic;
    SIGNAL qH:  std_logic;
    
    SIGNAL state: std_logic;
    SIGNAL cnt: integer range 0 to 31; 
    
BEGIN

    flipFlop1: PROCESS(clk, rst) IS
    BEGIN
        IF rst=RSTDEF THEN
            q1 <= '0';
        ELSIF rising_edge(clk) THEN
            q1 <= din;
            IF swrst = RSTDEF THEN
                q1 <= '0';
            END IF;
        END IF;
    END PROCESS flipFlop1;
    
    
    flipFlop2: PROCESS(clk, rst) IS
    BEGIN
        IF rst=RSTDEF THEN
            q2 <= '0';
        ELSIF rising_edge(clk) THEN
            q2 <= q1;
            IF swrst = RSTDEF THEN
                q2 <= '0';
            END IF;
        END IF;
    END PROCESS flipFlop2;
    
    
    hysteresis: PROCESS(clk, rst) IS
    BEGIN
        IF rst=RSTDEF THEN
            state   <= '0';
            qH      <= '0';
            cnt     <= 0;
        ELSIF rising_edge(clk) THEN
            IF en = '1' THEN
				CASE state IS
					WHEN '0' =>
						qH <= '0';
						IF q2 = '1' THEN
							IF cnt < 31 THEN
								cnt <= cnt + 1;
							ELSE
								state <= '1';
							END IF;
						ELSE
							IF cnt > 0 THEN
								cnt <= cnt - 1;
							END IF;
						END IF;
					WHEN '1' =>
						qH <= '1';
						IF q2 = '1' THEN
							IF cnt < 31 THEN
								cnt <= cnt + 1;
							END IF;
					    ELSE
							IF cnt > 0 THEN
								cnt <= cnt - 1;
							ELSE
								state <= '0';
							END IF;
						END IF;
				END CASE;
			END IF;
            
			IF swrst = RSTDEF THEN
                state   <= '0';
				qH      <= '0';
				cnt     <= 0;
			END IF;
        END IF;
    END PROCESS hysteresis;
    
    
    flipFlop3: PROCESS(clk, rst) IS
    BEGIN
        IF rst=RSTDEF THEN
            q3 <= '0';
        ELSIF rising_edge(clk) THEN
            q3 <= qH;
            IF swrst = RSTDEF THEN
                q3 <= '0';
            END IF;
        END IF;
    END PROCESS flipFlop3;
    
    
    fedge   <= NOT qH AND q3;
    dout    <= q3;
    redge   <= qH AND NOT q3;

END behavior;