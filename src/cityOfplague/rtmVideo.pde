/// Module for recording video from the simulation.
/// (Moduł do zapisu wideo z symulacji.) 
//*////////////////////////////////////////////////////
// To musi być w `setup()` żeby było zapisane video:
//
//  initVideoExport(this,FileName,int Frames)); // Klasa VideoExport musi mieć dostep do obiektu aplikacji Processingu
//                                              // Najlepiej wywołać na końcu `setup()`. Okno musi mieć PARZYSTE rozmiary
//  
// a to dla każdej klatki
//
//  NextVideoFrame(); // Video frame
//
//na koniec zaś:
//
//  CloseVideo()
//
import com.hamoid.*; // Oraz importujemy niezbędną biblioteką zawierającą klasę VideoExport

VideoExport videoExport; // KLASA z biblioteki "VideoExport" Abe Pazosa - trzeba zainstalować
                         // "http://funprogramming.org/VideoExport-for-Processing/examples/basic/basic.pde"
                         // Oraz zainstalować program "ffmpeg" żeby działało.
int videoFramesFreq=0;           

void initVideoExport(processing.core.PApplet parent, String Name,int Frames)
{
  videoFramesFreq=Frames;
  videoExport = new VideoExport(parent,Name); // Klasa VideoExport musi mieć dostep do obiektu aplikacji Processingu
  videoExport.setFrameRate(Frames);           // Nie za szybko!
  videoExport.startMovie();
  text(Name,1,20);
  videoExportEnabled=true;
}
                        
void FirstVideoFrame()
{
  if(videoExportEnabled)
  {  
     fill(0,128,255);textAlign(LEFT,BOTTOM);
     text("2020 (c) W.Borkowski @ ISS University of Warsaw",1,height); 
     //text(videoExport.VERSION,width/2,height);
     delay(200);
     for(int i=0;i<videoFramesFreq;i++) // Musi trwać sekundę czy coś...
       videoExport.saveFrame();         // Video frame
  }
}

void NextVideoFrame()
{  
   if(videoExportEnabled)
     videoExport.saveFrame(); // Video frame
}
                     
void CloseVideo() ///< To wołamy gdy chcemy zamknąć.
{
  if(videoExport!=null)
  { 
   fill(0);textAlign(LEFT,BOTTOM);
   // powinno być jakieś "force screen update", ale nie znalazłem
   for(int i=0;i<videoFramesFreq;i++) // Musi trwać sekundę czy coś...
   {
       fill(random(255),random(255),random(255));
       text("2020 (c) W.Borkowski @ Institute for Social Studies, University of Warsaw",1,height);
       videoExport.saveFrame(); //Video frame
       print("*"); //DEBUG
   }
   videoExport.saveFrame();  // Video frame - LAST
   videoExport.endMovie();   // Koniec filma
   videoExportEnabled=false;
   videoExport=null;
  }
}

static boolean     videoExportEnabled=false; ///< init will set up it for true

//*/////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - MOVIE MAKER 
//*/////////////////////////////////////////////////////////////////////////////////////////
