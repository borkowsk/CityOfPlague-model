// Agent is a one of two central class of each ABM model
///////////////////////////////////////////////////////////////
class Agent
{
  Virus infection;
  float immunity;//Zamiast PTransfer!
  
  //Polożenie komorek zamieszkania i pracy
  int   flatX;
  int   flatY;
  int   workX;
  int   workY;
  
  Agent(int initX,int initY)//Konstruktor agenta. Inicjuje atrybuty
  {
    infection=null;
    flatX=workX=initX;
    flatY=workY=initY;//"workX|Y" mоże zostać sensowniej przypisane później
    immunity=( random(1.0)+random(1.0)+random(1.0)
              +random(1.0)+random(1.0)+random(1.0) )/6.0;//Średnia 0.5
             //random(1.0);//Srednia taka sama, ale rozkład płaski
  }
  
  boolean isAlive()
  {
    if(isSusceptible()) return true;
    return infection.state!=HostDeath;
  }
  
  boolean isSusceptible()
  {
    return infection==null;
  }
  
  boolean isInfected()
  {
    if(infection==null) return false;
    assert infection.state!=HostDeath : "Nie można być martwy!";
    return infection.state!=Recovered && Infected<=infection.state;//<=
  }  
  
  //float   hasIllness() //Jakby zarażał od wyższego progu?
  //{
  //  if(infection==null) return 0;
  //  return infection.state;//???
  //}
  
  boolean isRecovered()
  {
    if(infection==null) return false;
    return infection.state==Recovered;
  }
  
  boolean justDying()
  {
    if(infection==null) 
        return false;//Nie ma na co umrzeć
        
    assert infection.state!=HostDeath : "Nie można umrzeć więcej niż raz!";
    
    if(infection.state==Recovered)
        return false;
        
    float prob=random(1);//Los na dany dzień
    
    if(prob<infection.pDeath) //Albo tego dnia umiera
    {
      infection.state=HostDeath;
      return true;
    }
    else return false;//Albo zyje dalej
  }
  
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
  
  void transferFrom(Agent infectious)
  {
    assert !infectious.isSusceptible() : "'infectious' musi mieć zarazek!";
    infection=infectious.infection.clone();
  }
 
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: AGENT FOR FILL UP
///////////////////////////////////////////////////////////////////////////////////////////
