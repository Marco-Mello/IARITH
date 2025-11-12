-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

-- DATE "11/12/2025 17:02:46"

-- 
-- Device: Altera 5CEBA4F23C7 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	IARITH IS
    PORT (
	CLOCK_50 : IN std_logic;
	INSTRUCAO : OUT std_logic_vector(12 DOWNTO 0);
	DATA_IN : OUT std_logic_vector(7 DOWNTO 0);
	DATA_OUT : OUT std_logic_vector(7 DOWNTO 0);
	ADDRESS : OUT std_logic_vector(7 DOWNTO 0)
	);
END IARITH;

ARCHITECTURE structure OF IARITH IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_CLOCK_50 : std_logic;
SIGNAL ww_INSTRUCAO : std_logic_vector(12 DOWNTO 0);
SIGNAL ww_DATA_IN : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_DATA_OUT : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_ADDRESS : std_logic_vector(7 DOWNTO 0);
SIGNAL \INSTRUCAO[0]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[1]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[2]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[3]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[4]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[5]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[6]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[7]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[8]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[9]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[10]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[11]~output_o\ : std_logic;
SIGNAL \INSTRUCAO[12]~output_o\ : std_logic;
SIGNAL \DATA_IN[0]~output_o\ : std_logic;
SIGNAL \DATA_IN[1]~output_o\ : std_logic;
SIGNAL \DATA_IN[2]~output_o\ : std_logic;
SIGNAL \DATA_IN[3]~output_o\ : std_logic;
SIGNAL \DATA_IN[4]~output_o\ : std_logic;
SIGNAL \DATA_IN[5]~output_o\ : std_logic;
SIGNAL \DATA_IN[6]~output_o\ : std_logic;
SIGNAL \DATA_IN[7]~output_o\ : std_logic;
SIGNAL \DATA_OUT[0]~output_o\ : std_logic;
SIGNAL \DATA_OUT[1]~output_o\ : std_logic;
SIGNAL \DATA_OUT[2]~output_o\ : std_logic;
SIGNAL \DATA_OUT[3]~output_o\ : std_logic;
SIGNAL \DATA_OUT[4]~output_o\ : std_logic;
SIGNAL \DATA_OUT[5]~output_o\ : std_logic;
SIGNAL \DATA_OUT[6]~output_o\ : std_logic;
SIGNAL \DATA_OUT[7]~output_o\ : std_logic;
SIGNAL \ADDRESS[0]~output_o\ : std_logic;
SIGNAL \ADDRESS[1]~output_o\ : std_logic;
SIGNAL \ADDRESS[2]~output_o\ : std_logic;
SIGNAL \ADDRESS[3]~output_o\ : std_logic;
SIGNAL \ADDRESS[4]~output_o\ : std_logic;
SIGNAL \ADDRESS[5]~output_o\ : std_logic;
SIGNAL \ADDRESS[6]~output_o\ : std_logic;
SIGNAL \ADDRESS[7]~output_o\ : std_logic;
SIGNAL \CLOCK_50~input_o\ : std_logic;
SIGNAL \PC_Mais1|Add0~1_sumout\ : std_logic;
SIGNAL \PC_Mais1|Add0~2\ : std_logic;
SIGNAL \PC_Mais1|Add0~29_sumout\ : std_logic;
SIGNAL \PC_Mais1|Add0~30\ : std_logic;
SIGNAL \PC_Mais1|Add0~33_sumout\ : std_logic;
SIGNAL \PC_Mais1|Add0~34\ : std_logic;
SIGNAL \PC_Mais1|Add0~21_sumout\ : std_logic;
SIGNAL \PC_Mais1|Add0~22\ : std_logic;
SIGNAL \PC_Mais1|Add0~25_sumout\ : std_logic;
SIGNAL \PC_Mais1|Add0~26\ : std_logic;
SIGNAL \PC_Mais1|Add0~5_sumout\ : std_logic;
SIGNAL \PC_Mais1|Add0~6\ : std_logic;
SIGNAL \PC_Mais1|Add0~9_sumout\ : std_logic;
SIGNAL \PC_Mais1|Add0~10\ : std_logic;
SIGNAL \PC_Mais1|Add0~13_sumout\ : std_logic;
SIGNAL \PC_Mais1|Add0~14\ : std_logic;
SIGNAL \PC_Mais1|Add0~17_sumout\ : std_logic;
SIGNAL \memoriaROM|memROM~0_combout\ : std_logic;
SIGNAL \memoriaROM|memROM~1_combout\ : std_logic;
SIGNAL \memoriaROM|memROM~2_combout\ : std_logic;
SIGNAL \memoriaROM|memROM~3_combout\ : std_logic;
SIGNAL \Registrador_PC|DOUT\ : std_logic_vector(8 DOWNTO 0);
SIGNAL \PC_Mais1|ALT_INV_Add0~9_sumout\ : std_logic;
SIGNAL \PC_Mais1|ALT_INV_Add0~13_sumout\ : std_logic;
SIGNAL \PC_Mais1|ALT_INV_Add0~1_sumout\ : std_logic;
SIGNAL \PC_Mais1|ALT_INV_Add0~5_sumout\ : std_logic;
SIGNAL \Registrador_PC|ALT_INV_DOUT\ : std_logic_vector(8 DOWNTO 0);
SIGNAL \memoriaROM|ALT_INV_memROM~0_combout\ : std_logic;
SIGNAL \PC_Mais1|ALT_INV_Add0~33_sumout\ : std_logic;
SIGNAL \PC_Mais1|ALT_INV_Add0~29_sumout\ : std_logic;
SIGNAL \PC_Mais1|ALT_INV_Add0~25_sumout\ : std_logic;
SIGNAL \PC_Mais1|ALT_INV_Add0~21_sumout\ : std_logic;
SIGNAL \PC_Mais1|ALT_INV_Add0~17_sumout\ : std_logic;

BEGIN

ww_CLOCK_50 <= CLOCK_50;
INSTRUCAO <= ww_INSTRUCAO;
DATA_IN <= ww_DATA_IN;
DATA_OUT <= ww_DATA_OUT;
ADDRESS <= ww_ADDRESS;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\PC_Mais1|ALT_INV_Add0~9_sumout\ <= NOT \PC_Mais1|Add0~9_sumout\;
\PC_Mais1|ALT_INV_Add0~13_sumout\ <= NOT \PC_Mais1|Add0~13_sumout\;
\PC_Mais1|ALT_INV_Add0~1_sumout\ <= NOT \PC_Mais1|Add0~1_sumout\;
\PC_Mais1|ALT_INV_Add0~5_sumout\ <= NOT \PC_Mais1|Add0~5_sumout\;
\Registrador_PC|ALT_INV_DOUT\(2) <= NOT \Registrador_PC|DOUT\(2);
\Registrador_PC|ALT_INV_DOUT\(1) <= NOT \Registrador_PC|DOUT\(1);
\Registrador_PC|ALT_INV_DOUT\(4) <= NOT \Registrador_PC|DOUT\(4);
\Registrador_PC|ALT_INV_DOUT\(3) <= NOT \Registrador_PC|DOUT\(3);
\Registrador_PC|ALT_INV_DOUT\(8) <= NOT \Registrador_PC|DOUT\(8);
\Registrador_PC|ALT_INV_DOUT\(7) <= NOT \Registrador_PC|DOUT\(7);
\Registrador_PC|ALT_INV_DOUT\(6) <= NOT \Registrador_PC|DOUT\(6);
\Registrador_PC|ALT_INV_DOUT\(5) <= NOT \Registrador_PC|DOUT\(5);
\Registrador_PC|ALT_INV_DOUT\(0) <= NOT \Registrador_PC|DOUT\(0);
\memoriaROM|ALT_INV_memROM~0_combout\ <= NOT \memoriaROM|memROM~0_combout\;
\PC_Mais1|ALT_INV_Add0~33_sumout\ <= NOT \PC_Mais1|Add0~33_sumout\;
\PC_Mais1|ALT_INV_Add0~29_sumout\ <= NOT \PC_Mais1|Add0~29_sumout\;
\PC_Mais1|ALT_INV_Add0~25_sumout\ <= NOT \PC_Mais1|Add0~25_sumout\;
\PC_Mais1|ALT_INV_Add0~21_sumout\ <= NOT \PC_Mais1|Add0~21_sumout\;
\PC_Mais1|ALT_INV_Add0~17_sumout\ <= NOT \PC_Mais1|Add0~17_sumout\;

\INSTRUCAO[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \memoriaROM|memROM~1_combout\,
	devoe => ww_devoe,
	o => \INSTRUCAO[0]~output_o\);

\INSTRUCAO[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \memoriaROM|memROM~2_combout\,
	devoe => ww_devoe,
	o => \INSTRUCAO[1]~output_o\);

\INSTRUCAO[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \memoriaROM|memROM~3_combout\,
	devoe => ww_devoe,
	o => \INSTRUCAO[2]~output_o\);

\INSTRUCAO[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \INSTRUCAO[3]~output_o\);

\INSTRUCAO[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \INSTRUCAO[4]~output_o\);

\INSTRUCAO[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \INSTRUCAO[5]~output_o\);

\INSTRUCAO[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \INSTRUCAO[6]~output_o\);

\INSTRUCAO[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \INSTRUCAO[7]~output_o\);

\INSTRUCAO[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \INSTRUCAO[8]~output_o\);

\INSTRUCAO[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \memoriaROM|memROM~1_combout\,
	devoe => ww_devoe,
	o => \INSTRUCAO[9]~output_o\);

\INSTRUCAO[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \memoriaROM|memROM~2_combout\,
	devoe => ww_devoe,
	o => \INSTRUCAO[10]~output_o\);

\INSTRUCAO[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \INSTRUCAO[11]~output_o\);

\INSTRUCAO[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \INSTRUCAO[12]~output_o\);

\DATA_IN[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_IN[0]~output_o\);

\DATA_IN[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_IN[1]~output_o\);

\DATA_IN[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_IN[2]~output_o\);

\DATA_IN[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_IN[3]~output_o\);

\DATA_IN[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_IN[4]~output_o\);

\DATA_IN[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_IN[5]~output_o\);

\DATA_IN[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_IN[6]~output_o\);

\DATA_IN[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_IN[7]~output_o\);

\DATA_OUT[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_OUT[0]~output_o\);

\DATA_OUT[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_OUT[1]~output_o\);

\DATA_OUT[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_OUT[2]~output_o\);

\DATA_OUT[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_OUT[3]~output_o\);

\DATA_OUT[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_OUT[4]~output_o\);

\DATA_OUT[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_OUT[5]~output_o\);

\DATA_OUT[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_OUT[6]~output_o\);

\DATA_OUT[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \DATA_OUT[7]~output_o\);

\ADDRESS[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ADDRESS[0]~output_o\);

\ADDRESS[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ADDRESS[1]~output_o\);

\ADDRESS[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ADDRESS[2]~output_o\);

\ADDRESS[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ADDRESS[3]~output_o\);

\ADDRESS[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ADDRESS[4]~output_o\);

\ADDRESS[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ADDRESS[5]~output_o\);

\ADDRESS[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ADDRESS[6]~output_o\);

\ADDRESS[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ADDRESS[7]~output_o\);

\CLOCK_50~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_CLOCK_50,
	o => \CLOCK_50~input_o\);

\Registrador_PC|DOUT[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~1_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(0));

\PC_Mais1|Add0~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~1_sumout\ = SUM(( \Registrador_PC|DOUT\(0) ) + ( VCC ) + ( !VCC ))
-- \PC_Mais1|Add0~2\ = CARRY(( \Registrador_PC|DOUT\(0) ) + ( VCC ) + ( !VCC ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(0),
	cin => GND,
	sumout => \PC_Mais1|Add0~1_sumout\,
	cout => \PC_Mais1|Add0~2\);

\Registrador_PC|DOUT[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~5_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(5));

\PC_Mais1|Add0~29\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~29_sumout\ = SUM(( \Registrador_PC|DOUT\(1) ) + ( GND ) + ( \PC_Mais1|Add0~2\ ))
-- \PC_Mais1|Add0~30\ = CARRY(( \Registrador_PC|DOUT\(1) ) + ( GND ) + ( \PC_Mais1|Add0~2\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(1),
	cin => \PC_Mais1|Add0~2\,
	sumout => \PC_Mais1|Add0~29_sumout\,
	cout => \PC_Mais1|Add0~30\);

\Registrador_PC|DOUT[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~29_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(1));

\PC_Mais1|Add0~33\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~33_sumout\ = SUM(( \Registrador_PC|DOUT\(2) ) + ( GND ) + ( \PC_Mais1|Add0~30\ ))
-- \PC_Mais1|Add0~34\ = CARRY(( \Registrador_PC|DOUT\(2) ) + ( GND ) + ( \PC_Mais1|Add0~30\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(2),
	cin => \PC_Mais1|Add0~30\,
	sumout => \PC_Mais1|Add0~33_sumout\,
	cout => \PC_Mais1|Add0~34\);

\Registrador_PC|DOUT[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~33_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(2));

\PC_Mais1|Add0~21\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~21_sumout\ = SUM(( \Registrador_PC|DOUT\(3) ) + ( GND ) + ( \PC_Mais1|Add0~34\ ))
-- \PC_Mais1|Add0~22\ = CARRY(( \Registrador_PC|DOUT\(3) ) + ( GND ) + ( \PC_Mais1|Add0~34\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(3),
	cin => \PC_Mais1|Add0~34\,
	sumout => \PC_Mais1|Add0~21_sumout\,
	cout => \PC_Mais1|Add0~22\);

\Registrador_PC|DOUT[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~21_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(3));

\PC_Mais1|Add0~25\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~25_sumout\ = SUM(( \Registrador_PC|DOUT\(4) ) + ( GND ) + ( \PC_Mais1|Add0~22\ ))
-- \PC_Mais1|Add0~26\ = CARRY(( \Registrador_PC|DOUT\(4) ) + ( GND ) + ( \PC_Mais1|Add0~22\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(4),
	cin => \PC_Mais1|Add0~22\,
	sumout => \PC_Mais1|Add0~25_sumout\,
	cout => \PC_Mais1|Add0~26\);

\Registrador_PC|DOUT[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~25_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(4));

\PC_Mais1|Add0~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~5_sumout\ = SUM(( \Registrador_PC|DOUT\(5) ) + ( GND ) + ( \PC_Mais1|Add0~26\ ))
-- \PC_Mais1|Add0~6\ = CARRY(( \Registrador_PC|DOUT\(5) ) + ( GND ) + ( \PC_Mais1|Add0~26\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(5),
	cin => \PC_Mais1|Add0~26\,
	sumout => \PC_Mais1|Add0~5_sumout\,
	cout => \PC_Mais1|Add0~6\);

\Registrador_PC|DOUT[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~9_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(6));

\PC_Mais1|Add0~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~9_sumout\ = SUM(( \Registrador_PC|DOUT\(6) ) + ( GND ) + ( \PC_Mais1|Add0~6\ ))
-- \PC_Mais1|Add0~10\ = CARRY(( \Registrador_PC|DOUT\(6) ) + ( GND ) + ( \PC_Mais1|Add0~6\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(6),
	cin => \PC_Mais1|Add0~6\,
	sumout => \PC_Mais1|Add0~9_sumout\,
	cout => \PC_Mais1|Add0~10\);

\Registrador_PC|DOUT[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~13_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(7));

\PC_Mais1|Add0~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~13_sumout\ = SUM(( \Registrador_PC|DOUT\(7) ) + ( GND ) + ( \PC_Mais1|Add0~10\ ))
-- \PC_Mais1|Add0~14\ = CARRY(( \Registrador_PC|DOUT\(7) ) + ( GND ) + ( \PC_Mais1|Add0~10\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(7),
	cin => \PC_Mais1|Add0~10\,
	sumout => \PC_Mais1|Add0~13_sumout\,
	cout => \PC_Mais1|Add0~14\);

\Registrador_PC|DOUT[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~input_o\,
	d => \PC_Mais1|Add0~17_sumout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \Registrador_PC|DOUT\(8));

\PC_Mais1|Add0~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \PC_Mais1|Add0~17_sumout\ = SUM(( \Registrador_PC|DOUT\(8) ) + ( GND ) + ( \PC_Mais1|Add0~14\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \Registrador_PC|ALT_INV_DOUT\(8),
	cin => \PC_Mais1|Add0~14\,
	sumout => \PC_Mais1|Add0~17_sumout\);

\memoriaROM|memROM~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \memoriaROM|memROM~0_combout\ = (!\PC_Mais1|Add0~21_sumout\ & !\PC_Mais1|Add0~25_sumout\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000100010001000100010001000100010001000100010001000100010001000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \PC_Mais1|ALT_INV_Add0~21_sumout\,
	datab => \PC_Mais1|ALT_INV_Add0~25_sumout\,
	combout => \memoriaROM|memROM~0_combout\);

\memoriaROM|memROM~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \memoriaROM|memROM~1_combout\ = ( !\PC_Mais1|Add0~17_sumout\ & ( \memoriaROM|memROM~0_combout\ & ( (\PC_Mais1|Add0~1_sumout\ & (!\PC_Mais1|Add0~5_sumout\ & (!\PC_Mais1|Add0~9_sumout\ & !\PC_Mais1|Add0~13_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000001000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \PC_Mais1|ALT_INV_Add0~1_sumout\,
	datab => \PC_Mais1|ALT_INV_Add0~5_sumout\,
	datac => \PC_Mais1|ALT_INV_Add0~9_sumout\,
	datad => \PC_Mais1|ALT_INV_Add0~13_sumout\,
	datae => \PC_Mais1|ALT_INV_Add0~17_sumout\,
	dataf => \memoriaROM|ALT_INV_memROM~0_combout\,
	combout => \memoriaROM|memROM~1_combout\);

\memoriaROM|memROM~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \memoriaROM|memROM~2_combout\ = ( \memoriaROM|memROM~0_combout\ & ( \PC_Mais1|Add0~29_sumout\ & ( (!\PC_Mais1|Add0~5_sumout\ & (!\PC_Mais1|Add0~9_sumout\ & (!\PC_Mais1|Add0~13_sumout\ & !\PC_Mais1|Add0~17_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000001000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \PC_Mais1|ALT_INV_Add0~5_sumout\,
	datab => \PC_Mais1|ALT_INV_Add0~9_sumout\,
	datac => \PC_Mais1|ALT_INV_Add0~13_sumout\,
	datad => \PC_Mais1|ALT_INV_Add0~17_sumout\,
	datae => \memoriaROM|ALT_INV_memROM~0_combout\,
	dataf => \PC_Mais1|ALT_INV_Add0~29_sumout\,
	combout => \memoriaROM|memROM~2_combout\);

\memoriaROM|memROM~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \memoriaROM|memROM~3_combout\ = ( \memoriaROM|memROM~0_combout\ & ( \PC_Mais1|Add0~33_sumout\ & ( (!\PC_Mais1|Add0~5_sumout\ & (!\PC_Mais1|Add0~9_sumout\ & (!\PC_Mais1|Add0~13_sumout\ & !\PC_Mais1|Add0~17_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000001000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \PC_Mais1|ALT_INV_Add0~5_sumout\,
	datab => \PC_Mais1|ALT_INV_Add0~9_sumout\,
	datac => \PC_Mais1|ALT_INV_Add0~13_sumout\,
	datad => \PC_Mais1|ALT_INV_Add0~17_sumout\,
	datae => \memoriaROM|ALT_INV_memROM~0_combout\,
	dataf => \PC_Mais1|ALT_INV_Add0~33_sumout\,
	combout => \memoriaROM|memROM~3_combout\);

ww_INSTRUCAO(0) <= \INSTRUCAO[0]~output_o\;

ww_INSTRUCAO(1) <= \INSTRUCAO[1]~output_o\;

ww_INSTRUCAO(2) <= \INSTRUCAO[2]~output_o\;

ww_INSTRUCAO(3) <= \INSTRUCAO[3]~output_o\;

ww_INSTRUCAO(4) <= \INSTRUCAO[4]~output_o\;

ww_INSTRUCAO(5) <= \INSTRUCAO[5]~output_o\;

ww_INSTRUCAO(6) <= \INSTRUCAO[6]~output_o\;

ww_INSTRUCAO(7) <= \INSTRUCAO[7]~output_o\;

ww_INSTRUCAO(8) <= \INSTRUCAO[8]~output_o\;

ww_INSTRUCAO(9) <= \INSTRUCAO[9]~output_o\;

ww_INSTRUCAO(10) <= \INSTRUCAO[10]~output_o\;

ww_INSTRUCAO(11) <= \INSTRUCAO[11]~output_o\;

ww_INSTRUCAO(12) <= \INSTRUCAO[12]~output_o\;

ww_DATA_IN(0) <= \DATA_IN[0]~output_o\;

ww_DATA_IN(1) <= \DATA_IN[1]~output_o\;

ww_DATA_IN(2) <= \DATA_IN[2]~output_o\;

ww_DATA_IN(3) <= \DATA_IN[3]~output_o\;

ww_DATA_IN(4) <= \DATA_IN[4]~output_o\;

ww_DATA_IN(5) <= \DATA_IN[5]~output_o\;

ww_DATA_IN(6) <= \DATA_IN[6]~output_o\;

ww_DATA_IN(7) <= \DATA_IN[7]~output_o\;

ww_DATA_OUT(0) <= \DATA_OUT[0]~output_o\;

ww_DATA_OUT(1) <= \DATA_OUT[1]~output_o\;

ww_DATA_OUT(2) <= \DATA_OUT[2]~output_o\;

ww_DATA_OUT(3) <= \DATA_OUT[3]~output_o\;

ww_DATA_OUT(4) <= \DATA_OUT[4]~output_o\;

ww_DATA_OUT(5) <= \DATA_OUT[5]~output_o\;

ww_DATA_OUT(6) <= \DATA_OUT[6]~output_o\;

ww_DATA_OUT(7) <= \DATA_OUT[7]~output_o\;

ww_ADDRESS(0) <= \ADDRESS[0]~output_o\;

ww_ADDRESS(1) <= \ADDRESS[1]~output_o\;

ww_ADDRESS(2) <= \ADDRESS[2]~output_o\;

ww_ADDRESS(3) <= \ADDRESS[3]~output_o\;

ww_ADDRESS(4) <= \ADDRESS[4]~output_o\;

ww_ADDRESS(5) <= \ADDRESS[5]~output_o\;

ww_ADDRESS(6) <= \ADDRESS[6]~output_o\;

ww_ADDRESS(7) <= \ADDRESS[7]~output_o\;
END structure;


