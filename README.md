# UART UVM Verification

Production-style **UVM-based verification environment** for a UART Transmitter/Receiver with parity handling, frame error detection, multi-baud-rate validation, assertions, and functional coverage.

This project is built to reflect **real ASIC Design Verification workflows**, not academic demos.

---

## 📌 Project Highlights

- Full-duplex UART (RX + TX loopback)
- Configurable **parity enable/disable**
- **Parity error** and **frame error** detection
- Multi-baud-rate validation (9600 / 10102 / 115200)
- UVM 1.2 compliant architecture
- Functional coverage with cross coverage
- Assertion-based protocol checks
- Regression-ready test setup

---

## 🧱 Project Structure

```
UART_UVM_Verification/
├── docs/
│   ├── coverage_summart.png
│   ├── uart_sim_log.txt
│   └── uart_waveform.png
│
├── rtl/
│   ├── uart_rx.sv          # RX FSM with parity & frame error detection
│   ├── uart_tx.sv          # TX FSM with parity generation
│   └── uart_top.sv         # Top-level wrapper (RX + TX loopback)
│
├── tb/
│   └── tb.sv               # Testbench top with clock, DUT, VCD dump
│
├── interface/
│   └── uart_interface.sv   # Interface with properties, assertions, coverage
│
├── transaction/
│   └── uart_txn.sv # Transaction class with constraints
│
├── agent/
│   ├── uart_agent.sv       # Agent (driver + monitor + sequencer)
│   ├── uart_sequencer.sv   # Sequencer
│   ├── uart_driver.sv      # Active driver
│   └── uart_monitor.sv     # Passive monitor
│
├── env/
│   ├── uart_scoreboard.sv  # TX vs RX comparison
│   ├── uart_coverage.sv    # Covergroup definitions
│   └── uart_env.sv         # Environment (agent + scoreboard + coverage)
│
├── sequences/
│   ├── uart_sequence.sv    # Base sequence
│   ├── uart_back_to_back_seq.sv    # 2 sequential transactions
│   ├── uart_repeat10_seq.sv        # 10 randomized transactions
│   ├── uart_baud_rate_seq.sv       # Multi-baud-rate validation
│   ├── uart_frame_error_seq.sv     # Frame error injection
│   ├── uart_parity_error_seq.sv    # Parity error injection
│   └── uart_virtual_seq.sv         # Combined virtual sequence
│
├── tests/
│   ├── uart_base_test.sv
│   └── uart_package.sv     # UVM package
│
├── sim/
│   └── uart_virtual_test.log       # Full regression output
├── sim/
│   ├── uart_back_to_back_seq.png
│   ├── uart_repeat10_seq.png
│   ├── uart_baud_rate_seq.png
│   ├── uart_frame_error_seq.png
│   ├── uart_parity_error_seq.png
│   └── uart_virtual_seq.png
│
└── README.md
```

---

## 🔧 UART Features Verified

- 8-bit data frame
- Start bit and stop bit handling
- Optional parity bit
- Parity mismatch detection
- Stop-bit (frame) error detection
- Baud-rate dependent timing accuracy

---

## 🧪 Verification Architecture

### Transaction
- Data (`tx_data`, `rx_data`)
- Parity enable
- Baud rate & clock-per-bit
- Error injection controls
- Observed error flags

### Driver
- Bit-accurate UART driving
- Start → Data → Parity → Stop sequencing
- Parity & frame error injection
- Timing based on `clk_per_bit`

### Monitor
- Passive sampling of RX
- Start edge detection
- Mid-bit sampling
- Parity and stop-bit validation
- Sends transactions via analysis port

### Scoreboard
- TX vs RX data comparison
- Pass/fail accounting
- Error reporting with transaction details

### Coverage
- Parity enable/disable
- Parity error / frame error
- Baud rate coverage
- Data pattern bins
- Cross coverage:
  - Baud × Error
  - Parity × Error
  - Baud × Data

---

## 🧠 Assertions (SVA)

Implemented inside `uart_interface.sv`:

- Reset clears all status flags
- RX valid only when RX line stable
- TX valid only when TX idle
- Frame error asserted only on invalid stop bit

Assertions are **always-on** and run during regression.

---

## ▶️ Simulation Flow

### Compile (VCS example)

```bash
vcs -sverilog -full64 \
    -timescale=1ns/1ps \
    rtl/*.sv \
    interface/*.sv \
    transaction/*.sv \
    agent/*.sv \
    env/*.sv \
    sequences/*.sv \
    tests/*.sv \
    tb/tb.sv \
    -top tb
```

### Run Tests

```bash
./simv +UVM_TESTNAME=uart_back_to_back_test
./simv +UVM_TESTNAME=uart_repeat10_test
./simv +UVM_TESTNAME=uart_baud_rate_test
./simv +UVM_TESTNAME=uart_frame_error_test
./simv +UVM_TESTNAME=uart_parity_error_test
./simv +UVM_TESTNAME=uart_virtual_test
```

### Enable Verbose Logs

```bash
./simv +UVM_TESTNAME=uart_virtual_test +UVM_VERBOSITY=UVM_HIGH
```

---

## 📊 Verification Results

| Test | Transactions | Status |
|------|--------------|--------|
| Back-to-Back | 2 | ✅ PASS |
| Repeat-10 | 10 | ✅ PASS |
| Baud-Rate | 15 | ✅ PASS |
| Frame-Error | 2 | ✅ PASS |
| Parity-Error | 2 | ✅ PASS |
| Virtual Regression | 31 | ✅ PASS |

- Zero scoreboard mismatches
- All assertions passed
- 100% functional coverage achieved in regression

---

## 🚀 Why This Project Matters

- **Real UVM architecture** (agent/env/scoreboard/coverage)
- **Protocol-level verification**, not signal poking
- **Error injection** + coverage-driven closure
- **Clean separation** of RTL and verification
- **Interview-ready** ASIC DV portfolio project

If a company works on UART / SPI / I2C / APB, this directly applies.

---

## 🧩 Known Limitations

- No RTS/CTS flow control
- No FIFO buffering
- Single-channel loopback only
- Fixed system clock

These are deliberate, not mistakes.

## 👤 Author

**Brahma Ganesh Katrapalli**

ASIC Design Verification  
SystemVerilog | UVM | Assertions | Coverage

---

## ✅ Status

- **Project**: Complete
- **Coverage**: 100%
- **Interview Ready**: Yes

---
