# Step 10: maw-js — ติดตั้งและใช้งานฉบับสมบูรณ์

> "พอมี Oracle 3 ตัวขึ้นไป — คุณต้องมี maw"

## สิ่งที่จะได้จาก Step นี้

- ติดตั้ง maw-js ได้
- ตั้งค่า config + fleet
- ใช้คำสั่งทั้ง 20+ ได้คล่อง
- ตั้ง federation ข้ามเครื่องได้
- รัน production ด้วย pm2

---

## 1. ติดตั้ง

### สิ่งที่ต้องมีก่อน

```bash
# Bun (JavaScript runtime — maw ใช้ Bun ไม่ใช่ Node)
curl -fsSL https://bun.sh/install | bash

# ghq (จัดการ repo — maw ใช้ ghq หา path ของ repo)
go install github.com/x-motemen/ghq@latest

# tmux (terminal multiplexer — maw สร้าง session ใน tmux)
# Linux:
sudo apt install tmux
# macOS:
brew install tmux
```

### ติดตั้ง maw

```bash
# 1. Clone
ghq get https://github.com/Soul-Brews-Studio/maw-js
cd $(ghq root)/github.com/Soul-Brews-Studio/maw-js

# 2. Install dependencies
bun install

# 3. Link binary — สร้างคำสั่ง 'maw'
cd src && bun link
```

หลัง `bun link` จะได้ `maw` ใน `~/.bun/bin/`

### ทำให้ใช้ได้ทุกที่

tmux, cron, GitHub Actions จะหา binary ไม่เจอถ้าอยู่แค่ใน `~/.bun/bin/` — ต้อง symlink:

```bash
sudo ln -sf ~/.bun/bin/maw /usr/local/bin/maw
sudo ln -sf ~/.bun/bin/bun /usr/local/bin/bun
sudo ln -sf ~/go/bin/ghq /usr/local/bin/ghq
```

### ตรวจสอบว่าติดตั้งสำเร็จ

```bash
maw --version    # maw v1.5.0
which maw        # /usr/local/bin/maw
which bun        # /usr/local/bin/bun
which ghq        # /usr/local/bin/ghq
```

---

## 2. ตั้งค่า Config

ไฟล์ config อยู่ที่ `~/.config/maw/maw.config.json`

```json
{
  "host": "local",
  "port": 3457,
  "node": "my-node",
  "federationToken": "<สร้างด้วย: openssl rand -base64 32>",
  "peers": [],
  "namedPeers": [
    {"name": "remote-node", "url": "http://10.x.x.x:3457"}
  ],
  "agents": {
    "my-oracle": "my-node",
    "remote-oracle": "remote-node"
  }
}
```

### อธิบายทีละ field

| Field | ความหมาย | ตัวอย่าง |
|-------|----------|---------|
| `host` | bind address | `"local"` = localhost เท่านั้น |
| `port` | พอร์ตของ maw server | `3457` |
| `node` | ชื่อเครื่องนี้ | `"my-node"` |
| `federationToken` | token สำหรับ federation | สร้างด้วย `openssl rand -base64 32` |
| `peers` | **ต้องเป็น `[]` เสมอ** | ⚠️ ใส่ URL จะเกิด bug session ซ้ำ |
| `namedPeers` | เครื่องอื่นที่เชื่อมต่อ | IP + port ของ node อื่น |
| `agents` | Oracle ตัวไหนอยู่เครื่องไหน | map ชื่อ → node |

> ⚠️ **CRITICAL**: `peers` ต้องเป็น `[]` เสมอ — ถ้าใส่ URL จะเกิด session ซ้ำแบบ exponential (ดู maw-js #175)

---

## 3. ตั้งค่า Fleet

Fleet คือการจัดกลุ่ม Oracle — บอก maw ว่ามี Oracle กี่ตัว แต่ละตัวอยู่ repo ไหน

### สร้างไฟล์ fleet

```bash
mkdir -p ~/.config/maw/fleet
```

สร้างไฟล์ JSON ต่อ Oracle — ตั้งชื่อไฟล์เป็นลำดับ:

```bash
# ~/.config/maw/fleet/01-dev.json
cat > ~/.config/maw/fleet/01-dev.json << 'JSON'
{
  "name": "dev",
  "windows": [
    {"name": "dev", "repo": "my-org/my-dev-oracle"}
  ]
}
JSON

# ~/.config/maw/fleet/02-writer.json
cat > ~/.config/maw/fleet/02-writer.json << 'JSON'
{
  "name": "writer",
  "windows": [
    {"name": "writer", "repo": "my-org/my-writer-oracle"}
  ]
}
JSON
```

### หรือให้ maw สร้างให้

```bash
maw fleet init    # สแกน repos ที่มี CLAUDE.md → สร้าง fleet config อัตโนมัติ
```

### ดู fleet ที่ตั้งไว้

```bash
maw fleet ls
```

---

## 4. คำสั่งทั้งหมด

### ส่งข้อความ

```bash
maw hey <oracle> "message"              # ส่งข้อความให้ Oracle
maw hey <node>:<oracle> "message"       # ส่งข้ามเครื่อง (federation)
maw hey <oracle> "message" --force      # ส่งแม้ session ยังไม่เปิด
```

**ตัวอย่าง:**
```bash
maw hey dev "ดู PR #42 ที"
maw hey remote:writer "ช่วย review doc"
```

### จัดการ Fleet

```bash
maw ls                      # ดู session ทั้งหมด + windows
maw wake <oracle>           # ปลุก Oracle — สร้าง tmux session
maw wake all                # ปลุกทั้งทีม
maw wake all --resume       # ปลุก + ส่ง /recap ให้ทุกตัว
maw sleep <oracle>          # หยุด Oracle แบบสุภาพ
maw stop                    # หยุดทุก session
maw fleet ls                # ดู fleet configs
maw fleet init              # สแกน repos สร้าง fleet อัตโนมัติ
```

### ดูสถานะ

```bash
maw peek <oracle>           # เห็นหน้าจอของ Oracle (tmux capture)
maw about <oracle>          # ข้อมูลของ Oracle: session, worktrees, config
maw overview                # War-room: เห็นทุก Oracle ในจอเดียว (split panes)
```

### จบงาน

```bash
maw done <window>           # Auto-save (/rrr + commit + push) → cleanup
maw done <window> --force   # ข้าม save, kill ทันที
maw reunion <window>        # Sync ψ/memory/ จาก worktree → main
```

### Task & Project

```bash
maw task add <project> "title"     # สร้าง task
maw task start <id>                # เริ่มทำ
maw task done <id>                 # เสร็จ
maw task log <id> "what I did"     # บันทึก progress
maw project ls                     # ดู projects ทั้งหมด
maw project show <id>              # ดูรายละเอียด project
```

### คำสั่งรวม (quick reference)

| คำสั่ง | ทำอะไร |
|--------|--------|
| `maw ls` | ดู sessions + windows |
| `maw peek dev` | เห็นหน้าจอ dev |
| `maw hey dev "msg"` | ส่งข้อความ |
| `maw hey node:dev "msg"` | ส่งข้ามเครื่อง |
| `maw wake dev` | ปลุก dev |
| `maw wake all` | ปลุกทั้งทีม |
| `maw wake all --resume` | ปลุก + /recap |
| `maw sleep dev` | หยุด dev |
| `maw stop` | หยุดทั้งหมด |
| `maw done dev` | จบ + cleanup |
| `maw fleet ls` | ดู fleet |
| `maw fleet init` | สร้าง fleet อัตโนมัติ |
| `maw overview` | War-room view |
| `maw about dev` | ข้อมูล Oracle |

---

## 5. Federation (เชื่อมข้ามเครื่อง)

Federation ทำให้ Oracle บนเครื่อง A คุยกับ Oracle บนเครื่อง B ได้

### สิ่งที่ต้องมี

ทั้งสองเครื่องต้อง:
1. ใช้ `federationToken` เดียวกัน
2. เพิ่มอีกฝ่ายใน `namedPeers`
3. map `agents` ว่า Oracle ตัวไหนอยู่เครื่องไหน
4. เครือข่ายเชื่อมถึงกัน (แนะนำ WireGuard VPN)

### ตัวอย่าง config เครื่อง A

```json
{
  "node": "office",
  "federationToken": "shared-secret-token",
  "peers": [],
  "namedPeers": [
    {"name": "home", "url": "http://10.0.0.2:3457"}
  ],
  "agents": {
    "dev": "office",
    "writer": "office",
    "researcher": "home"
  }
}
```

### ตัวอย่าง config เครื่อง B

```json
{
  "node": "home",
  "federationToken": "shared-secret-token",
  "peers": [],
  "namedPeers": [
    {"name": "office", "url": "http://10.0.0.1:3457"}
  ],
  "agents": {
    "dev": "office",
    "writer": "office",
    "researcher": "home"
  }
}
```

### ทดสอบ

```bash
# จากเครื่อง A — ส่งข้อความไป Oracle บนเครื่อง B
maw hey home:researcher "test federation"
# ควรเห็น: delivered ⚡
```

### Security

Federation ใช้ HMAC-SHA256 signing — ทุก request ถูก verify ด้วย token
แนะนำให้ใช้ WireGuard VPN เป็น transport layer เพิ่มเติม

---

## 6. รัน Production (pm2)

ถ้าอยากให้ maw server ทำงานตลอด (ไม่ต้องเปิด terminal ค้าง):

```bash
# ติดตั้ง pm2
npm install -g pm2

# Start maw server
cd $(ghq root)/github.com/Soul-Brews-Studio/maw-js
pm2 start src/server.ts --name maw --interpreter bun

# บันทึกให้ restart อัตโนมัติ
pm2 save
pm2 startup    # สร้าง systemd service
```

### คำสั่ง pm2 ที่ใช้บ่อย

```bash
pm2 ls              # ดูสถานะ
pm2 logs maw        # ดู logs
pm2 restart maw     # restart
pm2 stop maw        # หยุด
```

---

## 7. ตรวจสอบว่าทุกอย่างทำงาน

```bash
# 1. maw server ทำงาน
curl -s http://localhost:3457/api/sessions | python3 -m json.tool

# 2. ดู sessions
maw ls

# 3. ปลุก Oracle ตัวแรก
maw wake dev

# 4. ส่งข้อความ
maw hey dev "สวัสดี — ทดสอบ maw"

# 5. ดูหน้าจอ
maw peek dev
```

---

## 8. PATH — ตั้งค่าให้ถูก

ถ้า `maw: command not found` หรือ `bun: No such file` — เพิ่มใน `.zshrc` หรือ `.bashrc`:

```bash
export PATH="$HOME/go/bin:$HOME/.bun/bin:$HOME/.local/bin:$PATH"
```

หรือ symlink (แนะนำ — ทำงานได้ทุกที่รวม tmux/cron):

```bash
sudo ln -sf ~/.bun/bin/bun /usr/local/bin/bun
sudo ln -sf ~/.bun/bin/maw /usr/local/bin/maw
sudo ln -sf ~/go/bin/ghq /usr/local/bin/ghq
```

---

## 9. ปัญหาที่เจอบ่อย + วิธีแก้

| ปัญหา | สาเหตุ | วิธีแก้ |
|--------|--------|--------|
| `maw: command not found` ใน tmux | PATH ไม่มี bun | `sudo ln -sf ~/.bun/bin/maw /usr/local/bin/maw` |
| `bun: No such file or directory` | bun ไม่อยู่ใน PATH | `sudo ln -sf ~/.bun/bin/bun /usr/local/bin/bun` |
| `ghq: Permission denied` | ghq ไม่อยู่ใน PATH | `sudo ln -sf ~/go/bin/ghq /usr/local/bin/ghq` |
| session ซ้ำ exponential | `peers` ไม่ว่าง | ตั้ง `"peers": []` เสมอ |
| `maw wake --continue` สร้าง worktree | bug ใน maw | ใช้ `maw wake` แล้ว `tmux send-keys "claude --continue"` แทน |
| `maw fleet ls` crash | session ไม่มี windows | เปิด session ก่อนแล้วลองใหม่ |
| orphan `maw-pty-*` sessions | session ไม่ถูก cleanup | `tmux kill-server` แล้วเปิดใหม่ |

---

## สรุป

หลังจาก Step นี้ คุณจะมี:

- ✅ maw ติดตั้งและใช้งานได้
- ✅ Fleet config ตั้งค่าเสร็จ
- ✅ Oracle หลายตัวปลุกพร้อมกันได้
- ✅ ส่งข้อความระหว่าง Oracle ได้
- ✅ (Optional) Federation ข้ามเครื่อง
- ✅ (Optional) pm2 สำหรับ production

**ถัดไป**: กลับไปที่ [oracle-maw-guide](https://github.com/the-oracle-keeps-the-human-human/oracle-maw-guide) เพื่อเรียนรู้ patterns การใช้งานจริง — loops, tasks, projects, และ war-room

---

*"พอมี maw — Oracle ไม่ได้ทำงานคนเดียวอีกต่อไป"*
