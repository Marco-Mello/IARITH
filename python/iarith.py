#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
iarith.py - Simulador/IDE PyQt5 para ISA custom (float IEEE-754 immediatos / memoria)
Autor: gerado por ChatGPT (ajuste conforme necessário)
Salve este arquivo como 'iarith.py' e execute com Python3 + PyQt5.
"""

import sys
import struct
import re
import math
from PyQt5 import QtWidgets, QtCore, QtGui

# -------------------------
# Configurações / Constantes
# -------------------------
MEM_SIZE = 64  # words
MEM_DISPLAY = 64  # quantas posições mostrar na UI
REG_NAMES = [f"R{i}" for i in range(8)]
# Opcodes em ordem alfabética conforme pedido
OPCODES = sorted([
    "ADD", "ADDi", "DIV", "JEQ", "JMP",
    "LDI", "LDM", "MOV", "MUL", "STM", "SUB"
], key=lambda s: s.upper())

# Instruções que tratamos o imediato como endereço/integer (quando apropriado)
ADDRESS_OPS = {"LDM", "STM", "JMP", "JEQ", "LDA", "STA"}  # inclui LDA/STA por completude

# -------------------------
# Utils: bits <-> float
# -------------------------
def u32_to_float(u: int) -> float:
    """Converte uma palavra de 32-bit (int) para float IEEE-754 (big-endian)."""
    u &= 0xFFFFFFFF
    b = u.to_bytes(4, byteorder='big')
    return struct.unpack('>f', b)[0]

def float_to_u32(f: float) -> int:
    """Converte float para representação de 32-bit (bits) (big-endian)."""
    b = struct.pack('>f', float(f))
    return int.from_bytes(b, byteorder='big')

# -------------------------
# Parser de immediatos
# -------------------------
def parse_immediate_field(token: str):
    """
    Parse do campo imediato.
    Retorna: (word_as_int, float_value, hex_str, raw_token)
    - Se token == x"hhhhhhhh": word = int(hex), float_value = bits->float
    - Se token decimal/float: float_value = float(...), word = float_to_u32(...)
    - Se token integer plain: integer treated as integer word & float_value=float(int)
    - Também aceita 0xhhhhhhhh
    """
    raw = (token or "").strip()
    if raw == "":
        return 0, 0.0, '0x00000000', raw

    # hex literal x"HHHHHHHH"
    m = re.match(r'^[xX]"([0-9A-Fa-f]{8})"$', raw)
    if m:
        hex8 = m.group(1)
        word = int(hex8, 16) & 0xFFFFFFFF
        try:
            f = u32_to_float(word)
        except Exception:
            f = 0.0
        hex_str = f'x"{word:08X}"'
        return word, f, hex_str, raw

    # 0xHHHHHHHH format
    m2 = re.match(r'^(0x[0-9A-Fa-f]{1,8})$', raw)
    if m2:
        word = int(raw, 16) & 0xFFFFFFFF
        try:
            f = u32_to_float(word)
        except Exception:
            f = 0.0
        hex_str = f'0x{word:08X}'
        return word, f, hex_str, raw

    # normalize comma -> dot for floats
    norm = raw.replace(',', '.')
    # integer decimal?
    if re.match(r'^[+-]?\d+$', norm):
        ival = int(norm, 10)
        word = ival & 0xFFFFFFFF
        f = float(ival)
        hex_str = f'0x{word:08X}'
        return word, f, hex_str, raw

    # float decimal?
    if re.match(r'^[+-]?\d+(\.\d+)?$', norm):
        try:
            f = float(norm)
        except Exception:
            f = 0.0
        word = float_to_u32(f)
        hex_str = f'x"{word:08X}"'
        return word, f, hex_str, raw

    # fallback try int cast
    try:
        word = int(raw, 0) & 0xFFFFFFFF
        try:
            f = u32_to_float(word)
        except:
            f = 0.0
        return word, f, f'0x{word:08X}', raw
    except Exception:
        return 0, 0.0, '0x00000000', raw

# -------------------------
# QComboBox que ignora wheel
# -------------------------
class ClickOnlyComboBox(QtWidgets.QComboBox):
    def wheelEvent(self, event):
        # Ignora rolamento do mouse
        event.ignore()

# -------------------------
# Simulador simples
# -------------------------
class Simulator:
    def __init__(self, mem_size=MEM_SIZE):
        self.mem_size = mem_size
        self.reset()

    def reset(self):
        self.registers = [0.0]*8  # R0..R7 floats
        self.memory = [0.0]*self.mem_size  # memória como floats (representação real)
        self.pc = 0
        self.halted = True
        self.steps = 0
        self.program = []  # lista de instruções (dicionários)
        # raw storage for imm bits if needed
        self.raw_bits = []

    def load_program(self, prog):
        """
        prog é lista de dicionários com keys:
        opcode, rd, ra, rb, imm_word(int), imm_float(float), imm_hex, imm_raw
        """
        self.program = prog[:]
        self.pc = 0
        self.halted = False
        self.steps = 0

    def step(self, console_append=None):
        """Executa uma instrução; retorna True se ainda rodando, False se halt."""
        if self.halted or self.pc < 0 or self.pc >= len(self.program):
            self.halted = True
            return False

        instr = self.program[self.pc]
        op = instr['opcode'].upper()
        rd = instr['rd']
        ra = instr['ra']
        rb = instr['rb']
        imm_word = instr['imm_word']
        imm_float = instr['imm_float']
        imm_raw = instr['imm_raw']

        def reg_index(r):
            if isinstance(r, str) and r.upper().startswith('R'):
                try:
                    return int(r[1:]) & 7
                except:
                    return 0
            return 0

        rd_i = reg_index(rd)
        ra_i = reg_index(ra)
        rb_i = reg_index(rb)

        # helper to append console if provided
        def log(s):
            if console_append:
                console_append(s)

        # Log pre-state
        log(f'PC={self.pc} | {op} {rd},{ra},{rb} imm={hex(imm_word)} (raw={imm_raw})')

        # Address-type immediates use imm_word as integer address
        # ULA-type immediates use imm_float
        next_pc = self.pc + 1
        try:
            if op == "LDI":
                # Load immediate float bits into RD
                self.registers[rd_i] = float(imm_float)
                log(f' -> LDI: {REG_NAMES[rd_i]} = {self.registers[rd_i]}')
            elif op == "LDM":
                addr = int(imm_word) & 0xFFFFFFFF
                if addr >= self.mem_size:
                    addr = addr % self.mem_size
                    log(f' -> LDM: addr out-of-range, truncated to {addr}')
                self.registers[rd_i] = float(self.memory[addr])
                log(f' -> LDM: {REG_NAMES[rd_i]} = MEM[{addr}] = {self.registers[rd_i]}')
            elif op == "STM":
                addr = int(imm_word) & 0xFFFFFFFF
                if addr >= self.mem_size:
                    addr = addr % self.mem_size
                    log(f' -> STM: addr out-of-range, truncated to {addr}')
                self.memory[addr] = float(self.registers[ra_i]) if ra_i is not None else float(self.registers[rd_i])
                log(f' -> STM: MEM[{addr}] = {self.memory[addr]}')
            elif op == "MOV":
                # MOV rd = rb
                self.registers[rd_i] = float(self.registers[rb_i])
                log(f' -> MOV: {REG_NAMES[rd_i]} = {self.registers[rd_i]}')
            elif op == "ADD":
                self.registers[rd_i] = float(self.registers[ra_i] + self.registers[rb_i])
                log(f' -> ADD: {REG_NAMES[rd_i]} = {self.registers[rd_i]}')
            elif op == "ADDI":
                # rd = ra + imm_float
                self.registers[rd_i] = float(self.registers[ra_i] + imm_float)
                log(f' -> ADDi: {REG_NAMES[rd_i]} = {self.registers[rd_i]}')
            elif op == "SUB":
                self.registers[rd_i] = float(self.registers[ra_i] - self.registers[rb_i])
                log(f' -> SUB: {REG_NAMES[rd_i]} = {self.registers[rd_i]}')
            elif op == "MUL":
                self.registers[rd_i] = float(self.registers[ra_i] * self.registers[rb_i])
                log(f' -> MUL: {REG_NAMES[rd_i]} = {self.registers[rd_i]}')
            elif op == "DIV":
                denom = self.registers[rb_i]
                if abs(denom) < 1e-12:
                    self.registers[rd_i] = float('inf')
                    log(f' -> DIV: divide by zero -> inf')
                else:
                    self.registers[rd_i] = float(self.registers[ra_i] / denom)
                    log(f' -> DIV: {REG_NAMES[rd_i]} = {self.registers[rd_i]}')
            elif op == "JMP":
                addr = int(imm_word) & 0xFFFFFFFF
                # interpret imm_word as instruction index (PC value)
                if addr < 0 or addr >= len(self.program):
                    log(f' -> JMP: target {addr} outside program; clamp to bounds')
                    addr = max(0, min(addr, len(self.program)-1))
                next_pc = addr
                log(f' -> JMP -> PC := {next_pc}')
            elif op == "JEQ":
                # if ra == rb -> PC := imm_word
                a = self.registers[ra_i]
                b = self.registers[rb_i]
                if math.isclose(a, b, rel_tol=1e-9, abs_tol=1e-6):
                    addr = int(imm_word) & 0xFFFFFFFF
                    if addr < 0 or addr >= len(self.program):
                        addr = max(0, min(addr, len(self.program)-1))
                    next_pc = addr
                    log(f' -> JEQ true -> PC := {next_pc}')
                else:
                    log(f' -> JEQ false')
            else:
                log(f' -> Unknown opcode {op}: treated as NOP')
        except Exception as e:
            log(f'Exception executing {op} @ PC{self.pc}: {e}')

        self.pc = next_pc
        self.steps += 1
        # If PC becomes invalid, halt
        if self.pc < 0 or self.pc >= len(self.program):
            self.halted = True
            log(' -> PC out of range. Halting.')
            return False

        return not self.halted

# -------------------------
# UI principal
# -------------------------
class IarithUI(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("IARITH - ISA Simulator")
        self.resize(1100, 700)
        self.sim = Simulator(mem_size=MEM_SIZE)
        self._run_timer = QtCore.QTimer(self)
        self._run_timer.timeout.connect(self._run_step)
        self._running = False

        self._build_ui()
        self.update_register_view()
        self.update_memory_view()

    def _build_ui(self):
        # central widget
        w = QtWidgets.QWidget()
        self.setCentralWidget(w)
        layout = QtWidgets.QVBoxLayout(w)

        # Toolbar of buttons
        hl = QtWidgets.QHBoxLayout()
        btn_new = QtWidgets.QPushButton("New Row")
        btn_del = QtWidgets.QPushButton("Delete Row")
        btn_loadasm = QtWidgets.QPushButton("Load .asm")
        btn_loadprog = QtWidgets.QPushButton("Load Program")
        btn_run = QtWidgets.QPushButton("Run")
        btn_step = QtWidgets.QPushButton("Step")
        btn_reset = QtWidgets.QPushButton("Reset")
        btn_stop = QtWidgets.QPushButton("Stop")

        hl.addWidget(btn_new)
        hl.addWidget(btn_del)
        hl.addWidget(btn_loadasm)
        hl.addWidget(btn_loadprog)
        hl.addStretch()
        hl.addWidget(btn_run)
        hl.addWidget(btn_step)
        hl.addWidget(btn_stop)
        hl.addWidget(btn_reset)
        layout.addLayout(hl)

        # Split main area: left = table/instructions, bottom = console; right = regs + memory
        hsplit = QtWidgets.QHBoxLayout()
        layout.addLayout(hsplit)

        # Left: table + console
        left_v = QtWidgets.QVBoxLayout()
        hsplit.addLayout(left_v, stretch=3)

        # Instruction table
        self.table = QtWidgets.QTableWidget(0, 5)
        self.table.setHorizontalHeaderLabels(["OPCODE", "RD", "RA", "RB", "IMMEDIATE"])
        self.table.horizontalHeader().setSectionResizeMode(QtWidgets.QHeaderView.Stretch)
        self.table.verticalHeader().setVisible(False)
        left_v.addWidget(self.table)

        # console
        self.console = QtWidgets.QTextEdit()
        self.console.setReadOnly(True)
        left_v.addWidget(self.console, stretch=1)

        # Right: registers and memory
        right_v = QtWidgets.QVBoxLayout()
        hsplit.addLayout(right_v, stretch=1)

        # Registers group
        grp_regs = QtWidgets.QGroupBox("Registers")
        regs_layout = QtWidgets.QGridLayout()
        grp_regs.setLayout(regs_layout)
        self.reg_labels = {}
        for i in range(8):
            lbl_name = QtWidgets.QLabel(f"R{i}:")
            lbl_val = QtWidgets.QLabel("0.0")
            lbl_val.setFrameStyle(QtWidgets.QFrame.Panel | QtWidgets.QFrame.Sunken)
            regs_layout.addWidget(lbl_name, i, 0)
            regs_layout.addWidget(lbl_val, i, 1)
            self.reg_labels[f"R{i}"] = lbl_val
        right_v.addWidget(grp_regs)

        # PC / status
        status_group = QtWidgets.QGroupBox("Status")
        status_layout = QtWidgets.QVBoxLayout()
        status_group.setLayout(status_layout)
        self.lbl_pc = QtWidgets.QLabel("PC=0")
        self.lbl_steps = QtWidgets.QLabel("Steps=0")
        self.lbl_halted = QtWidgets.QLabel("Halted=True")
        status_layout.addWidget(self.lbl_pc)
        status_layout.addWidget(self.lbl_steps)
        status_layout.addWidget(self.lbl_halted)
        right_v.addWidget(status_group)

        # Memory view (first MEM_DISPLAY words)
        mem_group = QtWidgets.QGroupBox(f"Memory (0..{MEM_DISPLAY-1})")
        mem_layout = QtWidgets.QVBoxLayout()
        mem_group.setLayout(mem_layout)
        self.mem_table = QtWidgets.QTableWidget(MEM_DISPLAY, 2)
        self.mem_table.setHorizontalHeaderLabels(["Addr", "Value"])
        self.mem_table.horizontalHeader().setSectionResizeMode(0, QtWidgets.QHeaderView.ResizeToContents)
        self.mem_table.horizontalHeader().setSectionResizeMode(1, QtWidgets.QHeaderView.Stretch)
        self.mem_table.verticalHeader().setVisible(False)
        for i in range(MEM_DISPLAY):
            addr_item = QtWidgets.QTableWidgetItem(str(i))
            addr_item.setFlags(addr_item.flags() & ~QtCore.Qt.ItemIsEditable)
            self.mem_table.setItem(i, 0, addr_item)
            self.mem_table.setItem(i, 1, QtWidgets.QTableWidgetItem("0.0"))
        mem_layout.addWidget(self.mem_table)
        right_v.addWidget(mem_group, stretch=1)

        # Signals
        btn_new.clicked.connect(self.create_row)
        btn_del.clicked.connect(self.delete_selected_row)
        btn_loadasm.clicked.connect(self.load_asm_file)
        btn_loadprog.clicked.connect(self.load_program)
        btn_run.clicked.connect(self.run_program)
        btn_step.clicked.connect(self.step_program)
        btn_reset.clicked.connect(self.reset_sim)
        btn_stop.clicked.connect(self.stop_run)

    # -------------------------
    # Tabela / edição
    # -------------------------
    def create_row(self, opcode=None, rd="R0", ra="R0", rb="R0", imm="0x00000000"):
        """Adiciona uma nova linha com widgets."""
        r = self.table.rowCount()
        self.table.setRowCount(r+1)

        # OPCODE combobox (alphabetical)
        cb_op = ClickOnlyComboBox()
        cb_op.addItems(OPCODES)
        if opcode:
            # find index case-insensitive to avoid mismatches like "ADDi" vs "ADDI"
            idx = -1
            target = opcode.strip()
            for i in range(cb_op.count()):
                if cb_op.itemText(i).upper() == target.upper():
                    idx = i
                    break
            if idx >= 0:
                cb_op.setCurrentIndex(idx)
        self.table.setCellWidget(r, 0, cb_op)

        # RD,RA,RB comboboxes
        for c, reg in enumerate((rd, ra, rb), start=1):
            cb = ClickOnlyComboBox()
            cb.addItems(REG_NAMES)
            idx = cb.findText(reg.upper()) if reg else 0
            if idx >= 0:
                cb.setCurrentIndex(idx)
            self.table.setCellWidget(r, c, cb)

        # Immediate lineedit
        le = QtWidgets.QLineEdit()
        le.setText(str(imm))
        self.table.setCellWidget(r, 4, le)

        # row number as vertical header text that starts at 0
        self.update_row_numbers()

    def delete_selected_row(self):
        sel = self.table.selectionModel().selectedRows()
        rows = sorted([s.row() for s in sel], reverse=True)
        if not rows:
            # delete last row if none selected
            if self.table.rowCount() > 0:
                self.table.removeRow(self.table.rowCount()-1)
        else:
            for r in rows:
                self.table.removeRow(r)
        self.update_row_numbers()

    def update_row_numbers(self):
        # vertical header to show 0..N-1 with 'tmp(i) :=' style maybe
        for i in range(self.table.rowCount()):
            self.table.setVerticalHeaderItem(i, QtWidgets.QTableWidgetItem(str(i)))

    # -------------------------
    # Loading program from GUI table
    # -------------------------
    def load_program(self):
        """Lê a tabela, normaliza immediatos e carrega na simulação."""
        prog = []
        for r in range(self.table.rowCount()):
            cb_op = self.table.cellWidget(r, 0)
            cb_rd = self.table.cellWidget(r, 1)
            cb_ra = self.table.cellWidget(r, 2)
            cb_rb = self.table.cellWidget(r, 3)
            le_imm = self.table.cellWidget(r, 4)
            if None in (cb_op, cb_rd, cb_ra, cb_rb, le_imm):
                self.console_append(f"Row {r}: widgets missing, skipping.")
                continue
            op = cb_op.currentText().strip().upper()
            rd = cb_rd.currentText().strip().upper()
            ra = cb_ra.currentText().strip().upper()
            rb = cb_rb.currentText().strip().upper()
            imm_token = le_imm.text().strip()

            word, fval, hexs, raw = parse_immediate_field(imm_token)

            # Normalização segura:
            if op in ADDRESS_OPS:
                # If immediate was hex-literal, interpret as integer address
                if raw.startswith('x"') or raw.lower().startswith('0x'):
                    addr = int(word & 0xFFFFFFFF)
                    if addr >= self.sim.mem_size:
                        self.console_append(f"Warning: row {r} addr {addr} out of mem range; truncated.")
                        addr = addr % self.sim.mem_size
                    imm_word = addr
                    imm_float = float(addr)
                    imm_hex = f'0x{imm_word:08X}'
                    self.console_append(f"Notice: row {r} opcode {op}: parsed hex immediate {raw} as address {imm_word}.")
                else:
                    # numeric input: if user wrote a float-like number, round to nearest int for address
                    try:
                        addr = int(round(fval))
                        if addr < 0 or addr >= self.sim.mem_size:
                            self.console_append(f"Warning: row {r} address {addr} out of range; clamped.")
                            addr = max(0, min(addr, self.sim.mem_size - 1))
                        imm_word = addr
                        imm_float = float(addr)
                        imm_hex = f'0x{imm_word:08X}'
                        self.console_append(f"Notice: row {r} opcode {op}: numeric immediate '{imm_token}' -> address {imm_word}.")
                    except Exception:
                        imm_word = int(word & 0xFFFFFFFF)
                        imm_float = float(imm_word)
                        imm_hex = f'0x{imm_word:08X}'
            else:
                # ULA/FP immediates: keep as float bits (word contains proper IEEE754 bits when user wrote float or hex float)
                imm_word = int(word & 0xFFFFFFFF)
                imm_float = float(fval)
                imm_hex = hexs

            prog.append({
                "opcode": op,
                "rd": rd,
                "ra": ra,
                "rb": rb,
                "imm_word": imm_word,
                "imm_float": imm_float,
                "imm_hex": imm_hex,
                "imm_raw": raw
            })

        # Reset sim and load
        self.sim.reset()
        self.sim.load_program(prog)
        self.update_view()
        self.console_append(f">>> Programa carregado ({len(prog)} instruções)")

    # -------------------------
    # .asm loader (VHDL-like) + novo parser estilo assembly com labels
    # -------------------------
    def load_asm_file(self):
        """
        Suporta:
         - o formato VHDL-like já existente (tmp(i) := ...)
         - OU um formato assembly mais legível:
            * comentários com '#' ou '--' ou ';'
            * labels terminando em ':' (ex: .loop_start:)
            * instruções como: LDI R2, 1.2
            * STM [0], R3  -> salva R3 em memória[0]
            * JEQ R7, R0, .end  -> terceiro operando pode ser label
            * JMP .loop_start
        O parser faz duas passadas quando encontra sintaxe assembly (labels).
        """
        path, _ = QtWidgets.QFileDialog.getOpenFileName(self, "Open .asm file", "", "ASM Files (*.asm *.txt);;All files (*)")
        if not path:
            return
        try:
            with open(path, "r", encoding="utf-8") as f:
                lines = f.readlines()
        except Exception as e:
            QtWidgets.QMessageBox.critical(self, "Error", f"Failed to open file: {e}")
            return

        # Try to detect which format the file uses.
        # If it contains ':=' then use the old VHDL-like parser; otherwise use assembly-style parser.
        raw_text = "".join(lines)
        if ':=' in raw_text:
            # Use existing VHDL-like parsing (kept behavior)
            self.table.setRowCount(0)
            for lineno, raw in enumerate(lines):
                code = raw.split('--', 1)[0].strip()
                if not code:
                    continue
                if code.endswith(';'):
                    code = code[:-1].rstrip()
                if ':=' not in code:
                    continue
                left, right = code.split(':=', 1)
                parts = [p.strip() for p in right.split('&')]
                if len(parts) < 5:
                    self.console_append(f"Skipping malformed line {lineno+1}: {raw.strip()}")
                    continue
                opcode = parts[0].split()[0].strip().upper()
                rd = parts[1].split()[0].strip()
                ra = parts[2].split()[0].strip()
                rb = parts[3].split()[0].strip()
                imm_token = parts[4].split()[0].strip()

                def norm_reg(x):
                    x = x.strip()
                    if not x:
                        return "R0"
                    if x.upper().startswith('R'):
                        return x.upper()
                    try:
                        v = int(x, 0)
                        return f"R{v & 7}"
                    except:
                        return x.upper()

                rd_norm = norm_reg(rd)
                ra_norm = norm_reg(ra)
                rb_norm = norm_reg(rb)
                self.create_row(opcode, rd_norm, ra_norm, rb_norm, imm_token)

            self.update_row_numbers()
            self.console_append(f">>> .asm parsed (VHDL-like) and placed into table: {path}")
            self.load_program()
            return

        # Otherwise: assembly-style parser with labels (two-pass)
        def strip_comment(s):
            # find earliest comment token
            for c in ('#', '--', ';'):
                idx = s.find(c)
                if idx != -1:
                    s = s[:idx]
            return s.strip()

        def tokenize_instr(s):
            # Normalize commas and split. Keep bracket tokens like [0] intact.
            s2 = s.replace(',', ' ')
            parts = [p for p in s2.split() if p != '']
            return parts

        # First pass: collect labels and raw instructions
        labels = {}   # key: label_name (without leading dot), value: instr_index
        parsed = []   # list of dicts: {lineno, opcode, tokens}
        instr_index = 0
        for lineno, raw in enumerate(lines, start=1):
            code = strip_comment(raw)
            if not code:
                continue

            # Label-only line?
            if code.endswith(':'):
                lbl = code[:-1].strip()
                if lbl:
                    lbl_key = lbl.lstrip('.')
                    labels[lbl_key] = instr_index
                continue

            # Inline label: "label: INSTR ..."
            if ':' in code:
                left, right = code.split(':', 1)
                lbl = left.strip()
                if lbl:
                    lbl_key = lbl.lstrip('.')
                    labels[lbl_key] = instr_index
                code = right.strip()
                if not code:
                    continue

            # Instruction line
            tokens = tokenize_instr(code)
            if not tokens:
                continue
            opcode = tokens[0].upper()
            rest = tokens[1:]
            parsed.append({"lineno": lineno, "opcode": opcode, "tokens": rest})
            instr_index += 1

        # Second pass: convert parsed instructions into table rows
        self.table.setRowCount(0)

        def norm_reg(x):
            x = (x or "").strip()
            if not x:
                return "R0"
            if x.upper().startswith('R'):
                return x.upper()
            try:
                v = int(x, 0)
                return f"R{v & 7}"
            except:
                return x.upper()

        def imm_from_token(tok):
            tok = (tok or "").strip()
            if not tok:
                return '0x00000000'
            # bracket form [0]
            if tok.startswith('[') and tok.endswith(']'):
                inner = tok[1:-1].strip()
                return inner
            # direct numeric or hex will be handled later by parse_immediate_field
            # token might be a label with optional leading dot
            key = tok.lstrip('.')
            if key in labels:
                return str(labels[key])
            # also accept plain label without dot
            if tok in labels:
                return str(labels[tok])
            # fallback: return raw token (could be numeric)
            return tok

        for instr in parsed:
            lineno = instr["lineno"]
            op = instr["opcode"]
            toks = instr["tokens"]

            # defaults
            rd = "R0"
            ra = "R0"
            rb = "R0"
            imm = "0x00000000"

            try:
                if op == "LDI":
                    # LDI R2, 1.2
                    if len(toks) >= 1:
                        rd = norm_reg(toks[0])
                    if len(toks) >= 2:
                        imm = imm_from_token(toks[1])
                    self.create_row("LDI", rd, "R0", "R0", imm)
                elif op == "MOV":
                    # MOV R4, R2
                    if len(toks) >= 1:
                        rd = norm_reg(toks[0])
                    if len(toks) >= 2:
                        rb = norm_reg(toks[1])
                    self.create_row("MOV", rd, "R0", rb, "0.0")
                elif op == "STM":
                    # STM [0], R3  -> create_row("STM", "R0", src_reg, "R0", addr)
                    addr_token = None
                    src_reg = "R0"
                    if len(toks) == 1:
                        t0 = toks[0]
                        if t0.startswith('[') and t0.endswith(']'):
                            addr_token = imm_from_token(t0)
                        else:
                            # ambiguous: assume stm addr,src omitted -> skip
                            src_reg = norm_reg(t0)
                    else:
                        addr_token = imm_from_token(toks[0])
                        src_reg = norm_reg(toks[1])
                    if addr_token is None:
                        addr_token = "0"
                    self.create_row("STM", "R0", src_reg, "R0", addr_token)
                elif op == "LDM":
                    # LDM R1, [0]
                    if len(toks) >= 1:
                        rd = norm_reg(toks[0])
                    if len(toks) >= 2:
                        imm = imm_from_token(toks[1])
                    self.create_row("LDM", rd, "R0", "R0", imm)
                elif op in ("ADD", "SUB", "MUL", "DIV"):
                    # ADD R6, R5, R5
                    if len(toks) >= 1:
                        rd = norm_reg(toks[0])
                    if len(toks) >= 2:
                        ra = norm_reg(toks[1])
                    if len(toks) >= 3:
                        rb = norm_reg(toks[2])
                    self.create_row(op, rd, ra, rb, "0.0")
                elif op.upper() in ("ADDI", "ADDi"):
                    # ADDi R6, R6, 2.0
                    if len(toks) >= 1:
                        rd = norm_reg(toks[0])
                    if len(toks) >= 2:
                        ra = norm_reg(toks[1])
                    if len(toks) >= 3:
                        imm = imm_from_token(toks[2])
                    # put imm into immediate field; rb left as R0 (it's unused)
                    self.create_row("ADDI", rd, ra, "R0", imm)
                elif op == "JEQ":
                    # JEQ R7, R0, .end
                    if len(toks) >= 1:
                        ra = norm_reg(toks[0])
                    if len(toks) >= 2:
                        rb = norm_reg(toks[1])
                    if len(toks) >= 3:
                        imm = imm_from_token(toks[2])
                    self.create_row("JEQ", "R0", ra, rb, imm)
                elif op == "JMP":
                    # JMP .loop_start
                    if len(toks) >= 1:
                        imm = imm_from_token(toks[0])
                    self.create_row("JMP", "R0", "R0", "R0", imm)
                else:
                    # generic fallback: try rd, ra, rb, imm
                    if len(toks) >= 1:
                        rd = norm_reg(toks[0])
                    if len(toks) >= 2:
                        ra = norm_reg(toks[1])
                    if len(toks) >= 3:
                        rb = norm_reg(toks[2])
                    if len(toks) >= 4:
                        imm = imm_from_token(toks[3])
                    self.create_row(op, rd, ra, rb, imm)
            except Exception as e:
                self.console_append(f"Error parsing line {lineno}: {e}")

        self.update_row_numbers()
        self.console_append(f">>> .asm parsed (assembly-style) and placed into table: {path}")
        # auto-load program to validate immediately
        self.load_program()

    # -------------------------
    # Simulation control
    # -------------------------
    def run_program(self):
        if self.sim.halted:
            self.console_append("Program is halted or not loaded.")
            return
        if self._running:
            self.console_append("Already running.")
            return
        self._running = True
        self._run_timer.start(0)  # run as fast as possible (0ms)

    def _run_step(self):
        # single step by timer
        ok = self.sim.step(console_append=self.console_append)
        self.update_view()
        if not ok:
            self._run_timer.stop()
            self._running = False
            self.console_append("Program halted or finished.")

    def step_program(self):
        if self.sim.halted:
            self.console_append("Program is halted or not loaded.")
            return
        ok = self.sim.step(console_append=self.console_append)
        self.update_view()
        if not ok:
            self.console_append("Program halted or finished.")

    def stop_run(self):
        if self._running:
            self._run_timer.stop()
            self._running = False
            self.console_append("Run stopped by user.")

    def reset_sim(self):
        self.stop_run()
        self.sim.reset()
        self.update_view()
        self.console_append("Simulator reset.")

    # -------------------------
    # UI update helpers
    # -------------------------
    def update_view(self):
        # registers
        self.update_register_view()
        # mem table
        self.update_memory_view()
        # status
        self.lbl_pc.setText(f"PC={self.sim.pc}")
        self.lbl_steps.setText(f"Steps={self.sim.steps}")
        self.lbl_halted.setText(f"Halted={self.sim.halted}")

    def update_register_view(self):
        for i in range(8):
            v = self.sim.registers[i]
            text = f"{v:.8g}"
            self.reg_labels[f"R{i}"].setText(text)

    def update_memory_view(self):
        for i in range(MEM_DISPLAY):
            v = self.sim.memory[i]
            it = self.mem_table.item(i, 1)
            if it is None:
                it = QtWidgets.QTableWidgetItem()
                self.mem_table.setItem(i, 1, it)
            it.setText(f"{v:.8g}")

    def console_append(self, text: str):
        self.console.append(str(text))
        # scroll to bottom
        sb = self.console.verticalScrollBar()
        sb.setValue(sb.maximum())

# -------------------------
# main
# -------------------------
def main():
    app = QtWidgets.QApplication(sys.argv)
    win = IarithUI()
    # populate with a few rows default to help user
    win.create_row("LDI", "R1", "R0", "R0", 'x"00000000"')
    win.create_row("STM", "R0", "R1", "R0", 'x"00000001"')
    win.create_row("LDI", "R2", "R0", "R0", 'x"3F800000"')
    win.create_row("STM", "R0", "R2", "R0", 'x"00000002"')
    win.update_row_numbers()
    win.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
