MODULE Module1

    ! --- PUNKTY ROBOTA (bez zmian) ---
    CONST robtarget pBtnStart:=[[-928.059862358,740.858497694,1632.007951396],[0.000000014,0.707106796,0.000000086,-0.707106767],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pBtnUnlock:=[[-928.059856122,740.85849777,1300.101055289],[-0.000000004,-0.707106778,-0.000000051,0.707106784],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pCncApp:=[[-631.704904234,0,1085.999967841],[0,1,0,0.000000007],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pCncChuck:=[[-1454.470032752,-175.219593616,894.065385784],[0.000000023,1,0.000000004,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pCncChuckApp:=[[-1454.470009306,-175.219590792,944.065528463],[0.000000052,1,0.000000004,0.000000004],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDoorL_Closed:=[[-1062.463973189,22.445888366,1143.0740491],[0,0.707106785,0.000000001,-0.707106777],[-1,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDoorR_Closed:=[[-1062.463973189,22.445888366,1143.0740491],[0,0.707106785,0.000000001,-0.707106777],[-1,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDrop:=[[-128.971605979,1290.59002496,727.862282947],[-0.000000086,-0.707106781,0.707106781,0.000000022],[-1,-2,-2,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDropApp:=[[-128.971607194,1290.590037113,776.862215984],[0.000000091,0.707106783,-0.70710678,-0.000000017],[-1,-2,-2,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pHome:=[[0,-945,1086],[0,0.707106781,0.707106781,0],[1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPanelApp:=[[-558.605794105,740.858494952,1592.36299407],[-0.000000013,0.707106782,0.0000001,-0.70710678],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPick:=[[-119.810067308,-1248.39602458,702.240310643],[0.00000003,0.707106772,0.70710679,0.000000006],[0,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPickApp:=[[-119.810066419,-1248.396015316,752.240326923],[0.000000022,0.707106773,0.707106789,0.000000013],[0,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDoorL_Closing:=[[-1062.463976766,-89.878664994,1143.074050529],[0.000000058,0.707106785,0.000000057,-0.707106777],[0,0,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDoorL_Opening:=[[-1062.463972748,-346.590313808,1143.074054624],[-0.000000064,-0.707106775,-0.000000025,0.707106788],[0,0,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDoorR_Closing:=[[-1062.46397188,134.809496494,1143.074064223],[-0.000000076,-0.707106777,-0.000000078,0.707106786],[-1,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDoorR_Opening:=[[-1062.463981158,391.20377284,1143.074057414],[-0.000000088,-0.70710678,-0.000000059,0.707106782],[-1,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDoorL_Open:=[[-1062.463977762,-462.005785231,1143.07405977],[-0.000000069,-0.707106773,-0.000000035,0.70710679],[0,0,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pDoorR_Open:=[[-1062.463995012,501.518979449,1143.074049561],[0.000000067,0.707106786,0.000000073,-0.707106776],[-1,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PROC OpenDoors()
        MoveJ RelTool(pDoorL_Closed, 0, 0, -100), v1000, z50, MyNewTool; 
        MoveL pDoorL_Closed, v200, fine, MyNewTool;
        SetDO doGripDoorL, 1;
        ConfL \Off;
        MoveL pDoorL_Opening, v500, fine, MyNewTool;
        ConfL \On;
        SetDO doGripDoorL, 0;
        WaitTime 0.5;
        MoveJ RelTool(pDoorL_Opening, 0, 0, -100), v500, z50, MyNewTool;
         
        MoveJ RelTool(pDoorR_Closed, 0, 0, -100), v1000, z50, MyNewTool;
        MoveL pDoorR_Closed, v200, fine, MyNewTool;
        SetDO doGripDoorR, 1;
        ConfL \Off;
        MoveL pDoorR_Opening, v500, fine, MyNewTool;
        ConfL \On;
        SetDO doGripDoorR, 0;
        WaitTime 0.5;
        MoveJ RelTool(pDoorR_Opening, 0, 0, -100), v500, z50, MyNewTool; 
    ENDPROC

    PROC CloseDoors()
        MoveJ RelTool(pDoorL_Open, 0, 0, -100), v1000, z50, MyNewTool;
        MoveL pDoorL_Open, v200, fine, MyNewTool;
        SetDO doGripDoorL, 1;
        ConfL \Off;
        MoveL pDoorL_Closing, v500, fine, MyNewTool;
        ConfL \On;
        SetDO doGripDoorL, 0;
        WaitTime 0.5;
        MoveJ RelTool(pDoorL_Closing, 0, 0, -100), v500, z50, MyNewTool; 
         
        MoveJ RelTool(pDoorR_Open, 0, 0, -100), v1000, z50, MyNewTool;
        MoveL pDoorR_Open, v200, fine, MyNewTool;
        SetDO doGripDoorR, 1;
        ConfL \Off;
        MoveL pDoorR_Closing, v500, fine, MyNewTool;
        ConfL \On;
        SetDO doGripDoorR, 0;
        WaitTime 0.5;
        MoveJ RelTool(pDoorR_Closing, 0, 0, -100), v500, z50, MyNewTool; 
    ENDPROC

PROC main()
        SetDO doGripPuck, 0;
        SetDO doGripDoorL, 0;
        SetDO doGripDoorR, 0;
        SetDO doMachining, 0;
        SetDO do_klocek_pobrany, 0; 
                
        MoveJ pHome, v1000, fine, MyNewTool;
        OpenDoors;
        
        WHILE TRUE DO
            ! 1. Oczekiwanie na czujnik
            WaitDI di_klocek, 1; 
            
            ! 2. Pobranie z przenosnika
            MoveJ pPickApp, v1000, z50, MyNewTool;
            MoveL pPick, v200, fine, MyNewTool;
            
            SetDO doGripPuck, 1;            ! Ogólny chwyt
            
            ! --- IMPULS DO SMART COMPONENTU ---
            SetDO do_klocek_pobrany, 1;     ! Pobiera element i robi Dequeue
            WaitTime 0.5;
            SetDO do_klocek_pobrany, 0;     ! Od razu resetujemy! SC zadzialal na zbocze narastajace.
            ! ----------------------------------
            
            MoveL pPickApp, v500, z50, MyNewTool;
            
            ! 3. Dojazd i wlozenie do maszyny
            MoveJ pCncApp, v1000, z50, MyNewTool;
            MoveL pCncChuckApp, v500, z10, MyNewTool;
            MoveL pCncChuck, v200, fine, MyNewTool;
            
            SetDO doGripPuck, 0;            ! Puszczenie klocka (Event Manager musi miec tu akcje Detach Object!)
            ! UWAGA: Tu juz NIE ruszamy do_klocek_pobrany!
            WaitTime 0.5;
            
            MoveL pCncChuckApp, v500, z10, MyNewTool;
            MoveL pCncApp, v500, z50, MyNewTool;
            
            ! 4. Zamkniecie drzwi i obróbka
            CloseDoors;
            
            MoveJ pPanelApp, v1000, z50, MyNewTool;
            MoveL pBtnStart, v100, fine, MyNewTool;
            MoveL pPanelApp, v200, z10, MyNewTool;
            
            SetDO doMachining, 1;           ! Zamiana widocznosci modeli w Event Manager
            WaitTime 3.0; 
            SetDO doMachining, 0;
            
            MoveJ pPanelApp, v1000, z50, MyNewTool;
            MoveL pBtnUnlock, v100, fine, MyNewTool;
            MoveL pPanelApp, v200, z50, MyNewTool;
            
            ! 5. Otwarcie drzwi i pobranie z maszyny
            OpenDoors;
            
            MoveJ pCncApp, v1000, z50, MyNewTool;
            MoveL pCncChuckApp, v500, z10, MyNewTool;
            MoveL pCncChuck, v200, fine, MyNewTool;
            
            SetDO doGripPuck, 1;            ! Chwycenie obrobionego detalu (Event Manager: Attach Machined_Puck)
            ! UWAGA: Tu NIE wysylamy sygnalu do_klocek_pobrany, bo zepsulibysmy kolejke na tasmie!
            WaitTime 0.5;
            
            MoveL pCncChuckApp, v500, z10, MyNewTool;
            MoveL pCncApp, v500, z50, MyNewTool;
            
            ! 6. Odlozenie na palete/odbiór
            MoveJ pDropApp, v1000, z50, MyNewTool;
            MoveL pDrop, v200, fine, MyNewTool;
            
            SetDO doGripPuck, 0;            ! Puszczenie detalu w strefie zrzutu
            
            SetDO do_odloz_klocek, 1;       ! Odpala Detacher i przywraca fizyke!
            WaitTime 0.5;
            SetDO do_odloz_klocek, 0;
            
            MoveL pDropApp, v500, z50, MyNewTool;
            MoveJ pHome, v1000, fine, MyNewTool;
        ENDWHILE
    ENDPROC
ENDMODULE