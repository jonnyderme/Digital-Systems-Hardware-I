# 💻 Digital Systems Hardware I
### ⚙️ Digital Systems Design – 🖥️ RISC-V Processor Design Coursework (2023)
Assignment for the "Digital Systems Hardware I" Course  
Faculty of Engineering, AUTh  
School of Electrical and Computer Engineering  
Electronics and Computers Department

📚 *Course:* Digital Systems Hardware I  
🏛️ *Faculty:* AUTh - School of Electrical and Computer Engineering  
📅 *Semester:* 7th Semester, 2023–2024

---

## 📚 Table of Contents
- [Overview](#overview)
- [Task Summary](#task-summary)
- [Modules](#modules)
- [Testbenches](#testbenches)
- [Deliverables](#deliverables)
- [Repository Structure](#repository-structure)

---

## 🧠 Overview

This project involves designing a modular, cycle-accurate RISC-V processor in Verilog HDL.  
The implementation spans 5 exercises, gradually building a complete datapath with control unit, ALU, register file, and memory access handling — all verified through simulation.

---

## 🎯 Task Summary

- **Exercise 1**: Implement a 32-bit ALU supporting arithmetic, logic, shift, and comparison operations.
- **Exercise 2**: Design a 16-bit accumulator-based calculator with button-controlled operations.
- **Exercise 3**: Create a 32x32 register file module with read/write ports.
- **Exercise 4**: Build the processor's datapath supporting instruction fetch, decode, execute, memory, and write-back phases.
- **Exercise 5**: Implement a multicycle controller using a 5-state FSM for instruction execution and signal generation.

---

## 🧩 Modules

- `alu.v`: 32-bit ALU with 9 operations
- `calc.v`, `calc_enc.v`: Calculator integrating ALU and decoder
- `regfile.v`: Register file with 2 read and 1 write port
- `datapath.v`: Datapath implementing instruction decode and execution
- `top_proc.v`: Top-level multicycle CPU controller and datapath integration

---

## 🧪 Testbenches

- `calc_tb.v`: Simulates all button sequences and operations
- `top_proc_tb.v`: Simulates all RISC-V instructions: R, I, S, B types (e.g. `ADD`, `LW`, `BEQ`)

---

## 📄 Deliverables

Submit a **PDF report** including:
- All Verilog code listings
- FSM diagram for the multicycle processor
- Simulation waveforms for Exercises 2 & 5
- Short methodology for each task  
📌 Deadline: **January 21, 2024 – 23:59**, via eLearning  
📌 The project is individual and graded over 30 points (30% of final course grade)

---

## 📁 Repository Structure
```
├── Verilog_Files/alu.v                # Exercise 1 – ALU module
├── Verilog_Files/calc.v               # Exercise 2 – Calculator (main)
├── Verilog_Files/calc_enc.v           # Exercise 2 – Button decoder
├── Verilog_Files/calc_tb.v            # Exercise 2 – Testbench
├── Verilog_Files/regfile.v            # Exercise 3 – Register file
├── Verilog_Files/datapath.v           # Exercise 4 – RISC-V datapath
├── Verilog_Files/top_proc.v           # Exercise 5 – Multicycle controller (top module)
├── Verilog_Files/top_proc_tb.v        # Exercise 5 – Final CPU testbench
├── report.pdf           # Coursework report with waveforms and FSM
└── README.md            # This documentation
```

