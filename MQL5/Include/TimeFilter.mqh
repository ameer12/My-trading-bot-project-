//+------------------------------------------------------------------+
//|                                                  TimeFilter.mqh  |
//|       Filters trading hours and blocks execution during news     |
//+------------------------------------------------------------------+
#property strict

bool LoadTradingTime(string settingsFile)
{
   int startHour = 9;
   int endHour = 17;

   int handle = FileOpen(settingsFile, FILE_READ | FILE_ANSI);
   if(handle != INVALID_HANDLE)
   {
      while(!FileIsEnding(handle))
      {
         string line = FileReadString(handle);
         if(StringFind(line, "StartHour=") == 0)
            startHour = (int)StrToInteger(StringSubstr(line, StringLen("StartHour=")));
         if(StringFind(line, "EndHour=") == 0)
            endHour = (int)StrToInteger(StringSubstr(line, StringLen("EndHour=")));
      }
      FileClose(handle);
   }

   datetime now = TimeCurrent();
   int hour = TimeHour(now);

   if(hour >= startHour && hour < endHour && !IsNewsTime())
      return true;

   return false;
}

bool IsNewsTime()
{
   // Manual news block (can be extended to use external API)
   int blockStartHour = 13;
   int blockStartMinute = 55;
   int blockEndHour = 14;
   int blockEndMinute = 15;

   datetime now = TimeCurrent();
   int hour = TimeHour(now);
   int minute = TimeMinute(now);

   if((hour > blockStartHour || (hour == blockStartHour && minute >= blockStartMinute)) &&
      (hour < blockEndHour || (hour == blockEndHour && minute <= blockEndMinute)))
   {
      return true;
   }

   return false;
}
