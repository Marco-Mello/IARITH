-- Copyright (C) 2025  Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Altera and sold by Altera or its authorized distributors.  Please
-- refer to the Altera Software License Subscription Agreements 
-- on the Quartus Prime software download page.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "11/26/2025 10:54:24"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          IARITH
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY IARITH_vhd_vec_tst IS
END IARITH_vhd_vec_tst;
ARCHITECTURE IARITH_arch OF IARITH_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL aux_1_CLK : STD_LOGIC;
SIGNAL CLOCK_50 : STD_LOGIC;
SIGNAL debug_dado_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL debug_dado_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL debug_EndMEM : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL debug_habilita : STD_LOGIC;
SIGNAL debug_inA : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL debug_inB : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL debug_OPCODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL debug_RA : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL debug_RB : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL debug_RD : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL debug_re : STD_LOGIC;
SIGNAL debug_saidaULA : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL debug_we : STD_LOGIC;
SIGNAL HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX4 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX5 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL KEY : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL LEDR : STD_LOGIC_VECTOR(9 DOWNTO 0);
COMPONENT IARITH
	PORT (
	aux_1_CLK : IN STD_LOGIC;
	CLOCK_50 : IN STD_LOGIC;
	debug_dado_in : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
	debug_dado_out : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
	debug_EndMEM : BUFFER STD_LOGIC_VECTOR(5 DOWNTO 0);
	debug_habilita : BUFFER STD_LOGIC;
	debug_inA : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
	debug_inB : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
	debug_OPCODE : BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
	debug_RA : BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0);
	debug_RB : BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0);
	debug_RD : BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0);
	debug_re : BUFFER STD_LOGIC;
	debug_saidaULA : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
	debug_we : BUFFER STD_LOGIC;
	HEX0 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX1 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX2 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX3 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX4 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX5 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	LEDR : BUFFER STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : IARITH
	PORT MAP (
-- list connections between master ports and signals
	aux_1_CLK => aux_1_CLK,
	CLOCK_50 => CLOCK_50,
	debug_dado_in => debug_dado_in,
	debug_dado_out => debug_dado_out,
	debug_EndMEM => debug_EndMEM,
	debug_habilita => debug_habilita,
	debug_inA => debug_inA,
	debug_inB => debug_inB,
	debug_OPCODE => debug_OPCODE,
	debug_RA => debug_RA,
	debug_RB => debug_RB,
	debug_RD => debug_RD,
	debug_re => debug_re,
	debug_saidaULA => debug_saidaULA,
	debug_we => debug_we,
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	HEX4 => HEX4,
	HEX5 => HEX5,
	KEY => KEY,
	LEDR => LEDR
	);

-- aux_1_CLK
t_prcs_aux_1_CLK: PROCESS
BEGIN
	aux_1_CLK <= '1';
	WAIT FOR 10000 ps;
	FOR i IN 1 TO 49
	LOOP
		aux_1_CLK <= '0';
		WAIT FOR 10000 ps;
		aux_1_CLK <= '1';
		WAIT FOR 10000 ps;
	END LOOP;
	aux_1_CLK <= '0';
WAIT;
END PROCESS t_prcs_aux_1_CLK;

-- CLOCK_50
t_prcs_CLOCK_50: PROCESS
BEGIN
	CLOCK_50 <= '0';
WAIT;
END PROCESS t_prcs_CLOCK_50;
-- KEY[3]
t_prcs_KEY_3: PROCESS
BEGIN
	KEY(3) <= '0';
WAIT;
END PROCESS t_prcs_KEY_3;
-- KEY[2]
t_prcs_KEY_2: PROCESS
BEGIN
	KEY(2) <= '0';
WAIT;
END PROCESS t_prcs_KEY_2;
-- KEY[1]
t_prcs_KEY_1: PROCESS
BEGIN
	KEY(1) <= '0';
WAIT;
END PROCESS t_prcs_KEY_1;
-- KEY[0]
t_prcs_KEY_0: PROCESS
BEGIN
	KEY(0) <= '0';
WAIT;
END PROCESS t_prcs_KEY_0;
END IARITH_arch;
