#Requires AutoHotkey v2.0
#SingleInstance Force

global loopCount := 0
global autosellCycles := 0 
UpdateTooltips()
SetTimer(UpdateTooltips, 100)

ResizeRobloxWindow()

F1:: {
    ResizeRobloxWindow()
    Sleep 200
    MouseMove 479, 299
    Sleep 100
    Send "3"
    Sleep 100
    Send "1"
    Sleep 300

    Loop
    {
        Click "Down"
        Sleep 700
        Click "Up"
        Sleep 1200
        Click "Down"
        Sleep 1000
        
        global loopCount, autosellCycles
        Loop
        {
            pixelColor := PixelGetColor(458, 514)
            r := (pixelColor >> 16) & 0xFF
            g := (pixelColor >> 8) & 0xFF
            b := pixelColor & 0xFF
            
            isWhite := (r > 200) && (g > 200) && (b > 200)
            
            if (!isWhite)
            {
                Click "Up"
                Sleep 500
                loopCount++
                if (autosellCycles > 0 && loopCount >= autosellCycles) {
                    PerformAutosell()
                    loopCount := 0 
                }
                
                break
            }   
            Sleep 50
        }
    }
}

F2::Reload

F3:: {
    global autosellCycles
    if (autosellCycles = 0) {
        autosellCycles := 10
    } else if (autosellCycles = 10) {
        autosellCycles := 20
    } else if (autosellCycles = 20) {
        autosellCycles := 30
    } else {
        autosellCycles := 0
    }
}

ResizeRobloxWindow() {
    titles := ["Roblox", "ahk_exe RobloxPlayerBeta.exe", "ahk_exe RobloxPlayer.exe"]
    targetTitle := ""
    
    for title in titles {
        if WinExist(title) {
            targetTitle := title
            break
        }
    }
    
    if (targetTitle = "") {
        MsgBox("Roblox window not found!")
        return
    }
    
    try {
        WinActivate(targetTitle)
        Sleep(500)
        
        style := WinGetStyle(targetTitle)
        WS_CAPTION := 0xC00000
        WS_THICKFRAME := 0x40000
        
        hasWindowBorders := (style & WS_CAPTION) || (style & WS_THICKFRAME)
        
        if (!hasWindowBorders) {
            Send("{F11}")
            Sleep(500)
        }
        
        WinMove(-7, 0, 974, 630, targetTitle)
    } catch Error as e {
        MsgBox("Error resizing window: " . e.Message)
    }
}

UpdateTooltips() {
    global loopCount, autosellCycles
    ToolTip("F1: Start | F2: Reload", 25, 322, 1)
    ToolTip("Cycle: " . loopCount, 25, 342, 2)
    ToolTip("F3: Toggle Autosell", 25, 362, 3)
    
    if (autosellCycles = 0) {
        ToolTip("Autosell: OFF", 25, 382, 4)
    } else {
        ToolTip("Autosell: After " . autosellCycles . " cycles", 25, 382, 4)
    }
}

PerformAutosell() {
    Send "2"
    Sleep 100
    Send "3"
    Sleep 200
    MouseMove(617, 154)
    Click
    MouseMove(619, 154)
    Click
    MouseMove(621, 154)
    Click
    Sleep 200
    MouseMove 479, 299
    Sleep 200
}