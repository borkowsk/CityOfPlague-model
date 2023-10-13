/// World is a one of two central class of each ABM model
/// (Świat jest jedną z dwóch klas centralnych każdego modelu ABM)
//*///////////////////////////////////////////////////////////////
int StepCounter=0;     ///< GLOBALNY LICZNIK KROKÓW SYMULACJI.

/// @brief Klasa świata symulacji. Łączy wszystkie niezbędne składowe modelu.
class World
{
  Agent agents[][]; //!< DWUWYMIAROWA TABLICA AGENTÓW.
  int      env[][]; //!< TABLICA SRODOWISKA - "environment".
  
  /// KONSTRUKTOR ŚWIATA
  World(int side)
  {
    env=new int[side][2*side];
    agents=new Agent[side][2*side];
  }
}//_endOfClass

// BARDZIEJ ZŁOŻONE FUNKCJONALNOŚCI ZOSTAŁY ZDEFINIOWANE JAKO OSOBNE FUNKCJE
// A NIE METODY KLASY World ZE WZGLĘDU NA OGRANICZENIA SKŁADNI PROCESSINGU
// NIE POZWALAJĄCEJ SCHOWAĆ GDZIEŚ INDZIEJ MNIEJ ISTOTNYCH METOD KLASY
//*/////////////////////////////////////////////////////////////////////////

/// @brief Inicjalizacja całości świata.
void initializeModel(World world)
{
  initializeEnv(world.env);
  initializeAgents(world.agents,world.env);
}

/// @brief Wizualizacja całości świata.
void visualizeModel(World world)
{
  visualizeEnv(world.env);
  visualizeAgents(world.agents);
}

/// @brief Krok symulacji.
void modelStep(World world)
{
   //environmentChange(world.env); // W tej symulacji niepotrzebne
   agentsChange(world.agents);
   if(protestStep==StepCounter)
   {
       sheduleProtest(world.agents,world.env,0.1);
       visualizeModel(TheWorld); // DLA PEWNOŚCI, ŻEBY PROTEST ZAWSZE BYŁ WIDOCZNY CHOCIAŻ NA FILMIE
       NextVideoFrame();         // FUNKCJA ZAPISU KLATKI FILMU. 
   }
   else
       sheduleAgents(world.agents,world.env,StepCounter);
   StepCounter++;
}

//*////////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: WORLD OF AGENTS from template
//*////////////////////////////////////////////////////////////////////////////////////////////////
