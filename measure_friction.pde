import processing.serial.*;
import controlP5.*;
Serial myPort;

//コンソール描画用
public static final int consolX = 50;  //ボタンコンソール原点
public static final int consolY = 200; 
public static final int consolWidth = 400;  //ボタンコンソール領域サイズ
public static final int consolHeight = 400;
public static final int bWidth = 100;  //ボタン幅
public static final int bHeight = 60;  //ボタン高さ
ControlP5 cp5;
PFont bigF;  //フォント
color pushed  = color(0, 0, 20);  //押下時のボタン色

int motorSpeed = 0;  //モータ回転速度
String dataPrinter = "0";
String commandPrinter = "";

void setup(){
  //------------------------------シリアル準備
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 115200);
  myPort.clear();  //念のためバッファを空にする
  myPort.bufferUntil('\n');  //mbedから改行が来る度にserialEvent発動
  //------------------------------
  
  //------------------------------UI
  size(600, 600);
  PFont f = createFont("Arial", 20); //ボタンなどのfont
  bigF = f;
  cp5 = new ControlP5(this);
  //-----------------------------ボタン
  cp5.addButton("calibration")
     .setLabel("Calib")
     .setFont(f)
     .setPosition(consolX+0, consolY+0)
     .setSize(bWidth, bHeight);
     
   cp5.addButton("zeroOffset")
     .setLabel("ZERO")
     .setFont(f)
     .setPosition(consolX+bWidth+10, consolY+0)
     .setSize(bWidth, bHeight);
     
   cp5.addButton("measureStart")
     .setLabel("MEASURE")
     .setFont(f)
     .setPosition(consolX+0, consolY+bHeight+10)
     .setSize(bWidth, bHeight);
     
   cp5.addButton("measureStop")
     .setLabel("MESSTOP")
     .setFont(f)
     .setPosition(consolX+bWidth+10, consolY+bHeight+10)
     .setColorBackground(color(150,0,0))
     .setColorActive(color(255,50,50))
     .setColorForeground(color(200, 0, 0))
     .setSize(bWidth, bHeight);

  int  LCXE = consolX+bWidth+10;  //ロードセル操作系フィールド右下X
  int LCYE = consolY+bHeight+10; //ロードセル操作系フィールド右下Y
  
  cp5.addButton("moveLeft")
     .setLabel("LEFT")
     .setFont(f)
     .setPosition(consolX + bWidth + LCXE,consolY + 0)
     .setSize(bWidth, bHeight);
     
   cp5.addButton("moveRight")
     .setLabel("RIGHT")
     .setFont(f)
     .setPosition(consolX + bWidth*2 + LCXE + 10,consolY + 0)
     .setSize(bWidth, bHeight);
     
   cp5.addButton("motorStop")
     .setLabel("MOTSTOP")
     .setFont(f)
     .setPosition(consolX + bWidth*2 + LCXE + 10,consolY+bHeight+10)
      .setColorBackground(color(150,0,0))
     .setColorActive(color(255,50,50))
     .setColorForeground(color(200, 0, 0))
     .setSize(bWidth, bHeight);
     
   cp5.addTextfield("motorSpeed")
  .setCaptionLabel("speed")
  .setPosition(consolX + bWidth + LCXE,consolY+bHeight+10)
  .setSize(bWidth,bHeight)
  .setFont(f)
  .setInputFilter(ControlP5.INTEGER)
  .setFocus(true)
  //.setText(str(motorSpeed));
  .setAutoClear(false);
  //-----------------------------ボタンここまで
}

void draw(){
  background(0,0,0);
  textFont(bigF);
  text(dataPrinter, 300, 500);
   textFont(bigF);
  text(commandPrinter, 0, 500);
}

void keyPressed(){
    //myPort.write(key);
}


void serialEvent(Serial myPort){
  if(myPort.available()  > 0){
  String dataStr = myPort.readStringUntil('\n');  //改行まで読み込む
  //print(dataStr);
  if(dataStr != null){
    //行頭が'>'ならデータとして処理
    if(dataStr.charAt(0) == '>'){
      dataStr = trim(dataStr);  //念のため空白を除く
      String data[] = split(dataStr.substring(1), ",");  //先頭除いてカンマで分割
      dataPrinter = data[0] +" ,"+ data[1];
      //println(data[0] + "," + data[1]);
      //(WIP)CSV記録
      //(WIP)画面表示
    }
    else{
      commandPrinter = dataStr;
      //print(dataStr);
    }
  }
  }
}

//-----------ロードセル操作
void calibration(){
  myPort.write('c');
  //println("calibration");
  //(WIP)おもり設置指示ダイアログ
  //(WIP)気が向いたらおもりの重さを指定できるようにする
}

void measureStart(){
  //(WIP)csv記録開始のコードを書く
  myPort.write('s');
}

void measureStop(){
  //(WIP)csv記録終了処理
  myPort.write('e');
}

//ゼロ点オフセット
void zeroOffset(){ 
  myPort.write('z');
}

//-----------モータ操作
void moveLeft(){
  myPort.write('l');
}

void moveRight(){
  myPort.write('r');
}

void motorStop(){
  myPort.write('q');
}

public void motorSpeed(String value){
  myPort.write('m');
  //println("speed " + value);
  myPort.write(value + ";");
  //(WIP)テキストフィールドから数値を拾って送るコードを書く
  //数値を送る時うしろに';'をつける
}
