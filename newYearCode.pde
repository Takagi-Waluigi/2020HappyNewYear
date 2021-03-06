
import themidibus.*; //デバック用MIDIコンのライブラリの宣言
MidiBus myBus;

PImage qr;
PImage code;
PImage img;


int num1 = ###;
int num2 = ###;
int num3 = #;
int num4 = #;
int num5 = #;

int label = 0;
float theta = 0;
int offset = 12;
PFont main, sub;
int col, col2, col3;


void setup() {
  size(600, 888);
 
  colorMode(HSB, 360, 100, 100);

  myBus = new MidiBus(this, 0, 1);
  qr = loadImage("QR.png");
  code = loadImage("code.png");
  main = loadFont("AvenirNextCondensed-UltraLight-90.vlw");
  sub = loadFont("Avenir-BookOblique-10.vlw");
}

void draw() {

  background(#FFFFFF);
  randomSeed(num2);
  translate(width/2, height/2);
  
  //各関数の呼び出しを行います
  grid();      //背景のグリッド
  colCalc();   //色のパターンの計算
  words();     //文字
  wavePoints();//背景の波
  circles();   //円
  

  //QRコードの画像を添付
  image(qr, -width/2+10, height/2-160, 150, 150);
  
　//Sキーで時刻をファイル名にして保存
  if (key == 's' || key == 'S') {
    int mo = month();
    int d = day();
    int h = hour();
    int m = minute();
    save("image" + mo + d + h + m +".jpg");
    exit();
  }
}

//色に関する計算
void colCalc() {
　//num4を基準にしてmap関数で0〜360に変換した後前後120ずつ数字をずらします
  col = int(map(num4, 1, 99, 0, 360));
  col2 = col + 120;
  col3 = col - 120;

  if (col2 >360) { 
    col2 = col2 - 360;
  }
  if (col2 < 0) { 
    col2 = 360 - col2;
  }
  if (col3 >360) { 
    col3 = col3 -360;
  }
  if (col2 < 0) { 
    col3 = 360 - col3;
  }
}

//波の描画
void wavePoints() {
  strokeWeight(0.8);
  for (int i=0; i<num1; i+=num5) {
    int colRand = int(random(3));
    float slip = 2*PI* norm(i, 0, num1);
    switch(colRand) {
    case 0:
      stroke(col, 100, 100);
      break;
    case 1:
      stroke(col2, 100, 100);
      break;
    case 2:
      stroke(col3, 100, 100);
      break;
    }
    if (i % num3 == 0) {
      //line(-width/2, i, width/2, i);
      for (int x=-width/2; x<width/2; x++) {
        float y = cos(lerp(x, 0, PI)-slip)*offset+i;
        point(x, y);
      }
    } else {
      //line(i, -height/2, i, height/2);
      for (int y=-height/2; y<height/2; y++) {
        float x = cos(lerp(y, 0, PI)-slip)*offset+i;
        point(x, y);
      }
    }
  }
}

//円の描画
void circles() {
  beginShape(LINES);
  for (int i=0; i<num3*num5; i++) {
    float x = random(-120, 120);
    float y = random(-120, 120);
    float r = random(20, 100);
    noStroke();
    int colRand = int(random(3));
    ellipseMode(CENTER);
    strokeWeight(0.5);
    switch(colRand) {
    case 0:
      fill(col, 70, 100, 150);
      ellipse(x, y, r, r);
      stroke(col3, 70, 100, 200);
      vertex(x, y);
      break;
    case 1:
      fill(col2, 70, 100, 150);
      ellipse(x, y, r, r);
      stroke(col, 70, 100, 200);
      vertex(x, y);
      break;
    case 2:
      fill(col3, 70, 100, 150);
      ellipse(x, y, r, r);
      stroke(col2, 70, 100, 200);
      vertex(x, y);
      break;
    }
  }
  endShape(CLOSE);
}

//グリッドの描画
void grid(){
  for(int x=-width/2; x < width/2; x+=30){
    for(int y=-height/2; y < height/2; y+=30){
      stroke(0, 50);
      line(x-5, y, x+5, y);
      line(x, y-5, x, y+5);
      
    }
  }
}

//文字の描画
void words() {
  fill(0);
  textFont(sub);
  textAlign(LEFT);
  text("Happy New Year!!\nYour adress numbers appear as shapes, patterns, colors, and so on...", -width/2+20, -height/2+40);
  text("###", -width/2+200, height/2-62);
  fill(0, 100);
  text("int_num1=" + num1 + ";\n" + 
       "int_num2=" + num2 + ";\n" + 
       "int_num3=" + num3 + ";\n" + 
       "int_num4=" + num4 + ";\n" +
       "int_num5=" + num5 + ";\n" , -width/2+20, -height/2+80);
  textAlign(CENTER);
  fill(0);
  text("source code is here.", -width/2+85, height/2-162);

  textFont(main);
  textAlign(CENTER);
  fill(0,100);
  text("2020", 0, -200);
  
}

//MIDIコントローラに関する関数
void controllerChange(int channel, int number, int value) {
  if (number == 1) {
    num1 = int(map(value, 0, 127, 0, 300));
  }
  if (number == 2) {
    num2 =int(map(value, 0, 127, 0, 999));
  }
  if (number == 3) {
    num3 = int(map(value, 0, 127, 1, 9));
  }
  if (number == 4) {
    num4 = int(map(value, 0, 127, 1, 99));
  }
  if (number == 5) {
    num5 = int(map(value, 0, 127, 1, 9));
  }
  println("channel:"+channel+" number:"+number+" value:"+value);
}
