# READ_ME.txt

I.  Kolejność wykonywania skryptów

    1. Stworzenie hurtowni danych ze skryptów CallCenterStaffing/DataWarehouse/
    2. Wygenerowanie danych wymiarów skryptami 50_ [...] 53_
    3. Wygenerowanie danych faktów skryptem 01_
        3.1 Skrypt 00_ stworzony jest dla porównania skryptu 01_ (losowe dane historyczne vs. rozkład Poissona)
    4. Wygenerowanie prognozy nadchodzących połączeń skryptem 03_
    5. Wygenerowanie prognozy zapotrzebowanie liczby konsultantów wraz z kalendarzem pracy

II. Opis skryptów:

    00_
    01_
    03_
    0405_
    50_
    51_
    52_
    53_
    98_
    99_

III. Opis modułów pakietu py_package:

    __init__.py
    db_conn.py
    erlang_c.py
    model.py
    path_maker.py
    py_module.py
    utils.py
