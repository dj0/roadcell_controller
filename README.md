# roadcell_controller
## 概要
適当。
ロードセルとサーボモータを用いた摩擦力計測装置の操作用GUI Processingコード。
mbed側のコードは https://os.mbed.com/users/yamaotoko/code/friction_measure/
## 操作説明
### 接続
`printArray(Serial.list())`で今繋げるデバイスのリストがコンソールに出る。
`myPort = new Serial(this, Serial.list()[1], 115200);`
Serial[1]の部分を自分が繋ぎたいデバイスの配列番号に変えとく。ttyじゃなくてcuのほう。
### 操作手順
1. まずはじめにキャリブレーションする。
1. キャリブレーション後、値が0付近になってなかったらZEROオフセット。
1. モータの移動速度を入力
1. MEASUREで計測開始。この時csvファイルが生成される。
1. MESSTOPで計測終了。
1. 再度計測したい場合は、LEFT/RIGHTで計測台の位置を適当なところに戻す

### ボタン
#### CALIB
キャリブレーション。これを押す前にロードセルから一切の物体を取っ払っておく。
押して、place the weight and push any button　と出たらロードセルにおもりをのせる。
デフォルトでは50gのおもりを載せることになっている。違うおもりの値でキャリブレーションしたい場合、mbedコードの
~~~
case 'c':   //キャリブレーション
            calibrate(50.0);
~~~
の50.0のとこを使いたいおもりの値に直すこと。もしくはprocessingからでも変更できるように改良してほしい。

#### ZERO
ゼロオフセット。今の値をゼロ値にオフセットする。

#### MEASURE
計測。モータが動き出す。またcsvを吐き出す準備をする。

#### MESSTOP
計測終了。csvを吐き出す。

#### LEFT/RIGHT
モータを左か右に移動

#### SPEED
モータの回転速度。テキストフィールドに数値を入力し、Enterを入力すると適用される。
単位は約0.114rpm（ http://www.besttechnology.co.jp/modules/knowledge/?Dynamixel%20MX-28 ）
一応負値がきてもなんとかなるようにしてる（気がする）

#### MOTSTOP
モータの停止。

## CSVについて
friction_MM_DD_HH_mm_ss.csv　という名前でプログラムがあるフォルダに多分吐き出される。
出力名を変えたい場合は
`output = createWriter("friction_"+ nf(month(), 2) + nf(day(), 2) +"_" + nf(hour(), 2) + nf(minute(), 2) + "_" + nf(second(), 2) + ".csv");   // データ書き込み用ファイルを生成`
を適当に変える。

## その他
暇になったら追加する