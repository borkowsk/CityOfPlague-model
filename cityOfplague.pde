/// ABM epidemic model with enviroment 
/// - using template for AGENT BASE MODEL in 2D discrete geometry
/// implemented by Wojciech Borkowski
//*///////////////////////////////////////////////////////////////////////////////////////
/// Generalny pomysł jest taki, że mamy miasto podzielone drogami, złożone z obszarów mieszkalnych (jasne) i miejsc pracy (szare).
/// Ci sami agenci na zmianę są w domu lub w pracy, i wszędzie mogą zarazić się przez kontakt.
/// Stąd jeden krok symulacji to pół dnia - parzyste kroki w pracy, nieparzyste w domu, chyba że agent nie ma pracy.
//
/// Właściwości danego wirusa są opisane parametrami symulacji.
/// Właściwością agentów poza rozlosowaną z rozkładu dwumianowego "immunity" jest tylko wiedza o miejscu zamieszkania i miejscu pracy.

//PARAMETRY MODELU
String modelName="ABMcity_of_plague";//NAZWA modelu.
int RANDSEED=-1033;

int side=300;  ///< DŁUGOŚĆ BOKU ŚWIATA - PIONOWEGO. Poziomy jest x2
float density=0.66; ///< Gęstość zaludnienia na "terenach mieszkalnych"

//final float PTransfer=???;  //Prawdopodobieństwo zarażenia agenta w pojedynczej interakcji
                              //teraz zależy od indywidualnej wartości immunity!
                              
/// DOMYŚLNE WŁAŚCIWOŚCI ZARAZKA!
final float  defPSLeav=0.90; ///< Domyślne prawdopodobieństwo, że danego DNIA chory agent nie będzie w stanie iść do pracy                             
final float  defPDeath=0.15; ///< Domyślne średnie prawdopodobieństwo śmierci w danym kroku(!) choroby. Teraz krok to 12 godzin.
final int    defDuration=14; ///< Domyślny czas trwania infekcji! W krokach symulacji. Teraz krok to 12 godzin!!! Czyli default to 7 dni.

/// Właściwości nie związane z epidemią
final int    Nprob=10;          ///< Liczba prób szukania pracy w inicjalizacji. Jak się nie uda to agent cały czas siedzi w domu
final float  dutifulness=0.900; ///< Jak często zdrowi agenci idą do pracy. Mogą pracować w domu lub mieć ograniczone wychodzenie.
final float  lockdownness=0.20; ///< Ale lockdown nigdy nie jest kompletny (RACZEJ?)
final int    lockdownStep=20;   ///< W którym kroku symulacji (2 kroki na dzień) wprowadzamy lockdown
final int    protestStep=40;

/// Stałe używane do określania stanu agentów   
final int Infected=1;
final int Recovered=0;
final int HostDeath=Integer.MAX_VALUE; ///< Ryzykowne nieco(?) bo w wirusie jest pole typu float (TODO!)

World TheWorld=new World(side); ///< INICJALIZACJA ŚWIATA. JEST KOŃCZONA W FUNKCJI setup()

/// STATYSTYKI LICZONE W TRAKCIE SYMULACJI
int liveCount=0;

int sumInfected=0;  ///< Zachorowanie
int sumRecovered=0; ///< Wyzdrowienia
int sumDeath=0;     ///< Ci co umarli

FloatList deaths=new FloatList(); ///< Historia śmierci 
FloatList newcas=new FloatList(); ///< Historia nowych zachorowań
FloatList  cured=new FloatList(); ///< Historia wyleczeń 

/// PARAMETRY WIZUALIZACJI, STATYSTYKI ITP.
int cwidth=2;  ///< DŁUGOŚĆ BOKU KOMÓRKI W WIZUALIZACJI
               ///< WARTOSC NADANA TU JEST TYLKO WSTĘPNA
int STATUSHEIGH=150;  ///< WYSOKOŚĆ PASKA STATUSU NA DOLE OKNA
int STEPSperVIS=1;    ///< JAK CZĘSTO URUCHAMIAMY WIZUALIZACJĘ
int FRAMEFREQ=4;      ///< ILE RAZY NA SEKUNDĘ URUCHAMIA SIĘ draw()

boolean WITH_VIDEO=true; ///< CZY CHCEMY ZAPIS DO PLIKU FILMOWEGO (wymagany modu… RTMVideo.pde)
boolean simulationRun=true; ///< FLAGA Start/Stop DZIAŁANIA SYMULACJI

void setup()
{
  // GRAFIKA
  pixelDensity(1); //1 or 2, expecially for "Retina" (HERE?)
  size(1200,750);  //NIESTETY TU MOGĄ BYĆ TYLKO WARTOŚCI PODANE LITERALNIE CZYLI "LITERAŁY"!!!
  pixelDensity(1); //1 or 2, expecially for "Retina" (or HERE?)
  println("Width:",width,"Height:",height,"displayDensity:",displayDensity());
  noSmooth();      //Znacząco przyśpiesza wizualizacje
  frameRate(FRAMEFREQ);
  background(255,255,200);
  strokeWeight(2);
  if(RANDSEED!=0)
      randomSeed(RANDSEED); //Zasianie generatora gdy chcemy mieć powtarzalny przebieg
  
  // INICJALIZACJA MODELU I (ewentualnie) STATYSTYK
  initializeModel(TheWorld); //DOKONCZENIE INICJALIZACJI ŚWIATA
  //initializeStats();       //ODKOMENTOWAĆ JEŚLI UŻYWAMY STATYSTYK
  doStatistics(TheWorld);    //J.W.
  
  // OBLICZAMY WYMAGANY ROZMIAR OKNA DLA size() 
  println(modelName+": REQUIRED SIZE OF PAINTING AREA IS "
          +(cwidth*side*2)+"x"+(cwidth*side+STATUSHEIGH)); //Tu brakowało 2
          
  cwidth=(height-STATUSHEIGH)/side; //DOPASOWUJEMY ROZMIAR KOMÓREK DO OKNA JAKIE JEST
  
  // INICJALIZACJA ZAPISU FILMU  (jeśli używamy RTMVideo.pde)
  if(WITH_VIDEO) {initVideoExport(this,modelName+".mp4",FRAMEFREQ);}
  
  // INFORMACJE KONSOLOWE NA KONIEC FUNKCJI setup()
  println("CURRENT SIZE OF PAINTING AREA IS "+width+"x"+height); //-myMenu.bounds.height???
  visualizeModel(TheWorld); //PIERWSZA PO INICJALIZACJI WIZUALIZACJA ŚWIATA
  FirstVideoFrame();
  
  if(!simulationRun) // WYMAGA MODUŁU RTMEvents.pde
    println("PRESS 'r' or 'ESC' to start simulation");
  else
    println("PRESS 's' or 'ESC' to pause simulation");
  
  NextVideoFrame(); //PIERWSZA REALNA KLATKA FILMU (o ile używamy RTMVideo.pde)
}

void draw()
{
  if(simulationRun)
  {
    modelStep(TheWorld);
    doStatistics(TheWorld); //ODKOMENTOWAĆ JEŚLI UŻYWAMY STATYSTYK
  }                         //Używa wewnętrznej flagi określajacej czy log został otwarty
  
  writeStatusLine();
  
  if(!simulationRun //When simulation was stopped only visualisation should work
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation should be done from time to time
  {
    visualizeModel(TheWorld);
    NextVideoFrame(); //FUNKCJA ZAPISU KLATKI FILMU. 
  }                   //Używa wewnętrznej flagi określajacej czy film został otwarty

}

void writeStatusLine()
{
  fill(0);rect(0,side*cwidth,width,STATUSHEIGH);fill(128);
  histogram(TheWorld.agents,0,height-16,STATUSHEIGH-16); //Histogram wg. odporności  
  
                                                                   // Albo historie trzech zmiennych dziennych 
  // Legenda                                                        // w swojej skali
  stroke(0,0,255);fill(0,0,200);text("nowi chorzy",300,height-16); //timeline(newcas,200,height,STATUSHEIGH-16,false);
  stroke(255,0,0);fill(200,0,0);text("nowi zmarli",300,height-32); //timeline(deaths,200,height,STATUSHEIGH-16,false);
  stroke(0,255,0);fill(0,200,0);text("nowo wyleczeni",300,height-48); //timeline(cured, 200,height,STATUSHEIGH-16,false);
  
  // Historie trzech zmiennych we wspólnej skali
  stroke(0,0,255);fill(0,0,255);
  timeline(newcas,deaths,cured, 200,height,STATUSHEIGH-16,false,color(0,0,255),color(255,0,0),color(0,255,0));
  
  fill(128);noStroke(); //Miejce dla NAJWAŻNIEJSZYCH STATYSTYK
  textAlign(RIGHT, TOP);
  text("Żyją:"+liveCount+" Zachorowali:"+sumInfected+" Wyzdrowieli:"+sumRecovered+" Umarli:_____________",width,side*cwidth);
  fill(255,0,0);
  text(" "+sumDeath+" ",width,side*cwidth);
  
  if(simulationRun) 
    println("ST:"+(StepCounter/2.0)+"\tZ\t"+sumInfected+"\t"+newcas.get(newcas.size()-1)
                             +"\tW\t"+sumRecovered+"\t"+cured.get(cured.size()-1)
                             +"\tU\t"+sumDeath+"\t"+deaths.get(deaths.size()-1)
                             +"\t Fps:\t"+ frameRate);
                             
  textAlign(LEFT, BOTTOM);fill(255);
  text("Day:"+(StepCounter/2.0)+" "+(lockdownStep<StepCounter?"LOCKDOWN:"+((1.0-lockdownness)*100)+"%":""),0,height); //Ale lockdown nigdy nie jest kompletny (RACZEJ?)
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - from ABM MAIN TEMPLATE
//*/////////////////////////////////////////////////////////////////////////////////////////
