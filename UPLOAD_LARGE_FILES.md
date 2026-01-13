# วิธีอัปโหลดไฟล์ขนาดใหญ่ (>100MB)

## ปัญหา
GitHub API จำกัดไฟล์ที่ **100MB ต่อไฟล์** และ repository จำกัดที่ **100MB ต่อไฟล์** (ถ้าไม่มี Git LFS)

ไฟล์ installer_output ของคุณมีขนาด **112.06 MB** ซึ่งเกินขีดจำกัด

## วิธีแก้ไข

### วิธีที่ 1: ใช้ Git Command Line (แนะนำ)

Git command line ไม่มีข้อจำกัด 100MB เหมือน GitHub API:

```bash
# 1. เพิ่มไฟล์ทั้งหมด
git add installer_output/

# 2. Commit
git commit -m "Add installer files"

# 3. Push
git push
```

**ข้อดี:**
- ไม่มีข้อจำกัด 100MB
- อัปโหลดได้ทั้งโฟลเดอร์พร้อมกัน
- เร็วและง่าย

**ข้อเสีย:**
- ต้องใช้ Git command line
- ต้องมี Git ติดตั้ง

---

### วิธีที่ 2: ใช้ Git LFS (Large File Storage)

Git LFS ช่วยจัดการไฟล์ขนาดใหญ่:

```bash
# 1. ติดตั้ง Git LFS
# Windows: Download from https://git-lfs.github.com/
# หรือใช้: winget install Git.GitLFS

# 2. เปิดใช้งาน Git LFS
git lfs install

# 3. Track ไฟล์ .exe ทั้งหมด
git lfs track "*.exe"

# 4. เพิ่ม .gitattributes
git add .gitattributes

# 5. เพิ่มไฟล์
git add installer_output/

# 6. Commit และ Push
git commit -m "Add installer files with LFS"
git push
```

**ข้อดี:**
- รองรับไฟล์ขนาดใหญ่
- GitHub รองรับ Git LFS
- ไฟล์ถูกเก็บใน LFS storage

**ข้อเสีย:**
- ต้องติดตั้ง Git LFS
- ต้องตั้งค่าเพิ่มเติม

---

### วิธีที่ 3: แบ่งไฟล์เป็นหลายส่วน

แบ่งไฟล์ใหญ่เป็นหลายส่วนแล้วอัปโหลดทีละส่วน:

```powershell
# แบ่งไฟล์ (ใช้ 7-Zip หรือ WinRAR)
# หรือใช้ PowerShell:
Split-File -Path "installer_output.zip" -PartSizeBytes 50MB
```

**ข้อเสีย:**
- ต้องรวมไฟล์ใหม่ก่อนใช้งาน
- ซับซ้อนสำหรับผู้ใช้

---

### วิธีที่ 4: ใช้ Cloudflare R2 + Workers

สร้าง backend สำหรับอัปโหลดไฟล์ขนาดใหญ่:

**ข้อดี:**
- ไม่มีข้อจำกัดขนาดไฟล์
- เร็ว (CDN)

**ข้อเสีย:**
- ต้องเขียน backend
- ต้องตั้งค่า Cloudflare R2
- ซับซ้อนกว่า

---

## คำแนะนำ

สำหรับกรณีนี้ **แนะนำวิธีที่ 1 (Git Command Line)** เพราะ:
- ✅ ง่ายที่สุด
- ✅ ไม่มีข้อจำกัด 100MB
- ✅ อัปโหลดได้ทั้งโฟลเดอร์พร้อมกัน
- ✅ ไม่ต้องติดตั้งอะไรเพิ่ม

## ขั้นตอนการใช้งาน

### ใช้ Git Command Line:

1. **เปิด PowerShell หรือ Command Prompt**

2. **ไปที่โฟลเดอร์โปรเจกต์:**
   ```powershell
   cd C:\Projects\agent_upload
   ```

3. **ตรวจสอบสถานะ:**
   ```powershell
   git status
   ```

4. **เพิ่มไฟล์ทั้งหมด:**
   ```powershell
   git add installer_output/
   ```

5. **Commit:**
   ```powershell
   git commit -m "Add installer files"
   ```

6. **Push:**
   ```powershell
   git push
   ```

7. **รอ 1-2 นาที** Cloudflare Pages จะ deploy อัตโนมัติ

---

## หมายเหตุ

- GitHub repository จำกัดที่ **100MB ต่อไฟล์** (ถ้าไม่มี Git LFS)
- แต่ Git command line สามารถ push ไฟล์ได้ถึง **2GB ต่อไฟล์** (ถ้าใช้ Git LFS)
- สำหรับไฟล์ 112MB นี้ Git command line ธรรมดาก็พอแล้ว

## อัปเดตหน้า Upload

หน้า `upload.html` ที่สร้างไว้จะแสดง warning ถ้าไฟล์เกิน 100MB และแนะนำให้ใช้ Git command line แทน
