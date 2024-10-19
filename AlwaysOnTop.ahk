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
    Gui, Color, Aqua ; Imposta il colore di sfondo

    ; Se l'indicatore non è stato ancora creato, aggiungi il testo
    if !IndicatorCreated
    {
        Gui, Font, s20, Arial ; Imposta la dimensione del carattere a 20
        Gui, Add, Text, x0 y-2 w30 h30 Center cWhite, 🔼 ; Usa l'emoji "TOP" per rappresentare il bollino
        IndicatorCreated := true
    }

    ; Assicurati che la GUI sia sempre sopra tutte le finestre
    Gui, +AlwaysOnTop
    Gui, Show, NoActivate x%X% y%Y% w30 h30 ; Modifica le dimensioni e la posizione
return
