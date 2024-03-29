/// Graph of changes over time
/// (Wykres zmian w czasie)
//*/////////////////////////////

/// @brief Funkcja rysuje przebieg jednej zmiennej.
/// \param height - to maksymalna wysokość wykresu.
/// \param logarithm - oznacza że dane zostaną zlogarytmowane.
void timeline(FloatList data, float startX, float startY, float height,boolean logarithm)
{
  float   max=-Float.MAX_VALUE; // Wartość maksimum.
  int     whmax=-1;             // Gdzie jest maksimum?
  float   min=Float.MAX_VALUE;  // Wartość minimum.
  int     whmin=-1;             // Gdzie jest minimum?
  int     N=data.size();        // Ile pomiarów?
  float  lenght=width-startX;   // Ile miejsca na wykres?
  
  // Szukanie minimum i maksimum
  for(int t=0;t<N;t++)
  {
    float val=data.get(t);
    if(Float.isNaN(val)) continue; // Pomija nie liczby 
    if(val>max) { max=val; whmax=t;}
    if(val<min) { min=val; whmin=t;}
  }
  
  if(logarithm)
  {
    max=(float)Math.log10(max+1); // +1 to takie oszustwo 
    min=(float)Math.log10(min+1); // żeby 0 nie wywalało obliczeń
  }
  
  if(min==max) max++;
  
  // Właściwe rysowanie
  float wid=lenght/N;             //- println(width,N,wid,min,max);
  float oldy=-Float.MIN_VALUE;
  for(int t=0;t<N;t++)
  {
    float val=data.get(t);
    
    if(Float.isNaN(val)) continue; // Pomija nie liczby! 
    
    if(logarithm)
      val=map((float)Math.log10(val+1),min,max,0,height);    
    else 
      val=map(val,min,max,0,height);
    
    float x=t*wid;
    if(oldy!=-Float.MIN_VALUE)
    {
      line (startX+x-wid,startY-oldy,startX+x,startY-val); //- println(wid,x-wid,oldy,x,val);
    }
    else
      point(startX+x,startY-val);                          //- println(startX+x,startY-val);
    
    oldy=val;
    
    if(t==whmax || t==whmin)
    {
      textAlign(LEFT,BOTTOM);
      String out=""+data.get(t);
      text(out,startX,startY-val);   // Na osi X
      text(out,startX+x,startY-val); // Przy danych
    }
  }
}

/// @brief Gdy trzeba narysować historię kilku zmiennych.
/// @details To jest wersją bardzo prymitywną, ale działa :-D
/// @note!:  wspólna skala!!!
void timeline(FloatList data_a, FloatList data_b, FloatList data_c,float startX, float startY, float height,boolean logarithm,color color_a,color color_b,color color_c)
{
  float   max=-Float.MAX_VALUE;  // Tu będzie prawdziwa wartość
  float   gmax=0;                // A tu przeliczona dla grafiki
  float   min=Float.MAX_VALUE;   // J.w.
  float   gmin=0;                // Analogicznie j.w.
  int     N1=data_a.size(),N2=data_b.size(),N3=data_c.size(); //Ile pomiarów?
  float   lenght=width-startX;   // Ile miejsca na wykres?
  
  // Szukanie minimum i maksimum
  for(int t=0;t<N1;t++)
  {
    float val=data_a.get(t);
    if(Float.isNaN(val)) continue; // Pomija nie liczby 
    if(val>max) max=val;
    if(val<min) min=val;
  }
  
  for(int t=0;t<N2;t++)
  {
    float val=data_b.get(t);
    if(Float.isNaN(val)) continue; // Pomija nie liczby 
    if(val>max) max=val;
    if(val<min) min=val;
  }
  
  for(int t=0;t<N3;t++)
  {
    float val=data_c.get(t);
    if(Float.isNaN(val)) continue; // Pomija nie liczby 
    if(val>max) max=val; 
    if(val<min) min=val;
  }
  
  if(logarithm)
  {
    gmax=(float)Math.log10(max+1); // +1 to takie oszustwo 
    gmin=(float)Math.log10(min+1); // żeby 0 nie wywalało obliczeń
  }
  else
  {
    gmax=max;
    gmin=min;
  }
  
  if(gmin==gmax) gmax++;
  
  // Właściwe rysowanie
  float wid=lenght/max(N1,N2,N3);  // Najdłuższy decyduje
  float oldy=-Float.MIN_VALUE;
  stroke(color_a);//fill(color_a);
  for(int t=0;t<N1;t++)
  {
    float val=data_a.get(t);
    if(Float.isNaN(val)) continue; // Pomija nie liczby 
    
    if(logarithm)
      val=map((float)Math.log10(val+1),gmin,gmax,0,height);    
    else 
      val=map(val,gmin,gmax,0,height);
    
    float x=t*wid;
    if(oldy!=-Float.MIN_VALUE)
      line (startX+x-wid,startY-oldy,startX+x,startY-val);
    else
      point(startX+x,startY-val);
    
    oldy=val;
  }

  oldy=-Float.MIN_VALUE;
  stroke(color_b); //fill(color_b);
  for(int t=0;t<N2;t++)
  {
    float val=data_b.get(t);
    if(Float.isNaN(val)) continue; // Pomija nie liczby 
    
    if(logarithm)
      val=map((float)Math.log10(val+1),gmin,gmax,0,height);    
    else 
      val=map(val,gmin,gmax,0,height);
    
    float x=t*wid;
    if(oldy!=-Float.MIN_VALUE)
      dottedLine(startX+x-wid,startY-oldy,startX+x,startY-val,2);
    else
      point(startX+x,startY-val);
    
    oldy=val;
  }
  
  oldy=-Float.MIN_VALUE;
  stroke(color_c); //- fill(color_c);
  for(int t=0;t<N3;t++)
  {
    float val=data_c.get(t);
    if(Float.isNaN(val)) continue; // Pomija nie liczby 
    
    if(logarithm)
      val=map((float)Math.log10(val+1),gmin,gmax,0,height);    
    else 
      val=map(val,gmin,gmax,0,height);
    
    float x=t*wid;
    if(oldy!=-Float.MIN_VALUE)
      dottedLine(startX+x-wid,startY-oldy,startX+x,startY-val,3);
    else
      point(startX+x,startY-val);
    
    oldy=val;
  }
  
  // Min i max są wspólne.
  textAlign(LEFT,BOTTOM);
  text(""+max,startX,startY-height); // Na osi X
  text(""+min,startX,startY);        // Na osi X
}

/// @brief Rysowanie linii kropkowanej.
/// @note  wg.: https://processing.org/discourse/beta/num_1219255354.html
void dottedLine(float x1, float y1, float x2, float y2, float steps)
{
 for(int i=0; i<=steps; i++) {
   float x = lerp(x1, x2, i/steps); // funkcja `lerp()` jest bardzo użyteczna :-)
   float y = lerp(y1, y2, i/steps);
   //noStroke();ellipse(x, y,2,2);  // Używanie elipsy zamiast punktu nie jest zbyt wydajne ;-)
   point(x,y);
 }
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - City of Plague
//*/////////////////////////////////////////////////////////////////////////////////////////
