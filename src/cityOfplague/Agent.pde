/// Agent is a one of two central class of each ABM model.
/// (Agent jest jedną z dwóch klas centralnych dla każdego modelu ABM)
//*///////////////////////////////////////////////////////////////////

/// @brief Agent podatny na infekcję jakimś wirusem.
class Agent
{
  Virus infection;   //!< Jaki ewentualnie wirus aktualnie infekuje. 
  float immunity;    //!< Odporność agenta. Zamiast dawnego PTransfer!
  
  // Położenie komórek zamieszkania i pracy
  int   flatX;       //!< X miejsca zamieszkania.
  int   flatY;       //!< Y miejsca zamieszkania.
  int   workX;       //!< X miejsca pracy.
  int   workY;       //!< Y miejsca pracy.
  
  /// @brief Konstruktor agenta. Inicjuje atrybuty.
  Agent(int initX,int initY) 
  {
    infection=null;
    flatX=workX=initX;
    flatY=workY=initY; //"workX|Y" mоże zostać sensowniej przypisane później
    immunity=( random(1.0)+random(1.0)+random(1.0)
              +random(1.0)+random(1.0)+random(1.0) )/6.0; //Średnia 0.5
             //random(1.0); //Srednia taka sama, ale rozkład płaski
  }
  
  /// @brief Opis agenta.
  String fullInfo(String fieldSeparator)
  {
    return "Immunity: "+immunity+fieldSeparator+
           "Flat at "+flatX+","+flatY+fieldSeparator+
           "Work at "+workX+","+workY+fieldSeparator+
           "Infected: "+infection;
  }
  
  /// @brief Czy agent jeszcze żyje?
  boolean isAlive()
  {
    if(isSusceptible()) return true;
    return infection.state!=HostDeath;
  }
  
  /// @brief Czy agent jest podatny na infekcje?
  boolean isSusceptible()
  {
    return infection==null;
  }
  
  /// @brief Czy agent jest zainfekowany?
  boolean isInfected()
  {
    if(infection==null) return false;    assert infection.state!=HostDeath : "Nie można być martwym!";
    return infection.state!=Recovered && Infected<=infection.state; //<=
  }  
  
  // @brief Jakby zarażał od wyższego progu?
  //float   hasIllness() 
  //{
  //  if(infection==null) return 0;
  //  return infection.state; //???
  //}
  
  /// @brief Czy już wyzdrowiał?
  boolean isRecovered()
  {
    if(infection==null) return false;
    return infection.state==Recovered;
  }
  
  /// @brief Czy jest umierający?
  boolean justDying()
  {
    if(infection==null) 
        return false; // Nie ma na co umrzeć
        
    assert infection.state!=HostDeath : "Nie można umrzeć więcej niż raz!";
    
    if(infection.state==Recovered)
        return false;
        
    float prob=random(1); // Los na dany dzień
    
    if(prob<infection.pDeath) // Albo tego dnia umiera
    {
      infection.state=HostDeath;
      return true;
    }
    else return false; // Albo zyje dalej
  }
  
  /// @brief Właśnie wyleczony!
  boolean justHealed()
  {
    assert !isSusceptible() : "Agent musi mieć zarazek!";
    assert !isRecovered()   : "Agent nie może być już wyleczony!";
    
    if(++(infection.state)==infection.duration)
    {
      infection.state=Recovered;
      return true;
    }
    else
      return false;
  }
  
  /// @brief Implementacja infekcji
  void transferFrom(Agent infectious)
  {
    assert !infectious.isSusceptible() : "'infectious' musi mieć zarazek!";
    infection=infectious.infection.clone();
  }
 
}//_endOfClass

//*/////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: AGENT from TEMPLATE
//*/////////////////////////////////////////////////////////////////////////////////////////
