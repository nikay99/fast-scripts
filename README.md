# Windows Daily Hacks 🚀

```
 __    __  _        _   _    ____ ___ _____ ___ _  __
/ / /\ \ \| |      / \ | |_ |__  | _ \_   _|_ _| |/ /
\ \/  \/ /| |_    / _ \| __|  / /|   / | |  | | ' <
 \  /\  / |  _|  / ___ \ |_  / /_| |\ \ | |  | | . \
  \/  \/   \__| /_/   \_\__|/____|_| \_\|_| |___|_|\_\
     Daily Hacks · Productivity Scripts · Zero Install
```

**Tired of manual updates? PC full of junk? Here’s the fix.**

A small set of **Windows automation** scripts for **daily tasks automation**: no install, no admin (where possible), just download and run. Use **batch file examples** and **PowerShell tools** to save time and keep your system tidy.

---

## ✨ Features

| Icon | Script | What it does |
|------|--------|--------------|
| 📶 | **wifi-reveal.bat** | **Wifi password viewer** – shows all saved Wi‑Fi names and passwords (uses `netsh`) |
| 🧹 | **deep-clean.bat** | **System cleaner** – temp files, Windows Update cache, browser cache, empty recycle bin |
| 📁 | **auto-organize-downloads.ps1** | Sorts your Downloads folder into Images, Documents, Exe, Zip (and Other) by extension |
| 🔄 | **update-all-apps.bat** | One-click **productivity scripts** – runs `winget upgrade --all` to update all apps |
| ⏱️ | **shutdown-timer.bat** | Asks “In how many minutes?” and schedules shutdown (cancel with `shutdown /a`) |

All scripts are **batch file examples** and **PowerShell tools** you can read and tweak. Perfect for **Windows 10/11** and focused on “use immediately” and “save time”.

---

## 🚀 Installation

1. **Download** this repo (ZIP or clone).
2. **Unzip** (if needed) and open the `scripts` folder.
3. **Run** any `.bat` by double-clicking; for `auto-organize-downloads.ps1` right‑click → *Run with PowerShell* (or use the GUI).
4. **Optional:** Double-click **Start-Toolbox-GUI.bat** or run **FastNet-Toolbox-GUI.ps1** for a single window with progress bar and all tools.

No install, no extra software. **Use at your own risk.**

---

## 📂 Project layout

```
FastNet-Toolbox/
├── README.md
├── Start-Toolbox-GUI.bat      ← Double-click to open GUI
├── FastNet-Toolbox-GUI.ps1    ← Launcher with GUI & progress
└── scripts/
    ├── wifi-reveal.bat
    ├── deep-clean.bat
    ├── auto-organize-downloads.ps1
    ├── update-all-apps.bat
    └── shutdown-timer.bat
```

---

## ⚠️ Disclaimer

**Use at your own risk.**  
These scripts are provided as-is. The authors are not responsible for any damage, data loss, or misuse. Run **deep-clean.bat** as Administrator only if you understand what it deletes. Test on a non-critical system first if unsure.

---

## 📜 License

MIT – use, change, and share. Star the repo if it helps you.

**Keywords:** Windows automation, productivity scripts, batch file examples, PowerShell tools, system cleaner, wifi password viewer, daily tasks automation.
