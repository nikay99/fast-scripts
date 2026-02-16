#Requires -Version 5.1
# FastNet-Toolbox-GUI.ps1 - One window for all daily hacks. Hacker-style UI, progress bar, no install.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$script:ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$script:Running = $false
$script:AnimTimer = $null

# --- Theme: hacker / terminal style ---
$bgDark   = [System.Drawing.Color]::FromArgb(12, 12, 18)
$bgPanel  = [System.Drawing.Color]::FromArgb(22, 22, 30)
$accent   = [System.Drawing.Color]::FromArgb(0, 255, 136)   # Matrix green
$accent2  = [System.Drawing.Color]::FromArgb(0, 200, 255)    # Cyan
$textNorm = [System.Drawing.Color]::FromArgb(200, 220, 220)
$textDim  = [System.Drawing.Color]::FromArgb(100, 120, 120)

$fontTitle  = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$fontNormal = New-Object System.Drawing.Font("Consolas", 10)
$fontSmall  = New-Object System.Drawing.Font("Consolas", 9)

# --- Main form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "FastNet Toolbox"
$form.Size = New-Object System.Drawing.Size(520, 520)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bgDark
$form.ForeColor = $textNorm
$form.Font = $fontNormal
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# --- Title label (ASCII-style) ---
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "FASTNET TOOLBOX"
$lblTitle.Location = New-Object System.Drawing.Point(20, 16)
$lblTitle.Size = New-Object System.Drawing.Size(480, 28)
$lblTitle.Font = $fontTitle
$lblTitle.ForeColor = $accent
$form.Controls.Add($lblTitle)

# --- Subtitle ---
$lblSub = New-Object System.Windows.Forms.Label
$lblSub.Text = "Windows Daily Hacks · Zero Install"
$lblSub.Location = New-Object System.Drawing.Point(22, 44)
$lblSub.Size = New-Object System.Drawing.Size(400, 20)
$lblSub.Font = $fontSmall
$lblSub.ForeColor = $textDim
$form.Controls.Add($lblSub)

# --- Animated status line (hacker "scan" effect) ---
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "> System ready. Select a tool."
$lblStatus.Location = New-Object System.Drawing.Point(20, 72)
$lblStatus.Size = New-Object System.Drawing.Size(460, 22)
$lblStatus.Font = $fontNormal
$lblStatus.ForeColor = $accent2
$form.Controls.Add($lblStatus)

# --- Progress bar ---
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(20, 98)
$progress.Size = New-Object System.Drawing.Size(460, 22)
$progress.Style = "Continuous"
$progress.Minimum = 0
$progress.Maximum = 100
$progress.Value = 0
try { $progress.ForeColor = $accent } catch { }
$form.Controls.Add($progress)

# --- Panel for buttons ---
$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object System.Drawing.Point(20, 132)
$panel.Size = New-Object System.Drawing.Size(460, 320)
$panel.BackColor = $bgPanel
$panel.BorderStyle = "FixedSingle"
$form.Controls.Add($panel)

$y = 16
$btnH = 44
$gap = 8

function Add-ToolButton {
    param([string]$Text, [string]$Tooltip, [scriptblock]$OnClick)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $Text
    $btn.Location = New-Object System.Drawing.Point(16, $script:y)
    $btn.Size = New-Object System.Drawing.Size(428, $btnH)
    $btn.FlatStyle = "Flat"
    $btn.BackColor = [System.Drawing.Color]::FromArgb(35, 40, 48)
    $btn.ForeColor = $textNorm
    $btn.FlatAppearance.BorderColor = $accent
    $btn.Font = $fontNormal
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.Add_Click($OnClick)
    $script:y += $btnH + $gap
    $panel.Controls.Add($btn)
}

# --- Animation: cycling status text ---
$statusMessages = @(
    "> System ready.",
    "> Select a tool to run.",
    "> No installation required.",
    "> Your PC will feel faster."
)
$statusIdx = 0
$script:AnimTimer = New-Object System.Windows.Forms.Timer
$script:AnimTimer.Interval = 2000
$script:AnimTimer.Add_Tick({
    if (-not $script:Running) {
        $statusIdx = ($statusIdx + 1) % $statusMessages.Count
        $lblStatus.Text = $statusMessages[$statusIdx]
    }
})
$script:AnimTimer.Start()

# --- Run script helper with progress ---
function Start-ToolJob {
    param([string]$Title, [string]$Path, [string]$Args = "", [bool]$IsPs1 = $false)
    if ($script:Running) { return }
    $script:Running = $true
    $lblStatus.Text = "> $Title..."
    $progress.Value = 10
    $progress.Refresh()
    $form.Refresh()

    $job = Start-Job -ScriptBlock {
        param($p, $a, $ps1)
        Set-Location $using:ScriptDir
        if ($ps1) {
            & "$using:ScriptDir\scripts\auto-organize-downloads.ps1"
        } else {
            $full = Join-Path $using:ScriptDir "scripts\$p"
            if ($a) { Start-Process -FilePath $full -ArgumentList $a -Wait -NoNewWindow }
            else    { Start-Process -FilePath $full -Wait }
        }
    } -ArgumentList $Path, $Args, $IsPs1

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 200
    $tick = 0
    $timer.Add_Tick({
        $tick++
        if ($job.State -eq "Completed") {
            $timer.Stop()
            $progress.Value = 100
            $lblStatus.Text = "> Done. Your PC is happier."
            $script:Running = $false
            Remove-Job $job -Force
            [System.Windows.Forms.MessageBox]::Show("Task completed.", "FastNet Toolbox", "OK", "Information")
            $progress.Value = 0
            return
        }
        # Indeterminate-style progress
        $p = 10 + [Math]::Min(80, $tick * 2)
        $progress.Value = $p
    })
    $timer.Start()
}

Add-ToolButton -Text "  WiFi Reveal  –  Show saved WiFi passwords" -OnClick {
    $script:Running = $true
    $lblStatus.Text = "> Scanning WiFi profiles..."
    $progress.Value = 50
    $form.Refresh()
    $out = & netsh wlan show profiles 2>&1
    $profiles = ($out | Select-String "All User Profile|Alle Benutzerprofile").ToString() -split "`n"
    $result = @()
    foreach ($line in $profiles) {
        if ($line -match ":\s*(.+)") {
            $name = $matches[1].Trim()
            $key = (netsh wlan show profile name=`"$name`" key=clear 2>$null | Select-String "Key Content|Schlüsselinhalt").ToString()
            if ($key -match ":\s*(.+)") { $pass = $matches[1].Trim() } else { $pass = "(none)" }
            $result += "--- $name ---`nPassword: $pass"
        }
    }
    $script:Running = $false
    $progress.Value = 0
    $lblStatus.Text = "> WiFi list ready."
    $msg = if ($result.Count -gt 0) { $result -join "`n`n" } else { "No saved WiFi profiles found." }
    [System.Windows.Forms.MessageBox]::Show($msg, "WiFi Passwords", "OK", "Information")
}

Add-ToolButton -Text "  Deep Clean  –  Temp, cache, recycle bin" -OnClick {
    Start-ToolJob -Title "Deep Clean" -Path "deep-clean.bat"
}

Add-ToolButton -Text "  Organize Downloads  –  Sort by type" -OnClick {
    $script:Running = $true
    $lblStatus.Text = "> Organizing Downloads..."
    $progress.Value = 30
    $form.Refresh()
    Set-Location $script:ScriptDir
    & "$script:ScriptDir\scripts\auto-organize-downloads.ps1"
    $script:Running = $false
    $progress.Value = 100
    $lblStatus.Text = "> Downloads organized."
    $progress.Value = 0
    [System.Windows.Forms.MessageBox]::Show("Downloads folder sorted into subfolders.", "Done", "OK", "Information")
}

Add-ToolButton -Text "  Update All Apps  –  winget upgrade --all" -OnClick {
    Start-ToolJob -Title "Updating apps" -Path "update-all-apps.bat"
}

Add-ToolButton -Text "  Shutdown Timer  –  Shut down in X minutes" -OnClick {
    $inputForm = New-Object System.Windows.Forms.Form
    $inputForm.Text = "Shutdown Timer"
    $inputForm.Size = New-Object System.Drawing.Size(320, 130)
    $inputForm.StartPosition = "CenterParent"
    $inputForm.FormBorderStyle = "FixedDialog"
    $inputForm.BackColor = $bgDark
    $inputForm.ForeColor = $textNorm
    $l = New-Object System.Windows.Forms.Label
    $l.Text = "Minutes until shutdown:"
    $l.Location = New-Object System.Drawing.Point(12, 12)
    $l.AutoSize = $true
    $l.ForeColor = $accent2
    $inputForm.Controls.Add($l)
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Location = New-Object System.Drawing.Point(12, 34)
    $tb.Size = New-Object System.Drawing.Size(280, 22)
    $tb.Text = "30"
    $inputForm.Controls.Add($tb)
    $ok = New-Object System.Windows.Forms.Button
    $ok.Text = "OK"
    $ok.Location = New-Object System.Drawing.Point(120, 68)
    $ok.DialogResult = "OK"
    $ok.FlatStyle = "Flat"
    $ok.BackColor = $bgPanel
    $ok.ForeColor = $accent
    $inputForm.AcceptButton = $ok
    $inputForm.Controls.Add($ok)
    $inputForm.Topmost = $true
    if ($inputForm.ShowDialog($form) -eq "OK") {
        $m = 0
        [int]::TryParse($tb.Text.Trim(), [ref]$m) | Out-Null
        if ($m -gt 0) {
            $sec = $m * 60
            Start-Process -FilePath "shutdown" -ArgumentList "/s","/t",$sec,"/c","Scheduled by FastNet Toolbox" -WindowStyle Hidden
            $lblStatus.Text = "> Shutdown in $m min. Cancel: shutdown /a"
            [System.Windows.Forms.MessageBox]::Show("Shutdown in $m minute(s). To cancel: open CMD and run: shutdown /a", "Timer Set", "OK", "Information")
        }
    }
}

# --- Show main window ---
[void]$form.ShowDialog()
<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>
Read