//マジックナンバーの定義
#define MAGIC  2020

//パラメーターの設定//
extern int Slip = 10;                 //許容スリッページ数
extern string Comments = "";          //コメント
extern double Lots = 0.01;            //取引ロット数
extern int TP = 500;                  //利確ポイント
extern int Max_Position = 20;         //ポジション数のMAX
extern double entry_Interval = 250;     //エントリー間隔

//変数の設定//
int Ticket_EURUSD_S = 0; //売り注文の結果をキャッチする変数
int Ticket_NZDUSD_L = 0; //買い注文の結果をキャッチする変数
//int Ticket_CADJPY_L = 0; //買い注文の結果をキャッチする変数
int Ticket_AUDJPY_L = 0; //買い注文の結果をキャッチする変数

double LC_Line_EURUSD = 1.70442;  //EURUSDのロスカットライン
double EURUSD_Harf = 1.31922;  //EURUSDの中央値

double LC_Line_NZDUSD = 0.38979;  //NZDUSDのロスカットライン
double NZDUSD_Harf = 0.68694;  //NZDUSDの中央値

/*
double LC_Line_CADJPY = 58.114;  //CADJPYのロスカットライン
double CADJPY_Harf = 96.957;  //CADJPYの中央値
*/

double LC_Line_AUDJPY = 44.781;  //AUDJPYのロスカットライン
double AUDJPY_Harf = 81.377;  //AUDJPYの中央値

/*
int Exit_L = 0;   //買いポジションの決済注文の結果をキャッチする変数
int Exit_S = 0;   //売りポジションの決済注文の結果をキャッチする変数
*/

double entry_Point_EURUSD = 0;
double entry_Point_NZDUSD = 0;
//double entry_Point_CADJPY = 0;
double entry_Point_AUDJPY = 0;

int start()
  {
      if(IsTradeAllowed() == false){return(0);}
      
      //バー始値制限処理
      static int BarsBefore = 0;             //前回のティック更新時のバーの総数
      int BarsNow = Bars;                    //現在のバーの総数
      int BarsCheck = BarsNow - BarsBefore;  //上の差
      
      /*
      
      //売りポジションの利益確定
      OrderSelect(Ticket_S,SELECT_BY_TICKET); 

      if(   OrderOpenPrice() - TP * Point > Ask
         && BarsCheck == 1
         && ( Ticket_S != 0 && Ticket_S != -1 ))
      {     
         Exit_S = OrderClose(Ticket_S,Lots,Ask,Slip,Blue);
         if( Exit_S ==1 ) {} 
      } 
      
      //売りポジションの損失確定
      OrderSelect(Ticket_S,SELECT_BY_TICKET); 

      if(   LC_Line_EURUSD <= Ask
         && ( Ticket_S != 0 && Ticket_S != -1 ))
      {     
         Exit_S = OrderClose(Ticket_S,Lots,Ask,Slip,Blue);
         if( Exit_S ==1 ) {}
      }
      
      */
      
      if(OrdersTotal() == 0){
         entry_Point_EURUSD = 0;
         entry_Point_NZDUSD = NZDUSD_Harf;
         //entry_Point_CADJPY = CADJPY_Harf;
         entry_Point_AUDJPY = AUDJPY_Harf;
      }
      
      //EURUSD...エントリー/決済
      
      if(   BarsCheck == 1
         && Close[1] > EURUSD_Harf
         && Close[1] < LC_Line_EURUSD
         && MarketInfo("EURUSD.std",MODE_SPREAD) < 16   //EURUSDの場合
         && ( Ticket_EURUSD_S >= 0 || Ticket_EURUSD_S == -1 )
         && OrdersTotal() < Max_Position 
         && Close[1] > entry_Point_EURUSD)
      {  
      
         //OrderSend関数の返り値：注文番号
         Ticket_EURUSD_S = OrderSend("EURUSD.std",OP_SELL,Lots,Bid,Slip,LC_Line_EURUSD,Bid - TP * Point,Comments,MAGIC,0,Blue);
         
         entry_Point_EURUSD = Bid + entry_Interval * Point;
       
      } 
      
      //NZDUSD...エントリー/決済
      
      if(   BarsCheck == 1
         && Close[1] < NZDUSD_Harf
         && Close[1] > LC_Line_NZDUSD
         && MarketInfo("NZDUSD.std",MODE_SPREAD) < 28   //NZDUSDの場合
         && ( Ticket_NZDUSD_L >= 0 || Ticket_NZDUSD_L == -1 )
         && OrdersTotal() < Max_Position 
         && Close[1] < entry_Point_NZDUSD)
      {  
      
         //OrderSend関数の返り値：注文番号
         Ticket_NZDUSD_L = OrderSend("NZDUSD.std",OP_BUY,Lots,Ask,Slip,LC_Line_NZDUSD,Ask + TP * Point,Comments,MAGIC,0,Red);
         
         entry_Point_NZDUSD = Ask - entry_Interval * Point;
       
      } 
      
      /*
      //CADJPY...エントリー/決済
      
      if(   BarsCheck == 1
         && Close[1] < CADJPY_Harf
         && Close[1] > LC_Line_CADJPY
         && MarketInfo("CADJPY.std",MODE_SPREAD) < 31   //CADJPYの場合
         && ( Ticket_CADJPY_L >= 0 || Ticket_CADJPY_L == -1 )
         && OrdersTotal() < Max_Position 
         && Close[1] < entry_Point_CADJPY)
      {  
      
         //OrderSend関数の返り値：注文番号
         Ticket_CADJPY_L = OrderSend("CADJPY.std",OP_BUY,Lots,Ask,Slip,LC_Line_CADJPY,Ask + TP * Point,Comments,MAGIC,0,Red);
         
         entry_Point_CADJPY = Ask - entry_Interval * Point;
       
      }   
      */  
      
      //AUDJPY...エントリー/決済
      
      if(   BarsCheck == 1
         && Close[1] < AUDJPY_Harf
         && Close[1] > LC_Line_AUDJPY
         && MarketInfo("AUDJPY.std",MODE_SPREAD) < 30  //AUDJPYの場合
         && ( Ticket_AUDJPY_L >= 0 || Ticket_AUDJPY_L == -1 )
         && OrdersTotal() < Max_Position 
         && Close[1] < entry_Point_AUDJPY)
      {  
      
         //OrderSend関数の返り値：注文番号
         Ticket_AUDJPY_L = OrderSend("AUDJPY.std",OP_BUY,Lots,Ask,Slip,LC_Line_AUDJPY,Ask + TP * Point,Comments,MAGIC,0,Red);
         
         entry_Point_AUDJPY = Ask - entry_Interval * Point;
       
      }    
      //Print("現在のポジション数は"+OrdersTotal()+"です");
      Comment("現在のポジション数は"+OrdersTotal()+"です");
      
      //今回のティック更新時のバーの総数の記憶
      BarsBefore = BarsNow;
    
    return(0);
    
  }

