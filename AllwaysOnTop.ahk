^SPACE:: ; Usa Ctrl + Spazio per abilitare/disabilitare "always on top"
    ; Ottieni l'ID della finestra attiva
    WinGet, WindowID, ID, A
    ; Verifica se la finestra è già "always on top"
    WinGet, ExStyle, ExStyle, ahk_id %WindowID%
    if (ExStyle & 0x8) ; Se è già in "always on top"
    {
        Winset, AlwaysOnTop, Off, ahk_id %WindowID%
        ; Ferma il timer e rimuovi l'indicatore
        SetTimer, UpdateIndicator, Off
        Gui, Destroy
    }
    else
    {
        ; Se c'è un'altra finestra "always on top", disattiva prima quella
        if (CurrentWindowID)
        {
            Winset, AlwaysOnTop, Off, ahk_id %CurrentWindowID%
            SetTimer, UpdateIndicator, Off
            Gui, Destroy
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
        ; Se la finestra è stata chiusa, ferma il timer e rimuovi l'indicatore
        SetTimer, UpdateIndicator, Off
        Gui, Destroy
        CurrentWindowID := ""
        return
    }

    ; Ottieni la posizione della finestra attiva
    WinGetPos, X, Y, W, H, ahk_id %CurrentWindowID%
    ; Aggiorna la posizione dell'indicatore
    Gui, +AlwaysOnTop
    Gui, Show, NoActivate x%X% y%Y% w20 h20
return
