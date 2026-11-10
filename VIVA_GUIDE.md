# CSL3030 Operating Systems Lab — Taint Tracking Viva Guide & Technical Report

**Project:** Taint-Following Capabilities in xv6 with AI-Agent Enforcement  
**Team Members:** Priyam, Abhishek, Suparn, Aryan  
**Institute:** Department of Computer Science & Engineering, IIT Jodhpur  

---

## 1. Executive Summary & Architecture

The objective of this project is to implement **mandatory, kernel-enforced taint tracking** in xv6 to protect against prompt injection and untrusted data manipulation in autonomous AI agent workflows.

```
       AI Agent (Gemini)
               │ structured tool call (JSON)
               ▼
   Host Python Bridge (Ubuntu)
               │ validated request over serial UART
               ▼
  Guest Worker (agent_worker in xv6)
               │ system calls (read, write, exec, marktaint)
               ▼
 ╔═══════════════════════════════════════════════════════════╗
 ║                xv6 KERNEL TAINT SUBSYSTEM                 ║
 ║  • Proc state:   proc->tainted                            ║
 ║  • Inode state:  inode->untrusted (persisted on disk)     ║
 ║  • Pipe state:   pipe->tainted                            ║
 ║  • Enforcement:  write-down blocked, unlink blocked,      ║
 ║                  exec restricted to /safe/                ║
 ╚═══════════════════════════════════════════════════════════╝
```

The AI agent cannot bypass the policy because enforcement happens **below user space in the kernel**.

---

## 2. Kernel Design & Data Structures

### 2.1 Disk Layout & Inode Size Conservation
In xv6, `struct dinode` is exactly 64 bytes, ensuring `IPB = BSIZE / sizeof(struct dinode) = 512 / 64 = 8` (or 16 on 1KB blocks). Modifying its size breaks filesystem block math and causes data corruption.
- **Design Choice:** We chose **Option C** from the handout: reduced `NDIRECT` from 12 to 11 and added `short untrusted`.
- **Proof of Size Invariance:**
  ```c
  struct dinode {
    short type;              // 2 bytes
    short major;             // 2 bytes
    short minor;             // 2 bytes
    short nlink;             // 2 bytes
    uint size;               // 4 bytes
    short untrusted;         // 2 bytes  <-- Added taint flag
    short pad;               // 2 bytes  <-- Padding alignment
    uint addrs[NDIRECT+1];   // 12 * 4 = 48 bytes (NDIRECT=11)
  };                         // Total = 64 bytes (EXACT)
  ```
- **Lifecycle Persistence:**
  - `fs.c:ilock()` loads `ip->untrusted = dip->untrusted` from disk.
  - `fs.c:iupdate()` flushes `dip->untrusted = ip->untrusted` to disk.
  - `fs.c:ialloc()` clears `dip->untrusted = TAINT_NONE` on inode allocation.
  - Recreating a deleted file guarantees clean taint initialization.

### 2.2 In-Memory State
1. **Process (`struct proc` in `proc.h`):**
   - Added `int tainted;`
   - Initialized to `TAINT_NONE (0)` in `allocproc()`.
   - Once tainted, a process **never becomes clean** (one-way latch: "bytes cannot be un-read").
2. **In-Memory Inode (`struct inode` in `file.h`):**
   - Added `short untrusted;`
3. **Pipe (`struct pipe` in `pipe.c`):**
   - Added `int tainted;`
   - Initialized to 0 in `pipealloc()`.
   - **Crucial Design Rule:** Taint is kept on the `struct pipe` object, **never** on `struct file`. This ensures that file descriptor duplication (`dup()`) cannot defeat tracking.

---

## 3. System Calls Added

| Syscall Number | Prototype | Purpose |
|---|---|---|
| `SYS_marktaint` (23) | `int marktaint(const char *path)` | Traverses path using `namei()`, verifies regular file, marks `ip->untrusted = TAINT_UNTRUSTED`, writes to disk via `iupdate()`. |
| `SYS_istainted` (24) | `int istainted(void)` | Returns the calling process's `p->tainted` state (0 or 1). |

---

## 4. Taint Propagation Rules

1. **Read Propagation (`file.c:fileread`):**
   - When reading from a regular file (`T_FILE`), if `f->ip->untrusted == TAINT_UNTRUSTED` and bytes read `r > 0`, set `myproc()->tainted = TAINT_UNTRUSTED`.
   - Reading 0 bytes or failing to read does **not** contaminate the process.
2. **Process Fork (`proc.c:fork`):**
   - Child inherits parent's taint status: `np->tainted = curproc->tainted;`.
3. **Process Exec (`exec.c:exec`):**
   - Taint survives `exec()`: while code and address space are replaced, the process credentials persist.
4. **Pipes (`pipe.c:pipewrite` & `pipe.c:piperead`):**
   - In `pipewrite`: if writing process is tainted, mark `pipe->tainted = 1`.
   - In `piperead`: if `pipe->tainted` and bytes read `> 0`, mark reading process `myproc()->tainted = 1`.

---

## 5. Security Policies Enforced

Whenever a tainted process attempts a restricted action, the kernel **refuses it, returns -1, and logs exactly one line**:

1. **Write-Down Restriction (`file.c:filewrite`):**
   - A tainted process cannot write to an existing clean regular file (`f->ip->untrusted != TAINT_UNTRUSTED`).
   - *Kernel Log:* `filewrite: refused tainted write to clean file`
   - *Allowed writes:* pipes, console (`FD_DEV`), and already-untrusted files.
2. **Unlink Restriction (`sysfile.c:sys_unlink`):**
   - A tainted process cannot delete any file.
   - *Kernel Log:* `unlink: refused tainted unlink of <path>`
3. **Execution Restriction (`exec.c:exec`):**
   - A tainted process may only execute programs whose path begins strictly with `/safe/`.
   - Relative paths, root paths, or malicious prefixes like `/safeevil/...` are refused.
   - *Kernel Log:* `exec: refused tainted exec of <path>`
4. **File Creation Propagation (`sysfile.c:create`):**
   - When a tainted process creates a regular file, the new inode is automatically marked `untrusted = TAINT_UNTRUSTED`.

---

## 6. Laundering Attacks Defeated (6+ Required Scenarios)

| # | Laundering Attack Attempt | Exploitation Strategy | Defeating Kernel Mechanism |
|---|---|---|---|
| **1** | **Direct Clean File Overwrite** | Tainted agent attempts to write exfiltrated data or corrupt `/report.txt`. | `filewrite()` checks `f->ip->untrusted`; if clean, blocks write and returns -1. |
| **2** | **Descriptor Duplication (`dup`)** | Attacker opens clean file before taint, taints itself, dups fd to launder identity. | Taint check is performed at `filewrite()` on current process state, not at descriptor creation. |
| **3** | **Fork Laundering** | Tainted process forks a child hoping child starts with clean credentials. | `fork()` copies `np->tainted = curproc->tainted;`. |
| **4** | **Exec Laundering** | Tainted process calls `exec("/sh")` to replace binary image with clean shell. | `exec()` does not reset `tainted`; plus blocks executing any binary outside `/safe/`. |
| **5** | **Pipe Transfer** | `cat /inbox.txt \| helper` where helper hopes to stay clean. | `pipewrite()` marks `pipe->tainted = 1`; `piperead()` taints the reader. |
| **6** | **Shared-Writer Pipe Race** | Clean writer and tainted writer share a pipe; reader tries to claim clean origin. | Per-pipe taint treats any contaminated pipe as tainted; reader inherits taint upon reading. |
| **7** | **Inode Reuse / Re-creation** | Tainted file is unlinked; attacker tries to have newly created file inherit untrusted status, or delete & recreate to clear taint while tainted. | Tainted process cannot unlink (`sys_unlink` refusal). When clean process deletes and reallocates inode, `ialloc()` explicitly clears `untrusted = 0`. |

---

## 7. False-Positive Analysis

| Program / Workflow | Status Under Policy | Bug or Consequence? | Explanation & Defense |
|---|---|---|---|
| `cat /inbox.txt` | Works | Consequence | Reads and writes to console; console writes are explicitly permitted. |
| `cat /inbox.txt \| grep secret` | `grep` taints | Consequence | Intended behaviour: data flows through pipe, so consumer of untrusted data must become untrusted. |
| `rm /inbox.txt` by tainted shell | Fails (-1) | Consequence | Correct: tainted processes lose deletion capabilities to prevent anti-forensics. Clean admin must delete. |
| `echo hi > clean.txt` by tainted shell | Fails (-1) | Consequence | Correct: write-down prevention stops untrusted content from polluting trusted storage. |
| Pipe byte interleaving (clean byte read after tainted byte) | Fails (reader taints) | Conservative design | Per-pipe tracking taints the entire pipe. A byte-range model would avoid this but adds complex ring-buffer wrap tracking. Handout explicitly notes per-pipe tracking is preferred and defensible. |
| Executing `/bin/ls` while tainted | Fails (-1) | Consequence | Tainted processes can only execute under `/safe/`. Prevents untrusted data from invoking arbitrary tools. |

---

## 8. Division of Responsibilities

| Student | Assigned Core Area | Key Files Touched |
|---|---|---|
| **Priyam** | Core State, Inode Layout, Filesystem Lifecycle, Syscalls | `taint.h`, `proc.h`, `file.h`, `fs.h`, `fs.c`, `sysfile.c`, `sysproc.c`, `syscall.h`, `syscall.c`, `user.h`, `usys.S`, `taint_basic.c` |
| **Abhishek** | Read Propagation, Fork Inheritance, Exec Restrictions | `file.c` (read path), `proc.c` (`allocproc`, `fork`), `exec.c` (`/safe/` validation), `taint_fork.c`, `taint_exec.c`, `taint_probe.c` |
| **Suparn** | Pipes, Write-Down Policy, Unlink Restriction, Laundering Tests | `pipe.c` (pipe struct, write, read), `file.c` (write path), `sysfile.c` (`sys_unlink`, `create`), `taint_pipe.c`, `taint_policy.c`, `taint_launder.c` |
| **Aryan** | Agent Worker Integration, Python Bridge, Test Suite, Documentation | `agent_worker.c`, `agent/bridge.py`, `agent/main.py`, `agent/test_pipeline.py`, `Makefile`, `inbox.txt`, `clean.txt`, `ARCHITECTURE.md`, `VIVA_GUIDE.md` |

---

## 9. Antigravity / Viva Spot-Check Questions & Answers

### Q1: Why did you put `tainted` in `struct pipe` instead of `struct file`?
**A:** If placed in `struct file`, calling `dup(fd)` creates a new `struct file` or clones references, which could decouple the taint flag from the underlying channel. Since data lives in the pipe buffer, the taint belongs to the data carrier (`struct pipe`).

### Q2: What happens if a process reads 0 bytes from an untrusted file?
**A:** In `file.c:fileread()`, the condition checks `if(r > 0 && f->ip->type == T_FILE && f->ip->untrusted == TAINT_UNTRUSTED)`. If `r == 0` (EOF or empty read), `myproc()->tainted` is **not** set.

### Q3: Why is `NDIRECT` 11 instead of 12?
**A:** `struct dinode` must be exactly 64 bytes. Adding `short untrusted` (2 bytes) and padding (2 bytes) adds 4 bytes. Removing one direct disk pointer from `addrs` subtracts 4 bytes (`sizeof(uint)`), maintaining the 64-byte invariant without altering `IPB` (inodes per block).

### Q4: How do you defend against `/safeevil` when enforcing `/safe/` exec prefix?
**A:** We use `strncmp(path, "/safe/", 6) != 0` — requiring the trailing slash. `/safeevil` fails this check because the 6th character is `'e'`, not `'/'`.

### Q5: How would you extend taint tracking through `dup` during the viva?
**A:** Taint is already tracked at the process level and pipe/inode level, not on `struct file`. `sys_dup` simply increments `f->ref` and allocates a new file descriptor pointing to the same `struct file`. Because our write and read checks inspect `myproc()->tainted` and `f->ip->untrusted` (or `f->pipe->tainted`), `dup` is automatically subject to the policy without needing per-file state!
