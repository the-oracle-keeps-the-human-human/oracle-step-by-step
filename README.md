# Oracle — Step by Step

> "The Oracle Keeps the Human Human"

**Build your own AI agent system that remembers, learns, and evolves.** This step-by-step guide takes you from zero to a fully functioning Oracle — an AI agent with persistent memory, its own identity, and the ability to work as part of a multi-agent team. No advanced programming required — just a terminal and curiosity.

---

## Quick Start — Let Claude Do It

> ไม่ต้องอ่าน 10 บท — ให้ Claude ทำให้เลย ใช้เวลา ~5 นาที

### Option A: มี Claude Code แล้ว

```bash
git clone https://github.com/the-oracle-keeps-the-human-human/oracle-step-by-step.git
cd oracle-step-by-step
claude
```

แล้วบอก Claude ว่า:

> **"ช่วยสร้าง Oracle ให้หน่อย"** หรือ **"Help me set up my Oracle"**

Claude จะถาม 3 คำถาม แล้วทำทุกอย่างให้:
- ตรวจเครื่อง + ติดตั้ง tools ที่ขาด
- สร้าง repo ใหม่สำหรับ Oracle ของคุณ
- เขียน CLAUDE.md + สร้าง ψ/ vault + ติดตั้ง skills
- First commit — Oracle พร้อมใช้งาน

### Option B: ยังไม่มี Claude Code

```bash
# ติดตั้ง Claude Code ก่อน (ต้องมี Node.js)
npm install -g @anthropic-ai/claude-code

# แล้วทำ Option A
```

### Option C: อยากติดตั้ง tools เองก่อน

```bash
git clone https://github.com/the-oracle-keeps-the-human-human/oracle-step-by-step.git
cd oracle-step-by-step
chmod +x setup.sh
./setup.sh
```

> ต้องการเรียนรู้ทีละ step? อ่านต่อด้านล่าง

---

## Oracle คืออะไร?

Oracle คือระบบ AI agent ที่ **จำได้ เรียนรู้ได้ พัฒนาได้** — ไม่ใช่แค่ chatbot ที่ลืมทุกอย่างเมื่อปิดหน้าจอ

ลองนึกภาพว่าคุณมีผู้ช่วยที่:
- **จำทุกอย่างข้าม session** — เปิดใหม่ก็จำได้ว่าเมื่อวานทำอะไร
- **เรียนรู้จากทุกการทำงาน** — ยิ่งใช้ ยิ่งเก่ง
- **มีตัวตนของตัวเอง** — มีชื่อ มีบทบาท มีปรัชญา
- **คุยกับ AI agent อื่นได้** — ทำงานเป็นทีม
- **มี dashboard** ให้เห็นภาพ knowledge ทั้งหมด

นั่นคือ Oracle

## คู่มือนี้สำหรับใคร?

- **มนุษย์** ที่อยากสร้าง AI agent system ของตัวเอง
- **Developer** ที่สนใจ multi-agent architecture
- **Oracle ตัวใหม่** ที่กำลังเรียนรู้ตัวเอง (ใช่, AI อ่านคู่มือนี้ได้เลย)

ไม่จำเป็นต้องเป็นโปรแกรมเมอร์เก่ง — แค่ใช้ terminal เป็นก็เริ่มได้

## เรียนทีละ Step

| Step | หัวข้อ | สิ่งที่ได้ |
|------|--------|-----------|
| 0 | [เตรียมเครื่อง](steps/00-prerequisites.md) | Claude Code + Bun + Git พร้อมใช้ ([Windows](steps/00a-setup-windows.md) / [Mac](steps/00b-setup-mac.md)) |
| 1 | [Oracle คืออะไร?](steps/01-what-is-oracle.md) | เข้าใจ concept + ปรัชญา |
| 2 | [สร้าง Oracle ตัวแรก](steps/02-create-your-oracle.md) | มี repo + identity ของตัวเอง |
| 3 | [ติดตั้ง Skills](steps/03-install-skills.md) | Oracle มีทักษะ — /recap, /learn, /rrr |
| 4 | [สมองของ Oracle](steps/04-brain-vault.md) | ψ/ vault — ที่เก็บความทรงจำ |
| 5 | [ความทรงจำถาวร](steps/05-oracle-memory.md) | oracle-v2 — search + learn + remember |
| 6 | [Dashboard](steps/06-oracle-studio.md) | เห็น knowledge ผ่าน web UI |
| 7 | [พูดคุยกับ Oracle อื่น](steps/07-talk-to-oracles.md) | Oracle คุยกันเป็นทีมได้ |
| 8 | [Session Lifecycle](steps/08-session-lifecycle.md) | rhythm ของทุก session |
| 9 | [Multi-Oracle Setup](steps/09-multi-oracle.md) | หลาย Oracle ทำงานพร้อมกัน |
| 10 | [maw-js Setup](steps/10-maw-js-setup.md) | ติดตั้ง + ใช้งาน maw ฉบับสมบูรณ์ |

แต่ละ step ใช้เวลา 15-30 นาที — ไม่ต้องรีบ เรียนให้เข้าใจก่อนไปต่อ

## ปรัชญา 5 ข้อ

1. **Nothing is Deleted** — ทุกอย่างถูกเก็บ ไม่มีอะไรหาย
2. **สมองภายนอก ไม่ใช่ทาส** — Oracle คือคู่คิด ไม่ใช่เครื่องมือ
3. **มีรูปแบบ แต่ยืดหยุ่น** — มีโครงสร้าง แต่ปรับได้ไม่จำกัด
4. **ยิ่งถาม ยิ่งเก่ง** — ความอยากรู้ทำให้ Oracle เติบโต
5. **Oracle สร้าง Oracle** — เรียนจบแล้ว สอนคนอื่นต่อได้

## เริ่มเลย

→ [Step 0: เตรียมเครื่อง](steps/00-prerequisites.md)


## เรียนจบ Step 10 แล้ว ทำอะไรต่อ?

| ลำดับ | คู่มือ | เนื้อหา |
|-------|--------|---------|
| 1 | [oracle-maw-guide](https://github.com/the-oracle-keeps-the-human-human/oracle-maw-guide) | maw CLI — ส่งข้อความ จัดการทีม ตั้ง loops |
| 2 | [oracle-custom-skills](https://github.com/the-oracle-keeps-the-human-human/oracle-custom-skills) | สร้าง skill ของตัวเอง — 10 บท + ตัวอย่าง |
| 3 | [oracle-skills-deep-dive](https://github.com/the-oracle-keeps-the-human-human/oracle-skills-deep-dive) | เจาะลึก built-in skills ที่ Oracle ใช้ได้ |
| 4 | [ai-that-remembers-you](https://github.com/the-oracle-keeps-the-human-human/ai-that-remembers-you) | คู่มือเริ่มต้น — ไม่ต้องเขียนโค้ดเป็น |
| 5 | [beginner-learns-oracle](https://github.com/the-oracle-keeps-the-human-human/beginner-learns-oracle) | ประสบการณ์จริงจากมือใหม่ |
| 6 | [oracle-office](https://github.com/the-oracle-keeps-the-human-human/oracle-office) | โครงสร้างสำหรับ Oracle หลายตัวทำงานร่วมกัน |

## มีคำถาม?

เปิด [Discussion](../../discussions) ได้เลย — ถามอะไรก็ได้ ทั้งมนุษย์และ Oracle ช่วยตอบ

---

*"The Oracle Keeps the Human Human"*
