// Różne żyjątka, które mogę szkodzić agentom
//////////////////////////////////////////////////////

class Animalcule
//Klasa bazowa
{
}

class Germ extends Animalcule
//Klasa bazowa zarazków
{          
  float  pDeath=0.0;      //Średnie prawdopodobieństwo śmierci w danym kroku(!) choroby. Teraz krok to 12 godzin.
  float  pSickLeave=0.09; //Prawdopodobieństwo, że danego DNIA chory agent nie będzie w stanie iść do pracy   
  int    duration=14;     //Czas trwania infekcji! W krokach symulacji. Teraz krok to 12 godzin!!! Czyli default to 7 dni.
                          //W modelu profesjonalnym czas powinien być raczej w godzinach
  boolean hostIsDead() { return false;} //Domyślnie nigdy nie umiera bo to KATAR
  
  String fullInfo(String fieldSeparator)
  {
    return "pDeath: "+pDeath+fieldSeparator+
           "pSickLeave: "+pSickLeave+fieldSeparator+
           "duration: "+pDeath+fieldSeparator;
  }
}

class Virus extends Germ
//Klasa bazowa wirusów
{
  float state;//"Miano" wirusów/stadium infekcji
  Virus(float iPDeath,float iPSickLeave,int iDuration)//Na razie wciąż ten bardzo uproszczony model
  {
    pDeath=iPDeath;
    pSickLeave=iPSickLeave;
    duration=iDuration;
    state=1;//Stan początkowy - iniekcja wirusa
  }
  
  Virus clone()//Nowy wirus do zaatakowanie innego agenta
  {
    return new Virus(pDeath,pSickLeave,duration);
  }
  
  boolean hostIsDead() 
  { 
    return state>=HostDeath;//Jak już przekroczymy miano krytyczne
  }
  
  String fullInfo(String fieldSeparator)
  {
    return super.fullInfo(fieldSeparator)+"State: "+state+fieldSeparator;
  }
}
