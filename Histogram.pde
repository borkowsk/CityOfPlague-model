/// Bardzo prosty histogram agentów wg jednej właściwości
//*///////////////////////////////////////////////////////////////////
int Max=0; ///< Max wspólny dla całej symulacji

/// Tablica frekwencji odporności wraz z rysowaniem.
/// Funkcja przechodzi po wszystkich agentach i zlicza wg. klas odpornosci.
/// Potem rysuje w zadanym miejsu histogram o maksymalnej wysokości 'hight'
void histogram(Agent[][] agents,float startx,float starty,float hight)
{
  int NumOfBaskets=100;
  int Basket[]=new int[NumOfBaskets+1];
  int N=0; //Licznik żywych
  //int Max=0; //Albo Max resetowany dla każdego kroku
  Agent curra; //Pomocniczy uchwyt agenta
  
  // Zliczanie 
  for(int a=0;a<agents.length;a++)
   for(int b=0;b<agents[a].length;b++)
   {
    // ZLICZANIE AGENTA
    if( (curra=agents[a][b]) != null 
        && curra.isAlive() //Nie doliczamy zmarłych do tej statystyki
    )
    {
      N++;//Żywy
      int cl=round(curra.immunity*NumOfBaskets); //Z odporniością w klasie "cl"
      Basket[cl]++; //Doliczamy go
      if(Basket[cl]>Max) Max=Basket[cl]; //Sprawdzamy czy nie urosło "Max"
    }
   }
   
   // Rysowanie
   stroke(random(255),random(255),random(255));
   for(int i=0;i<=NumOfBaskets;i++)
   {
     float val=Basket[i];
     val/=Max;val*=hight;
     //map(val,0,Max,0,hight);
     line(startx+i,starty,startx+i,starty-val);
   }
   
   // Opis
   fill(random(255),random(255),random(255));
   text("N:"+N+"\nMax:"+Max,startx+NumOfBaskets,starty);
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - City of Plague
//*/////////////////////////////////////////////////////////////////////////////////////////
