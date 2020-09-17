# Phases projet

## Phase 1

- [X] Scénario home ENGIE (home + clic souscrire)
- [X] Setup proxy
- [ ] Start & Stop du proxy dans RF - **Maher**
  - [ ] test du start & stop de BrowserMobProxyLibrary dans RF
- [ ] Récupération des HTTP dans LOG (avec un nom de fichier à définir qui contient le test case) - **Maher**
- [X] Test GA unit - **Vincent**
  - [X] avec un exemple de fichier LOG à partir de Python
  - [ ] à partir de RF avec contrôle de la checklist

## Phase 2

- [ ] Scénario 1 Test complet du tunnel
  - [ ] Plan de marquage du tunnel - **Vincent + Francois**
  - [ ] Adapter le code existant RF sur  pour faire le test complet en local - **Maher**
    - https://github.com/engie-dgp-particuliers-perf/busfactorytestsauto/blob/master/vabf_full/TestCase/Demande_de_souscription.robot 
    - nécessite d'ajouter SeleniumGrid dans le code
- [ ] Adapter le code existant RF pour run sur le serveur Jenkins dans des jobs existants Jenkins (Selenium Grid) - **Maher**
- [ ] Scénario 2: connexion
  - [ ] ...