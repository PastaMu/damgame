int s; //time
int wn; //水の数
int rectY;//メーター
int rectD;//メーター
int deadLine; //ライン上限
int cnt;//落ちた水の数
int n;//メーターで使ったよ
int ls;//大きい水が出てくるタイム的な
float wx, wy, sx, sy;
int mn=40; //材料の個数
int stonen;
int woodn;
int n1;
int[] n2=new int[mn];
float r; //一番右にある石のx座標
float l; //一番左にある石のx座標
float m; //石たちの真ん中
PFont font; //フォント指定変数
float u;
int on;
int stoneCnt; //置いてある石の数
int scene; //はじめの画面=０,プレイ画面=1,クリア画面=2,ゲームオーバー画面=3
int wood_cnt; //木に当たった水の数
PImage back;

class Water {
  int size=int(random(25, 35));
  float x;
  float y = random(-400, 20);
  float stepX = 0;
  float stepX2=stepX;
  float stepY = random(2.0, 6.0);
  float stepY2=stepY; //stepYを記憶してるだけ

  void display() {
    fill(0, 245, 255, 70);
    rect(x, y, size, size);
  }

  void flow() {
    if (falled()==false) {
      y+=stepY;
    } else {
      y=0;
    }
  }

  boolean falled() {
    if (y>height-10) {
      return true;
    } else {
      return false;
    }
  }
}

class Water2 extends Water {
  float stepX=random(1, 3);
  float stepX2=stepX;
  float stepY = random(2.0, 6.0);
  void set(float x) {
    if (x>width/2) {
      stepX*=-1;
    }
  }

  void flow() {
    if (falled()==false) {
      x+=stepX;
      y+=stepY;
    }
  }
}

class LWater extends Water { //大きい水
  void display() {
    size=35;
    fill(0, 191, 255);
    rect(x, y, size, size);
  }
}

class Material_Stone {//石のクラス
  PImage stone_img=loadImage("stone.png");
  int sizeX = 40;
  int sizeY = 30;
  //stoneの真ん中
  float x = 10+sizeX/2;
  float y = 40+sizeY/2;

  void display() {
    image(stone_img, x-sizeX/2, y-sizeY/2, sizeX, sizeY);
  }
}

class Material_Wood extends Material_Stone {//木のクラス
  PImage wood_img = loadImage("wood.png");
  int sizeX = 110;
  int sizeY = 35;
  //wood の真ん中
  float x = 10 + 110/2; 
  float y = 90 + 35/6;

  void display() {
    image(wood_img, x-sizeX/2, y-sizeY/6, sizeX, sizeY);
  }
  
  void move() {
    if(y+sizeY/2<=height) {
      y+=5;
    }
    if(y+sizeY/2>=height) {
      x=0;
    }
  }
}

//クリアしたらクリア画面を表示するクラス
class ClearDis {
  int[] score = new int[10];
  int highScore = 700;
  int time;
  int diff = 100;
  PImage beaver = loadImage("Beaver.png");
  PImage beaver_b = loadImage("Beaver2.png");
  PImage fall = loadImage("taki.jpg");
  PImage signboard = loadImage("kanban.png");
  PImage img2 = loadImage("Beaverdie.png");
  PImage img3 = loadImage("tama.png");
  int f_x = 0, f_y = 0, f_sizeX = 500, f_sizeY = 800;
  int b_x = width/4 ,b_y = height-height/6, b_size = 100; //ビーバーのx,y,size
  int s_x = width/4, s_y = height-height/6,s_size = 500;//看板のx,y,size
  
  void makeScore() {
    time = s/60;
    if (highScore > (time)) {
      highScore = time;
    }
  }

  void resultDisplay() {
    float yDiff = 60;
    image(fall, f_x, f_y, f_sizeX, f_sizeY);
    image(beaver_b,b_x, b_y, b_size, b_size);
    image(beaver, width-b_x, b_y, b_size, b_size);
    image(signboard,width/2-diff*2.4,height/2-yDiff*3, s_size, s_size);
    textSize(40);
    fill(0);
    text("クリアタイム:"+ (time), width/2-diff*1.5, height/2-yDiff);
    text("本日のハイスコア:"+ highScore, width/2-diff*1.8, height/2);
    blink();
    text("もう一度遊ぶ？ Press[r]", width/2-diff*2.0, height/2+yDiff);
  }
  
  void gameover(){
    background(0);
    fill(255);
    image(img2,width/2-30,height/2);
    image(img3,width/3-40,height/3*2,width/4,width/4);
    textSize(40);
    text("GameOver", width/2-diff, height/2-10);
    blink();
    text("もう一度遊ぶ？ Press[r]", width/2-diff*2.0-10, height/2+30);
  }
}

class Beaver { //ビーバークラス
  PImage beaver_img = loadImage("Beaver.png");
  float x, y;
  int Size = 70;

  void display(float x1, float y1) {
    x = (x1 - Size/4);
    y = (y1 - Size/2);
    image(beaver_img, x, y, Size, Size);
  }
}

//タイトル画面
class Title {
  int x = 0;
  int y = 0;
  int xSize = 500;
  int ySize = 800;
  float diff = 100;//中央にするための差（気にしなくてok）
  PImage fall_img = loadImage("taki.jpg");
  PImage beaver_img = loadImage("Beaver.png");
  PImage beaver_img2 = loadImage("Beaver2.png");
  int x_b = width/4; //ビーバーのx
  int y_b = height-height/6;//ビーバーのy

  void display() {
    image(fall_img, x, y, xSize, ySize);
    image(beaver_img2,x_b,y_b,100,100);
    image(beaver_img,width-x_b,y_b,100,100);
    textSize(25);
    fill(0);
    text("<操作説明>", xSize/2-(diff*2.2), ySize/1.5-(diff*2));
    text("・マウス--ビーバーの移動", xSize/2-(diff*2.2), ySize/1.5-(diff*1.5));
    text("・Space長押し--オブジェクトの選択", xSize/2-(diff*2.2), ySize/1.5-diff);
    blink();
    textSize(40);
    text("Push [space] key", xSize/2-diff*1.7, ySize/1.5);
  }
}


class Kaminari{
  float x = 0;
  float y = 30;
  PImage kaminari_img = loadImage("kaminari.png");
  PImage go_img = loadImage("go.png");
  int sizeX = 100;
  int sizeY = 100;
  PImage img = loadImage("kaminari.png");
  int textX = 50;
  int diff = 30;
  int textY = height - diff*10;
  int fontX = 50;
  int fontY = 50;

  
  void display(){
    image(kaminari_img,x,y,sizeX,sizeY);
  }
  
  void move(){
    x +=5;
  }
  
    void gogogo(){
    image(go_img,textX,textY,fontX,fontY);
    image(go_img,textX+diff, textY+diff, fontX,fontY);
    image(go_img,textX+diff*2, textY+diff*2, fontX,fontY);
    image(go_img,width-textX*2.5, textY, fontX,fontY);
    image(go_img,width-textX*2.5+diff, textY+diff, fontX,fontY);
    image(go_img,width-textX*2.5+diff*2, textY+diff*2, fontX,fontY);
  }
}


Material_Stone[] stones;
Material_Wood woods;
Title startImg; //タイトル画面
ClearDis endImg; //クリア後の画面
Beaver beaver; //ビーバー
Kaminari kaminari;//雷エフェクト

Water[] w1; //上から出てくる水
LWater w2; //大きい水
Water2[] w3; //横から出てくる水


void set(){
  s = 0;
  wn = 600;
  rectY = 800;
  rectD = 0;
  deadLine = 700;
  cnt = 0;
  n = 1;
  ls = 15;
  mn = 40;
  stonen = 0;
  woodn = 0;
  n1 = 0;
  on = 0;
  stoneCnt = 0;
  font = createFont("MS Gothic", 24, true);
  textFont(font);
  wood_cnt=0;
  stones = new Material_Stone[mn];
  woods = new Material_Wood();
  beaver = new Beaver();
  startImg = new Title();
  endImg = new ClearDis();
  kaminari = new Kaminari();
  w1 = new Water[wn];
  w2 = new LWater(); 
  w3 = new Water2[wn];
  for (int i = 0; i < mn; i++) {
    stones[i]=new Material_Stone();
    n2[i]=0;
  }
  for (int i = 0; i < wn; i++) {
    w1[i]=new Water();
    w1[i].x=random(195, 305);
    w3[i]=new Water2();
    if (i < wn/2) {
      w3[i].x=0;
    } else {
      w3[i].x=random(width+5, width+50);
    }
    w3[i].set(w3[i].x);
  }
  w2.x=random(200, 300);
  
}

void setup() {
  size(498, 800);
  set();
}



void back() {//背景
  background(255);
  stroke(255, 0, 0);
  line(0, 700, 600, 700);
  fill(0);
  textSize(20);
  text("time:"+s/60, 10, 20);
  noStroke();
}

void roller() {
  if(kaminari.x<width+kaminari.sizeX) {
    for(int i = 0; i < stonen; i++) {
      if(kaminari.x>=(stones[i].x-stones[i].sizeX/2)&&kaminari.x<=(stones[i].x+stones[i].sizeX/2)) {
        stones[i].x=(stones[i].sizeX/2+kaminari.x+kaminari.sizeX/2);
        stones[i].y=(kaminari.y+kaminari.sizeY/2);
      }
    }
    kaminari.x+=4;
  }
}

boolean isHit(float x, float sizeX, float y, float sizeY, Water water) {
  if((y+30)<water.y) {
    return false;
  }else if ((x-sizeX)<(water.x+water.size)&&water.x<(x+sizeX)&&(water.y+water.size)>=(y-sizeY)) {
    return true;
  }
  
  return false;
}

void doHit(float x, float sizeX, float y, float sizeY, Water water,  int a) {
  if (isHit(x, sizeX, y, sizeY, water)==true) {
      water.stepY=0;
      water.stepX=random(3, 5);
      if (m<(water.x+water.size/2)) { 
        if (water.x<r||water.x<(x+sizeX)) { 
          if (a==1&&(water.x+water.size)>=width&&water.y<y) { 
            water.stepX*=-1;
          }
          water.x += water.stepX;
        }
      }else{
        if ((water.x+water.size)>l||(water.x+water.size)>(x-sizeX)) { 
          if (a==1&&water.x<=0&&water.y<y) { 
            water.stepX*=-1;
          }
          water.x -= water.stepX;
        }
      }
  } else{
    water.stepX=water.stepX2;
    water.stepY=water.stepY2;
  }
}

void doHit2(float x, float sizeX, float y, float sizeY, Water water,int i) {
  if (isHit(x, sizeX, y, sizeY, water)==true) {
      water.stepY=0;
      water.stepX=random(3, 5);
      if(i>=wn/2) {
        if ((water.x+water.size)>l||(water.x+water.size)>(x-sizeX)) { 
          if (water.x<=0&&water.y<y) { 
            water.stepX*=-1;
          }
          water.x -= water.stepX;
        }
      }else {
        if (water.x<r||water.x<(x+sizeX)) { 
          if ((water.x+water.size)>=width&&water.y<y) { 
            water.stepX*=-1;
          }
          
          water.x += water.stepX;
        }
      }
  } else{
    water.stepY=water.stepY2;
  }
}

void fallingWater1(Water[] water, int a) {
  for (int i = 0; i < wn; i++) {
    water[i].display();
    water[i].flow();
    
    for (int j = 0; j < stonen; j++) {
      if(a==1) {
        doHit(stones[j].x, stones[j].sizeX/2, stones[j].y, stones[j].sizeY/2, water[i],  a);
      }else{
        doHit2(stones[j].x, stones[j].sizeX/2, stones[j].y, stones[j].sizeY/2, water[i], i);
      }
      for (int k = 0; k<stonen; k++) {
        if(a==1) {
          doHit(stones[j].x, stones[j].sizeX/2, stones[j].y, stones[j].sizeY/2, water[i],  a);
        }else{
           doHit2(stones[k].x, stones[k].sizeX/2, stones[k].y, stones[k].sizeY/2, water[i], i);
        }
      }
    }
    if(i%100==0&&isHit(woods.x,woods.sizeX/2,woods.y,woods.sizeY/2,water[i])==true) {
      wood_cnt++;
      if(wood_cnt>=10) {
        woods.move();
      }
    }
    meter(water[i], a, i);
  }
}


void fallingWater2() { //大きい水の処理
  if (s/60>ls) {
    w2.display();
    w2.flow();
  }
  if(isHit(woods.x,woods.sizeX/2,woods.y,woods.sizeY/2,w2)==true) {
    w2.y=0;
    ls+=ls;
  }
  println(stoneCnt);
  for(int i = 0; i < stonen; i++) {
    if (isHit(stones[i].x-7, stones[i].sizeX/2+1.5, stones[i].y, stones[i].sizeY/2+5, w2)==true){
      stones[i].y=w2.y+w2.size;
      if(w2.falled()==true&&s/60>0) {
        stoneCnt--;
      }
    }
  }
  if (w2.falled()==true&&s/60>0) {
    w2.x=random(250,350);
    w2.y=0;
    ls+=ls;
    n+=7; //落ちたら一気にメーターが増える
  }
}

void meter(Water w, int a, int i) {
  if (w.falled()==true) {
    if (a==1) {
      w.x=random(195, 305);
    } else {
      if (i < wn/2) {
        w.x=0;
      } else {
        w.x=width;
      }
    }
    if (a==2) {
      if(stonen==0) {
        w.y=deadLine;
      }else{
        w.y=u+40;
      }
    }
    cnt+=1;
  }
}

void thunder(){
    if(frameCount/10 %2== 0){
      rect(0,0,width,height);
      background(255,255,201,128);
      kaminari.gogogo();
      for(int i = 0; i < wn; i++) {
        if(isHit(beaver.x, beaver.Size/2, beaver.y, beaver.Size/2, w1[i])) {
          scene=3;
          retry();
        }
      }
    }
  }
  
void draw() {
  if(scene==0) {
    startImg.display();
    if ((keyPressed == true) && (key == ' ')) {
      scene=1;
    }
  } else if(scene==1){
    back();
    if (clearCondition() == true) { //クリア条件を満たしたら
      endImg.makeScore(); //ハイスコアを生成
    }
    if (rectY<=deadLine) {
      scene=3;
    }
      fallingWater1(w1, 1);
      if(s/60 > 11){
        kaminari.display();
        kaminari.move();
      }
      if(s/60 > 13 && s/60 < 16){
        thunder();
      }
      if (s/60>=15) {
        fallingWater1(w3, 2);
        on=1;
      }
      fallingWater2();
      if (s/60==14) {
        kaminari.x=0;
        kaminari.y=u-stones[0].sizeY*2;
      }
      if (s/60>14) {
        roller();
      }
      if (cnt>wn/3) { //水が200個落ちたらメーターが増える
        rectD=n;
        rectY=height-n;
        n+=1;
        cnt=0;
      }
      //メーター
      fill(0, 245, 255, 70);
      rect(0, rectY, width, rectD);
      for (int i = 0; i <= stonen+1; i++) {
        stones[i].display();
      }
      woods.display();
      beaver.display(mouseX, mouseY);
      //時間
      s++;
    put();
  }else if(scene==2) {
    endImg.resultDisplay(); //クリア画面を表示
    retry();
  }else{
    endImg.gameover();
    retry();
  }
}

void put() {
  if (operationObject(woods.x, woods.y, woods.sizeX/2, woods.sizeY/6) == true&&n2[stonen]==0) {
    n1=1;
  }
  if (n1==1) {
    if (key==' ') {
      if ((keyPressed == true)) {
        woods.x = mouseX;
        woods.y = mouseY;
        wx=mouseX;
        wy=mouseY;
      } else {
        woods.x=wx;
        woods.y=wy;
        n1=0;
      }
    }
  }

  if (operationObject(stones[stonen].x, stones[stonen].y, stones[stonen].sizeX/2, stones[stonen].sizeY/2) == true&&n1==0) {
    n2[stonen]=1;
  }
  if (n2[stonen]==1) {
    if (key==' ') {
      if ((keyPressed == true)) {
        stones[stonen].x = mouseX;
        stones[stonen].y = mouseY;
        sx=mouseX;
        sy=mouseY;
      } else {
        stones[stonen].x=sx;
        stones[stonen].y=sy;
        if (stonen==0||s/60>=14&&s/60<=16) {
          r=stones[stonen].x+stones[stonen].sizeX/2;
          l=stones[stonen].x-stones[stonen].sizeX/2;
          if(on==0) {
            u=stones[stonen].y+stones[stonen].sizeY/2;
          }
        } else {
          if (r<(stones[stonen].x+stones[stonen].sizeX/2)) {
            r=stones[stonen].x+stones[stonen].sizeX/2;
          }
          if (l>(stones[stonen].x-stones[stonen].sizeX/2)) {
            l=stones[stonen].x-stones[stonen].sizeX/2;
          }
          if (on==0) {
            if (u < (stones[stonen].y+stones[stonen].sizeY/2)) {
               u=stones[stonen].y+stones[stonen].sizeY/2;
            }
          
            for (int i = 0; i < wn; i++) {
              if(stonen==0) {
                w3[i].y=deadLine;
              }else{
                w3[i].y=u+40;
              }
            }
          }
           
          m=(r+l)/2;
        }
        n2[stonen]=0;
        stonen++;
        stoneCnt++;
      }
    }
  }
}

boolean operationObject(float x, float y, int sizeX, int sizeY) { //ドラッグするための条件
  if ((judge(x, y, sizeX, sizeY) == true) ) {
    if ((keyPressed == true) && (key == ' ')) {
      return true;
    }
  }
  return false;
}

boolean judge(float x, float y, int sizeX, int sizeY) {
  if (mouseY <= (y+sizeY) && (y - sizeY) <= mouseY && mouseX >= (x-sizeX) && (x + sizeX) >= mouseX) {
    return true;
  } else {
    return false;
  }
}

boolean clearCondition() { //pwはwの一つ前の
  if ( (s/60) > 15) {
    if ((r-l) >= width && stoneCnt > 18) {
      scene=2;
      return  true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

void retry(){ // リトライ
  if(keyPressed == true && key == 'r'){
    scene=1;
    set();
  }
}

void blink(){ //点滅
  if(frameCount/10 %2 == 0){
    fill(0,255,255);
  }else{
    fill(0);
  }
}
