//+------------------------------------------------------------------+
//|                                                  SMC_Logic.mqh   |
//|     SMC/ICT logic: BOS, CHoCH, and directional bias detection    |
//+------------------------------------------------------------------+
#property strict

#define LOOKBACK_BARS 50

bool IsSMCSignal()
{
   int bosCount = 0;
   int chochCount = 0;

   for(int i = 1; i < LOOKBACK_BARS - 1; i++)
   {
      double prevHigh = iHigh(_Symbol, PERIOD_M15, i + 1);
      double currHigh = iHigh(_Symbol, PERIOD_M15, i);
      double prevLow = iLow(_Symbol, PERIOD_M15, i + 1);
      double currLow = iLow(_Symbol, PERIOD_M15, i);

      if(currHigh > prevHigh)
         bosCount++;
      if(currLow < prevLow)
         chochCount++;
   }

   // Signal if structural shift is detected
   if(bosCount >= 2 || chochCount >= 2)
      return true;

   return false;
}

int GetTradeDirection()
{
   double lastHigh = iHigh(_Symbol, PERIOD_M15, 1);
   double lastLow = iLow(_Symbol, PERIOD_M15, 1);
   double close = iClose(_Symbol, PERIOD_M15, 0);

   if(close > lastHigh)
      return 1; // Buy
   else if(close < lastLow)
      return -1; // Sell

   return 0; // No clear direction
}
