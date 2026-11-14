# Robot CNC Machine Tending – ABB IRB 2600 w RobotStudio

Symulacja zrobotyzowanego stanowiska obsługi obrabiarki CNC w środowisku **ABB RobotStudio**. Robot samodzielnie pobiera detal z przenośnika, otwiera i zamyka drzwi obrabiarki, ładuje detal na stół maszyny, uruchamia obróbkę przyciskiem na panelu, a po jej zakończeniu wyjmuje gotowy element i odkłada go na drugi przenośnik. Cykl działa w pętli.

Projekt został wykonany w **zespole dwuosobowym**.

![Stanowisko robota przy obrabiarce](docs/images/cell-door-and-cnc.png)

---

## Spis treści

- [Opis projektu](#opis-projektu)
- [Użyte technologie](#użyte-technologie)
- [Przebieg cyklu](#przebieg-cyklu)
- [Działanie w symulacji](#działanie-w-symulacji)
- [Program robota (RAPID)](#program-robota-rapid)
- [Sygnały I/O](#sygnały-io)
- [Logika stacji (Smart Components)](#logika-stacji-smart-components)
- [Zdefiniowane punkty](#zdefiniowane-punkty)

---

![Robot w pozycji wyjściowej](docs/images/cell-overview.png)

## Opis projektu

Stanowisko składa się z:

- robota **ABB IRB 2600-12/1.65 Type C** z chwytakiem (narzędzie `MyNewTool`),
- obrabiarki CNC z drzwiami otwieranymi i zamykanymi przez robota oraz panelem z przyciskami Start i Unlock,
- dwóch przenośników taśmowych: wejściowego (dostarcza surowy detal) i wyjściowego (odbiera obrobiony detal),
- ogrodzenia ochronnego.

Detal jedzie po taśmie do pola z czujnikiem. Gdy wjedzie na czujnik, taśma zatrzymuje się, a robot rozpoczyna sekwencję ruchów. Cała logika zachowania detalu w symulacji (pojawianie się, kolejka, przyczepianie do chwytaka, zamiana na element obrobiony) jest zrealizowana komponentami inteligentnymi (Smart Components) i sterowana sygnałami z programu robota.

![Robot pobierający detal z przenośnika](docs/images/cell-conveyor-pick.png)

## Użyte technologie

| Element | Wersja / model |
|---|---|
| Środowisko symulacyjne | ABB RobotStudio |
| Robot | ABB IRB 2600-12/1.65 Type C |
| Oprogramowanie sterownika | RobotWare 6.16.03 (wirtualny kontroler IRC5) |
| Język programowania robota | RAPID |
| Logika symulacji | Smart Components, Station Logic |

## Przebieg cyklu

1. **Start:** program zeruje sygnały wyjściowe, robot jedzie do pozycji domowej (`pHome`) i otwiera drzwi obrabiarki.
2. **Oczekiwanie:** program czeka na sygnał czujnika `di_klocek`, który oznacza, że detal dojechał do końca przenośnika wejściowego.
3. **Pobranie detalu:** robot zjeżdża do punktu `pPick`, chwyta detal (`doGripPuck`) i wysyła impuls `do_klocek_pobrany`, który zdejmuje detal z kolejki na taśmie.
4. **Załadunek do CNC:** robot wjeżdża do obrabiarki, odkłada detal na stół (`pCncChuck`) i wycofuje się.
5. **Zamknięcie drzwi:** robot zamyka lewe i prawe drzwi obrabiarki.
6. **Obróbka:** robot naciska przycisk startu na panelu (`pBtnStart`), a sygnał `doMachining` symuluje obróbkę przez 3 s (zamiana modelu surowego detalu na obrobiony).
7. **Odblokowanie:** robot naciska przycisk na panelu (`pBtnUnlock`) i ponownie otwiera drzwi.
8. **Wyjęcie detalu:** robot chwyta obrobiony element i wynosi go z maszyny.
9. **Odłożenie:** robot odkłada element na drugi przenośnik (`pDrop`), wysyła impuls `do_odloz_klocek` i wraca do pozycji domowej.
10. **Pętla:** cykl wraca do kroku 2.

## Działanie w symulacji

Poniższe zrzuty ekranu pokazują kolejne etapy pracy robota przy obrabiarce.

**Załadunek i rozładunek:** robot wjeżdża do wnętrza obrabiarki przy otwartych drzwiach i odkłada detal na stół albo wyjmuje obrobiony element.

![Robot wewnątrz obrabiarki](docs/images/cnc-loading.png)

**Uruchomienie obróbki:** po zamknięciu drzwi robot naciska przycisk na panelu obrabiarki. W oknie maszyny widać detal leżący na stole.

![Robot naciskający przycisk na panelu](docs/images/cnc-panel-button.png)

**Obróbka i praca przy stole:** robot pracuje przy stole obrabiarki. Zmiana wyglądu detalu po obróbce jest realizowana w logice stacji po sygnale `doMachining`.

![Robot przy stole obrabiarki](docs/images/cnc-machining.png)

## Program robota (RAPID)

Program znajduje się w `src/rapid/Module1.mod` i składa się z trzech procedur:

| Procedura | Zadanie |
|---|---|
| `OpenDoors` | otwiera lewe, a następnie prawe drzwi obrabiarki |
| `CloseDoors` | zamyka lewe, a następnie prawe drzwi |
| `main` | inicjalizacja i nieskończona pętla `WHILE TRUE` z pełnym cyklem |

Fragment pętli głównej:

```
WHILE TRUE DO
    ! 1. Oczekiwanie na czujnik
    WaitDI di_klocek, 1;

    ! 2. Pobranie z przenosnika
    MoveJ pPickApp, v1000, z50, MyNewTool;
    MoveL pPick, v200, fine, MyNewTool;
    SetDO doGripPuck, 1;

    ! Impuls do Smart Componentu
    SetDO do_klocek_pobrany, 1;
    WaitTime 0.5;
    SetDO do_klocek_pobrany, 0;
    ...
ENDWHILE
```

Najważniejsze rozwiązania:

- **Dojazdy z odsunięciem:** przed każdym zbliżeniem do detalu lub drzwi robot jedzie do punktu pośredniego (`...App` lub `RelTool(..., 0, 0, -100)`), a dopiero potem wolno zbliża się do celu ruchem liniowym.
- **Różne prędkości:** szybkie ruchy `MoveJ` (`v1000`) w przestrzeni swobodnej, wolne `MoveL` (`v200`, `v100`) przy chwytaniu i naciskaniu przycisków.
- **Drzwi:** robot chwyta każde skrzydło drzwi (`doGripDoorL`, `doGripDoorR`), pociąga je do pozycji otwartej lub zamkniętej i puszcza. Podczas przesuwu drzwi wyłączana jest kontrola konfiguracji osi (`ConfL \Off`).
- **Sygnały impulsowe:** sygnały `do_klocek_pobrany` i `do_odloz_klocek` są podawane krótkim impulsem i od razu zerowane, bo logika stacji reaguje na zbocze narastające.
- **Narzędzie:** dane chwytaka (`MyNewTool`) są w osobnym module `CalibData.mod`. Środek narzędzia (TCP) przesunięty jest o 89 mm w osi Z.

## Sygnały I/O

| Sygnał | Typ | Znaczenie |
|---|---|---|
| `di_klocek` | wejście | czujnik: detal dojechał do końca przenośnika wejściowego |
| `doGripPuck` | wyjście | chwytak: chwyć / puść detal |
| `doGripDoorL` | wyjście | chwytak: chwyć / puść lewe skrzydło drzwi |
| `doGripDoorR` | wyjście | chwytak: chwyć / puść prawe skrzydło drzwi |
| `doMachining` | wyjście | symulacja obróbki w CNC (zamiana modeli detalu) |
| `do_klocek_pobrany` | wyjście | impuls: detal pobrany z taśmy, zdejmij go z kolejki |
| `do_odloz_klocek` | wyjście | impuls: odłóż detal na przenośnik, przywróć fizykę |

Są to sygnały wirtualne (bez przypisanego urządzenia I/O), połączone z komponentami w logice stacji. Ich definicje są w pliku `src/rapid/EIO.cfg`.

## Logika stacji (Smart Components)

Zachowanie detalu w symulacji realizują komponenty z biblioteki RobotStudio oraz logika stacji (Event Manager), połączone sygnałami z programu robota.

| Element | Zadanie w projekcie |
|---|---|
| `PlaneSensor` / `VolumeSensor` | wykrywanie detalu na końcu taśmy i w strefie odbioru |
| `Source` / `Sink` | tworzenie i usuwanie detali na przenośnikach |
| `Queue` | kolejka detali na taśmie (dodawanie i zdejmowanie) |
| `LogicGate` | bramki logiczne łączące sygnały czujników i timerów |
| `Timer` | odstęp czasowy między kolejnymi detalami |
| `PhysicsControl` | włączanie i wyłączanie fizyki detalu |
| `Attacher` / `Detacher` | przyczepianie detalu do chwytaka i odczepianie po odłożeniu |
| Event Manager | zamiana widoczności modeli surowego i obrobionego detalu |

Zasada działania:

- czujnik na końcu taśmy zatrzymuje przenośnik i ustawia sygnał `di_klocek` dla robota,
- impuls `do_klocek_pobrany` pobiera detal z taśmy i zdejmuje go z kolejki (`Dequeue`),
- zwolnienie chwytaka w obrabiarce (`doGripPuck` = 0) odczepia surowy detal od narzędzia,
- `doMachining` zamienia widoczność modeli: surowy detal znika, a pojawia się obrobiony,
- chwycenie detalu w obrabiarce (`doGripPuck` = 1) przyczepia obrobiony element do chwytaka,
- impuls `do_odloz_klocek` uruchamia odczepienie detalu na drugim przenośniku i przywraca jego fizykę.

## Zdefiniowane punkty

W programie zdefiniowano 19 punktów (`robtarget`):

| Grupa | Punkty |
|---|---|
| Pozycja domowa | `pHome` |
| Przenośnik wejściowy | `pPickApp`, `pPick` |
| Obrabiarka | `pCncApp`, `pCncChuckApp`, `pCncChuck` |
| Drzwi lewe | `pDoorL_Closed`, `pDoorL_Opening`, `pDoorL_Open`, `pDoorL_Closing` |
| Drzwi prawe | `pDoorR_Closed`, `pDoorR_Opening`, `pDoorR_Open`, `pDoorR_Closing` |
| Panel obrabiarki | `pPanelApp`, `pBtnStart`, `pBtnUnlock` |
| Przenośnik wyjściowy | `pDropApp`, `pDrop` |

