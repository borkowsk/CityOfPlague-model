# cityOfplague

## "ABM model of plague on in the organized spatial environment" - agentowy model przebiegu epidemii w przestrzeni zorganizowanej.

W repozytorium znajduje się demonstracyjny prototyp agentowego modelu epidemii w mieście jako przestrzeni 
podzielonej na trzy kategorie obszarów, w których ci sami agenci wchodzą ze sobą w wymuszone kontakty.

Program powstał na początku epidemii __COVID19__, i prace rozwojowe zostały porzucone, gdy okazało się, 
że podobnych modeli powstało w tymczasie wiele.  Stanowi jednak dobry przykład kompletnej, acz niezbyt 
skomplikowanej aplikacji symulacyjnej.

Językiem podstawowym jest __Processing__ w wersji 3.x, jednak kod był pisany z myślą o automatycznej 
translacji na język __C++__ za pomoca narzędzia __Processing2C++__

###
Zarówno gospodarze jak i wirusy są agentami z teoretyczną możliwością mutacji.
Miasto podzielone jest fraktalnie siecią ulic i alei o różnej szerokości.

Główna idea modelu polega na tym, że agenci zarażają się faktycznie przez kontakt 
w różnych przestrzeniach, w których zdarza im się przebywać. 
Taka przestrzeń jest inna dla snu i odpoczynku (miejsce zamieszkania w dzielnicy
mieszkaniowej), inna dla pracy (miejsce pracy), a możliwe są też zdarzenia w 
przestrzeni specjalnej - np. demonstracje (na głównej ulicy). 

## Dostęp do repozytorium 

Dostęp read-only za pomoca protokołu _https_

```
git clone https://github.com/borkowsk/CityOfPlague-model.git
```

Dostęp z możliwością modyfikacji można uzyskać za pomocą protokołu _ssh_ , otrzymując uprzednio odpowiednie prawa 
od autora projektu.

```
git clone git@github.com:borkowsk/CityOfPlague-model.git
```
UWAGA! Nazwa katalogu musi być domyślna czyli taka sama jak nazwa głównego pliku źródłowego
To jest wymaganie Processingu:

**cityOfplague/cityOfplague.pde**


## FINANSOWANIE I AUTORSTWO

This project is sponsored by __Centre For Systemic Risk Analisis__. 

* https://cbrs.uw.edu.pl/en/home-page/
  
* https://cbrs.uw.edu.pl/pl/home-page/

### Autorzy

* Wojciech Tomasz Borkowski - programowanie
* Andrzej Krzysztof Nowak - cześć koncepcji




