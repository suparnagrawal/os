# Gemini → QEMU → xv6

This is a small teaching pipeline:

```text
User instruction
  → Gemini chooses list_files or read_file
  → Python validates the tool call
  → QEMU serial console
  → agent_worker inside xv6
  → xv6 open/read system calls
  → result returns to Gemini
  → final answer
```

The current milestone is read-only. Kernel taint tracking comes later.

For the complete architecture explanation, see [ARCHITECTURE.md](ARCHITECTURE.md).
For viva preparation and detailed code walkthrough, see
[VIVA_GUIDE.md](VIVA_GUIDE.md).

## Run without Gemini

This proves that Python can reach the real xv6 guest:

```bash
python3 -m agent.main --demo
```

It lists `/`, reads `/report.txt`, and shows the error for `/missing.txt`.

You can also issue simple commands yourself:

```bash
python3 -m agent.main --scripted
```

Then enter `list /`, `read /report.txt`, or `exit`.

## Run with Gemini

Install the dependencies once:

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r agent/requirements.txt
```

Put your key and model in the project-root `.env` file:

```dotenv
GEMINI_API_KEY=your_actual_api_key
GEMINI_MODEL=gemini-flash-latest
```

`.env` is ignored by Git. Then start the agent:

```bash
.venv/bin/python -m agent.main
```

Example instructions:

```text
List the files in xv6.
Read /report.txt.
Read /report.txt and summarize it.
Read /missing.txt.
```

The terminal displays the Gemini tool call, the actual xv6 result, and the final
answer. Type `exit` to stop.

## Main files

- `agent/main.py` — terminal input and Gemini function-calling loop.
- `agent/bridge.py` — starts QEMU and exchanges serial messages with xv6.
- `agent_worker.c` — persistent xv6 process that performs `LIST` and `READ`.
- `report.txt` — sample content included in the guest filesystem.
- `Makefile` — builds `agent_worker` and the separate `agent-fs.img`.

The bridge uses temporary copies of `xv6.img` and `agent-fs.img`, so the original
images stay unchanged and another QEMU window can remain open.

## Small serial protocol

```text
Python → xv6:  READ /report.txt
xv6 → Python: @XV6 DATA <hex-encoded bytes>
xv6 → Python: @XV6 DONE OK
```

Hex encoding prevents file text from being confused with protocol messages.
Requests run one at a time. Output is limited to 4096 bytes.

## Tests

```bash
.venv/bin/python -m unittest agent.test_pipeline -v
```

The small test suite checks tool validation, the Gemini tool loop using mocked
responses, and the real QEMU list/read/error round trip.

For the presentation, show a successful summary and a missing-file error, then
explain that the next stage adds taint tracking and kernel enforcement.
