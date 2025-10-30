//+------------------------------------------------------------------+
//|                                                  RiskManager.mqh |
//|             Calculates lot size based on risk percentage         |
//+------------------------------------------------------------------+
#property strict

double GetRiskPercent(string settingsFile)
{
   double risk = 1.0; // default risk percentage

   int handle = FileOpen(settingsFile, FILE_READ | FILE_ANSI);
   if(handle != INVALID_HANDLE)
   {
      while(!FileIsEnding(handle))
      {
         string line = FileReadString(handle);
         if(StringFind(line, "RiskPercent=") == 0)
         {
            string value = StringSubstr(line, StringLen("RiskPercent="));
            risk = StrToDouble(value);
            break;
         }
      }
      FileClose(handle);
   }

   return risk;
}

double CalculateLotSize(double riskPercent)
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = balance * (riskPercent / 100.0);

   double tickValue = MarketInfo(_Symbol, MODE_TICKVALUE);
   double stopLossPoints = 100; // default SL distance
   double lot = riskAmount / (stopLossPoints * tickValue);

   lot = NormalizeDouble(lot, 2);
   return lot;
}
