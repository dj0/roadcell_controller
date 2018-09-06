import processing.serial.*;
import controlP5.*;
Serial myPort;

void setup(){
  //------------------------------シリアル準備
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[6], 115200);
  myPort.clear();  //念のためバッファを空にする
  myPort.bufferUntil('\n');  //mbedから改行が来る度にserialEvent発動
  //------------------------------
}

void draw(){
  background(0,0,0);
}

void keyPressed(){
    myPort.write(key);
}


void serialEvent(Serial myPort){
  String dataStr = myPort.readStringUntil('\n');  //改行まで読み込む
  if(dataStr != null){
    //行頭が'>'ならデータとして処理
    if(dataStr.charAt(0) == '>'){
      dataStr = trim(dataStr);  //念のため空白を除く
      String data[] = split(dataStr.substring(1), ",");  //先頭除いてカンマで分割
      //(WIP)CSV記録
      //(WIP)画面表示
    }
    else{
      print(dataStr);
    }
  }
}

//-----------ロードセル操作
void calibration(){
  myPort.write('c');
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

void motorSpeed(String value){
  myPort.write('m');
  //(WIP)テキストフィールドから数値を拾って送るコードを書く
}
