#Requires AutoHotkey v2
INBOX := "C:\Users\USER\Desktop\cyber-zombie-assets\.ai_inbox\"

^!s::{   ; Ctrl+Alt+S
    if !ClipWait(1) {
        MsgBox("Panoda veri yok.", "AI-Inbox", 48)
        return
    }
    stamp := FormatTime(, "yyyyMMdd_HHmmss")
    file  := INBOX "AI_" stamp ".json"
    DirCreate(INBOX)
    FileAppend(A_Clipboard, file, "UTF-8")
    TrayTip("AI-Inbox", "Kaydedildi: " file)
}
