#include <Trade\Trade.mqh>
CTrade trade;
double lowest_price;
#property strict
void OnInit() {
   int lookback = 50;
   double lowArray[];
   CopyLow(_Symbol, PERIOD_CURRENT, 0, lookback, lowArray);
   int lowest_index = ArrayMinimum(lowArray);
   if(lowest_index == -1) {
      Print("Error: Not enough bars to find the lowest");
      return;
   }
   lowest_price = iLow(_Symbol, PERIOD_CURRENT, lowest_index);
//printing the output
   Print("The lowest price recorded for ", lookback, "candles is ", lowest_price);
   Print("Bar Index: ", lowest_index);
}
void OnTick() {
   double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double pips_difference = (current_price - lowest_price) / _Point / 10.0;
   if(pips_difference > 20 && pips_difference < 40) {
      Print("Print moved between 20 and 40 pips above the lowest point.");
   }
   else if (MathAbs(current_price - lowest_price) < (_Point * 5)) {//used for checking whether the price returned to starting point
      //Set stop loss 20 pips above entry price
      double stop_loss = current_price + 20 * _Point * 10;
      //Set take proft 20 pips below entry price
      double take_profit = current_price - 20 * _Point * 10;
      if(trade.Sell(0.1)) {
         Print("Sell order opened at price : ", current_price);
         Print("Stop Loss set at : ", stop_loss);
         Print("Take Profit set at : ", take_profit);
      } else {
         Print("Failed to open sell order. Error: ", GetLastError());
      }
   }
}