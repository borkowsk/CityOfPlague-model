// Simulation have to collect and write down statistics from every step
///////////////////////////////////////////////////////////////////////////////////////
PrintWriter outstat;

void initializeStats()
{
  String FileName=modelName+="_"+year()+'.'+nf(month(),2)+'.'+nf(day(),2)+'.'+nf(hour(),2)+'.'+nf(minute(),2)+'.'+nf(second(),2)+'.'+millis();
  outstat=createWriter(FileName+".out");
  outstat.println( "ST:\tStepCounter\tliveCount"
                           +"\tZ\tsumInfected\tnewcases"
                           +"\tW\tsumRecovered\tcured"
                           +"\tU\tsumDeath\tdeaths"
                           +"\t");
}

void doStatistics(World world)
{
  doStatisticsOnAgents(world.agents);
}

void doStatisticsOnAgents(Agent[][] agents)
{  
  Agent curra;
  liveCount=0;
  
  for(int a=0;a<agents.length;a++)
   for(int b=0;b<agents[a].length;b++)
    if( (curra=agents[a][b]) != null )
    {     
      //.....THIS PART IS FOR YOU!
      
      liveCount++;
    }
  
   if(outstat!=null)
      outstat.println( "ST:\t"+StepCounter+"\t"+liveCount
                           +"\tZ\t"+sumInfected+"\t"+(newcas.size()>1?newcas.get(newcas.size()-1):0)
                           +"\tW\t"+sumRecovered+"\t"+(cured.size()>1?cured.get(cured.size()-1):0)
                           +"\tU\t"+sumDeath+"\t"+(deaths.size()>1?deaths.get(deaths.size()-1):0)
                           +"\t");
   
   //outstat should be closed in exit() --> see Exit.pde
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: STATISTICS LOG TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
