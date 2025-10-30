//+------------------------------------------------------------------+
//|                                                      MyBot.mq5  |
//|                                                                |
//+------------------------------------------------------------------+
#property strict

#include <RiskManager.mqh>
#include <SMC_Logic.mqh>
#include <TimeFilter.mqh>

input string SettingsFile = "settings.ini";
double LotSize = 0.1;
int Slippage = 3;
int MagicNumber = 123456;

bool TradeAllowed = false;

//+------------------------------------------------------------------+
int OnInit()
{
   Print("Bot initialization started...");
   TradeAllowed = LoadTradingTime(SettingsFile);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnTick()
{
   if(!TradeAllowed)
      return;

   if(!IsNewBar())
      return;

   if(!IsSMCSignal())
      return;

   double riskPercent = GetRiskPercent(SettingsFile);
   double lot = CalculateLotSize(riskPercent);

   if(lot <= 0)
      return;

   int direction = GetTradeDirection();

   if(direction == 1)
      OpenBuy(lot);
   else if(direction == -1)
      OpenSell(lot);
}

//+------------------------------------------------------------------+
void OpenBuy(double lot)
{
   double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double sl = price - 100 * _Point;
   double tp = price + 200 * _Point;

   trade.Buy(lot, _Symbol, price, Slippage, sl, tp, "Buy SMC", MagicNumber);
}

void OpenSell(double lot)
{
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl = price + 100 * _Point;
   double tp = price - 200 * _Point;

   trade.Sell(lot, _Symbol, price, Slippage, sl, tp, "Sell SMC", MagicNumber);
}
