# Gemini → QEMU → xv6 with Kernel Taint Enforcement

This repository implements **kernel-enforced taint tracking** in xv6, integrated with a Gemini AI agent running over a QEMU serial pipeline.

```text
User instruction
  → Gemini chooses a tool (list_files, read_file, mark_file, taint_status, try_write)
  → Python validates the tool call and arguments
  → QEMU serial console
  → persistent agent_worker inside xv6
  → xv6 kernel executes or enforces taint policy
  → result returns to Gemini
  → final answer
```

For the complete architectural design, see [ARCHITECTURE.md](ARCHITECTURE.md).  
For viva preparation, design defenses, and test breakdowns, see [VIVA_GUIDE.md](VIVA_GUIDE.md).

---

## What We Built

1. **Kernel Taint Subsystem:**
   - On-disk persistent inode taint marking (`short untrusted` in `struct dinode` with `NDIRECT 11`, keeping size at 64 bytes).
   - System calls: `marktaint(path)` (23) and `istainted()` (24).
   - Dynamic taint propagation across file reads, process `fork()`, `exec()`, and IPC pipes.
   - Kernel policy enforcement:
     - Tainted processes **cannot** write to clean files (write-down blocked).
     - Tainted processes **cannot** call `unlink()`.
     - Tainted processes **can only** execute binaries located under `/safe/`.
     - Console writes and pipe writes remain permitted.
2. **AI Agent Pipeline:**
   - 5 structured Gemini tools: `list_files`, `read_file`, `mark_file`, `taint_status`, `try_write`.
   - Host Python validator rejecting malformed paths and unpermitted operations.
   - Persistent `agent_worker` communicating over serial with framed `@XV6` messages.

---

## Running the Demos

### 1. Deterministic Taint Enforcement Demo (No Gemini needed)

This runs a 5-step demonstration proving kernel enforcement:
1. Marks `/inbox.txt` untrusted.
2. Reads `/inbox.txt` (the worker becomes tainted).
3. Queries taint status (verifies `tainted: true`).
4. Attempts to write to `/clean.txt` (the xv6 kernel blocks the write).
5. Reads `/clean.txt` to confirm its contents are pristine.

```bash
python3 -m agent.main --taint-demo
```

### 2. Scripted Interactive Mode

Issue manual commands using the same validated protocol:

```bash
python3 -m agent.main --scripted
```

Available commands:
- `list [PATH]` — list directory (default: `/`)
- `read PATH` — read file contents
- `taint PATH` — mark a file untrusted
- `status` — check if worker process is tainted
- `write PATH` — attempt to write test string to file
- `exit` — quit

### 3. Read-Only Scripted Demo

```bash
python3 -m agent.main --demo
```

### 4. Live Gemini Agent Mode

Set up your virtual environment and `.env`:

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r agent/requirements.txt
```

Put your key in `.env`:
```dotenv
GEMINI_API_KEY=your_actual_api_key
GEMINI_MODEL=gemini-flash-latest
```

Then start the agent:
```bash
.venv/bin/python -m agent.main
```

Example prompts:
- *"Read /report.txt and summarize it."*
- *"Mark /inbox.txt as untrusted, then read it and tell me your taint status."*
- *"Try to write to /clean.txt and tell me what happened."*

---

## Automated Tests

Run the test suite:

```bash
python3 -m unittest agent.test_pipeline -v
```

This verifies:
- Path and tool schema validation.
- Tool loop error handling and state tracking.
- The 5-step taint enforcement sequence.
- Live QEMU round trip (when QEMU is present).

In xv6 directly, all kernel test programs are compiled into the filesystem:
- `taint_basic` — basic marking and idempotency
- `taint_fork` — fork inheritance and zero-byte reads
- `taint_exec` — `/safe/` prefix validation and taint survival across exec
- `taint_probe` — verification helper for exec
- `taint_pipe` — pipe propagation and clean/tainted shared writer races
- `taint_policy` — write-down and unlink enforcement
- `taint_launder` — `dup` and inode reuse attack defenses
