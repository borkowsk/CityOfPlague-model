/// Agent needs to be initialised & they need logic of change
/// (Agent musi zostać zainicjowany i potrzebuje logiki zmian)
//*///////////////////////////////////////////////////////////

/// @brief Funkcja umieszcza agentów w domach i szuka im pracy
void initializeAgents(Agent[][] agents,int[][] env)
{
   for(int a=0;a<agents.length;a++)     // po Y
    for(int b=0;b<agents[a].length;b++) // po X
      if(env[a][b]==Env_FLAT && random(1)<density) // Tylko w obszarach mieszkalnych
      {
        Agent curr=new Agent(b,a);
        liveCount++;
        
        // DODATKOWY KOD INICJALIZACJI AGENTÓW
        env[a][b]|=1; // Zaznaczamy mieszkanie jako zajęte
        
        // Kazdemu agentowi dajemy N szans znalezienia miejsca pracy
        for(int i=0;i<Nprob;i++)
        {
          curr.workX=int(random(agents[0].length));
          curr.workY=int(random(agents.length));
          if( env[curr.workY][curr.workX]/100==1    // Wszystkie miejsca pracy mają wartość w zakresie 100-199
          &&  (env[curr.workY][curr.workX] & 1) !=1 // Jak zajęte to ma na końcu jedynkę. Taka sztuczka   
          )
          {
                                               assert (env[curr.workY][curr.workX] & 1) == 0;
             env[curr.workY][curr.workX] |= 1; // Zaklepuje sobie to miejsce pracy
             break; // Mam już miejsce pracy
          }
          else // Nadal pracuje w domu
          {
            curr.workX=curr.flatX;
            curr.workY=curr.flatY;
          } 
        }
        agents[a][b]=curr;
      }
      
   // Inicjowanie infekcji z pozycji losowej
   int a=int(random(agents.length/3));
   int b=int(random(agents[0].length/3));
   if(agents[a][b]==null) // Gdyby go nie było
   {
      agents[a][b]=new Agent(b,a); // Konstruktor wymusza podanie x,y położenia!
      liveCount++;
   }
   println("Pacjent 0 @",b,"x",a);
   agents[a][b].infection=new Virus(defPDeath,defPSLeav,defDuration);
}

/// @brief Generuje protest o rozmiarze participationProb na głównej alei (oczywiście tylko z żywych agentów)
void sheduleProtest(Agent[][] agents,int[][] env,float participationProb)
{        
   Agent curra; 
   for(int a=0;a<agents.length;a++)
    for(int b=0;b<agents[a].length;b++)
    {
     if( (curra=agents[a][b])!= null   // gdy agent jest żywy
     && curra.isAlive() 
     && participationProb>random(0,1)) // to może iść na protest
     {
       boolean OK=false;
       int na=a;
       int nb=agents[a].length/2;
       agents[a][b]=null; // znika z aktualnego miejsca
       do{                // print(na,nb,','); 
        if(agents[na][nb]==null
        && 
           env[na][nb]==Env_ROAD)
        {
          agents[na][nb]=curra;
          OK=true;
          println();
        }
        else
        {
          na+=random(1)<0.5?-1:1;
          if(na<0) na=0;
          if(agents.length<=na) na=agents.length-1;
          
          nb+=random(1)<0.5?-1:1;
          if(nb<0) nb=0;
          if(agents[na].length<=nb) nb=agents[na].length-1;
        }
       }while(!OK);
     }
    }
   println("PROTEST STARTED"); //<>//
}

/// @brief Najprostrze przemieszczanie agentów sterowane upływem czasu symulacji
void sheduleAgents(Agent[][] agents,int[][] env,int step)
{
   //lockdownness=0.20; // Ale lockdown nigdy nie jest kompletny (RACZEJ?)
   //lockdownstep=100;  // W którym kroku symulacji wprowadzamy lockdown
   float WP=(StepCounter<lockdownStep?dutifulness:lockdownness);
         
   Agent curra;                      //- println("Parzysty: ",step%2==0);
   for(int a=0;a<agents.length;a++)
    for(int b=0;b<agents[a].length;b++)
    {
     if( (curra=agents[a][b])!= null // Coś dalej do zrobienia gdy agent jest żywy
     && curra.isAlive()    )         // Tylko żywy może coś ze sobą zrobić np. do pracy
     {
       if(env[a][b]==Env_ROAD) // Jeśli jest na ulicy to wraca do domu!
       {
         agents[a][b]=null; // Z ulicy agent znika
         agents[curra.flatY][curra.flatX]=curra; // teleportuje się do domu
         continue;
       }
       
       if( curra.workX!=curra.flatX 
       && curra.workY!=curra.flatY)  // o ile nie pracuje w domu!!!
       {
         
         if(step % 2 == 0 ) // Jak 0 to z domu do pracy
         { 
           float workProbability=WP;
           if(curra.isInfected())
             workProbability*=1 - curra.infection.pSickLeave; //- println(workProbability);//DEBUG
  
           
           if(env[a][b]==Env_FLAT+1 // Tylko jak nadal jest w domu i zdecydował się iść
           && random(1)< workProbability
           )
           { 
             agents[a][b]=null; // A z domu znika
             agents[curra.workY][curra.workX]=curra; // Agent teleportuje się do pracy
           }
         }
         else // jak 1 to z pracy do domu
         {
           if(env[a][b]==Env_WORK+1) // Tylko jak nadal jest w pracy to z niej wraca
           { 
             agents[a][b]=null; // A z pracy znika
             agents[curra.flatY][curra.flatX]=curra; // Agent teleportuje się do domu
           }
         }
       }
     }
   } 
}

/// @brief Zmiany stanu agentów
void  agentsChange(Agent[][] agents)
{
  // Zapamiętujemy stan przed krokiem
  int befInfected=sumInfected;
  int befRecovered=sumRecovered;
  int befDeath=sumDeath;
  
  // Zmiany...
  int MC=agents.length*agents[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);    // `agents[a].lenght` na wypadek gdyby nam przyszło do głowy zrobić prostokąt
    int b=(int)random(0,agents[a].length); //- print(a,b,' ');
    
    if(agents[a][b]!= null )
    {
       // Jesli agent aktualny (centrum sąsiedztwa) zmarły lub zdrowy to nie zaraża wiec nic nie robimy
       if(!agents[a][b].isAlive() || agents[a][b].isSusceptible() || agents[a][b].isRecovered()) continue;
       
       // Wyliczenie lokalizacji sąsiadów
       int dw=(a+1) % agents.length;   
       int up=(agents.length+a-1) % agents.length;
       int right = (b+1) % agents[a].length;      
       int left  = (agents[a].length+b-1) % agents[a].length;

       if(agents[a][left]!=null
       && agents[a][left].isSusceptible() && random(1) < 1-agents[a][left].immunity )
         {agents[a][left].transferFrom(agents[a][b]); sumInfected++;}
        
       if(agents[a][right]!=null
       && agents[a][right].isSusceptible() && random(1) < 1-agents[a][right].immunity )
         {agents[a][right].transferFrom(agents[a][b]); sumInfected++;}
        
       if(agents[up][b]!=null
       && agents[up][b].isSusceptible() && random(1) < 1-agents[up][b].immunity )
         {agents[up][b].transferFrom(agents[a][b]); sumInfected++;}
        
       if(agents[dw][b]!=null
       && agents[dw][b].isSusceptible() && random(1) < 1-agents[dw][b].immunity ) 
         {agents[dw][b].transferFrom(agents[a][b]); sumInfected++;}
       
       if(agents[a][b].justDying()) // Albo tego dnia umiera
        { 
          sumDeath++;liveCount--;
          //agents[a][b]=null;        // Można by dawać mu stan "dead", ale...
          //agents[a][b].state=Death; // Ale to trzeba uwzglednić przy statystyce!
        }
        else
        {
          // Albo jest wyleczony
          if(agents[a][b].justHealed())
          {
              sumRecovered++;
          }
          //else //ALBO NADAL CIERPI!
        }
    }
  }
  // Zapamiętujemy zmiane w podstawowych statystykach jaka się dokonała w kroku symulacji
  deaths.append(sumDeath-befDeath);
  newcas.append(sumInfected-befInfected);
  cured.append(sumRecovered-befRecovered);
}

//*//////////////////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: BASIC INITIALISATION & EVERY STEP CHANGE
//*//////////////////////////////////////////////////////////////////////////////////////////////////////////
