/// Germs, i.e. various "little things" that can harm agents.
/// (Zarazki czyli różne "żyjątka", które mogę szkodzić agentom)
//*////////////////////////////////////////////////////////////

/// @brief Klasa bazowa wszelkich "żyjątek"
class Animalcule
{
}//_endOfClass

/// @brief Klasa bazowa zarazków.
class Germ extends Animalcule
{          
  float  pDeath=0.0;      //!< Średnie prawdopodobieństwo śmierci w danym kroku(!) choroby. Teraz krok to 12 godzin.
  float  pSickLeave=0.09; //!< Prawdopodobieństwo, że danego DNIA chory agent nie będzie w stanie iść do pracy.   
  int    duration=14;     //!< Czas trwania infekcji (w krokach symulacji). Teraz krok to 12 godzin!!! Czyli default to 7 dni.
                          //!< W modelu profesjonalnym czas powinien być raczej w godzinach.
                         
  /// @brief Czy zarazek już zabił żywiciela?                        
  boolean hostIsDead() { return false;} //!< Domyślnie nigdy nie umiera bo to KATAR.
  
  /// @brief Opis danego zarazka.
  String fullInfo(String fieldSeparator)
  {
    return "pDeath: "+pDeath+fieldSeparator+
           "pSickLeave: "+pSickLeave+fieldSeparator+
           "duration: "+pDeath+fieldSeparator;
  }
}//_endOfClass

/// @brief Klasa bazowa wszelkich wirusów.
class Virus extends Germ
{
  float state; //!< "Miano" wirusów/stadium infekcji.
  
  /// @brief Konstruktor wirusa. Na razie wciąż ten bardzo uproszczony model.
  Virus(float iPDeath,float iPSickLeave,int iDuration)
  {
    pDeath=iPDeath;
    pSickLeave=iPSickLeave;
    duration=iDuration;
    state=1; //Stan początkowy - iniekcja wirusa
  }
  
  /// @brief Nowy wirus do zaatakowanie innego agenta. Mogłby ulec jakimś mutacjom.
  Virus clone()
  {
    return new Virus(pDeath,pSickLeave,duration);
  }
  
  /// @brief Czy już przekroczono miano krytyczne wirusa, które zabija żywiciela?
  boolean hostIsDead() 
  { 
    return state>=HostDeath;
  }
  
  /// @brief Informacja o zarazku
  String fullInfo(String fieldSeparator)
  {
    return super.fullInfo(fieldSeparator)+"State: "+state+fieldSeparator;
  }
}//_endOfClass

//*/////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - City of Plague
//*/////////////////////////////////////////////////////////////////////////////////////////
