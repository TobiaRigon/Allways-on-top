^SPACE:: ; Usa Ctrl + Spazio per abilitare/disabilitare "always on top"
    ; Ottieni l'ID della finestra attiva
    WinGet, WindowID, ID, A
    ; Verifica se la finestra è già "always on top"
    WinGet, ExStyle, ExStyle, ahk_id %WindowID%
    if (ExStyle & 0x8) ; Se è già in "always on top"
    {
        Winset, AlwaysOnTop, Off, ahk_id %WindowID%
        ; Ferma il timer e nascondi l'indicatore
        SetTimer, UpdateIndicator, Off
        Gui, Hide
    }
    else
    {
        ; Se c'è un'altra finestra "always on top", disattiva prima quella
        if (CurrentWindowID)
        {
            Winset, AlwaysOnTop, Off, ahk_id %CurrentWindowID%
            SetTimer, UpdateIndicator, Off
            Gui, Hide
        }

        ; Imposta la nuova finestra come "always on top"
        Winset, AlwaysOnTop, On, ahk_id %WindowID%
        CurrentWindowID := WindowID
        ; Avvia un timer per aggiornare l'indicatore
        SetTimer, UpdateIndicator, 100
    }
return

UpdateIndicator:
    ; Verifica se la finestra esiste ancora
    if !WinExist("ahk_id " . CurrentWindowID)
    {
        ; Se la finestra è stata chiusa, ferma il timer e nascondi l'indicatore
        SetTimer, UpdateIndicator, Off
        Gui, Hide
        CurrentWindowID := ""
        return
    }

    ; Ottieni la posizione della finestra attiva
    WinGetPos, X, Y, W, H, ahk_id %CurrentWindowID%

    ; Aggiorna la posizione dell'indicatore senza ricreare la GUI
    Gui, +AlwaysOnTop +ToolWindow -Caption -SysMenu +E0x20
    Gui, Color, Blue ; Imposta il colore di sfondo in blu

    ; Se l'indicatore non è stato ancora creato, aggiungi l'immagine
    if !IndicatorCreated
    {
        Gui, Add, Picture, x0 y1 w30 h30, AOT_Icon32.png ; Usa l'icona "AOT_Icon.png" per rappresentare il bollino
        IndicatorCreated := true
    }

    ; Mostra la GUI e aggiorna la posizione dell'indicatore
    Gui, Show, NoActivate x%X% y%Y% w30 h30 ; Modifica le dimensioni e la posizione
return
