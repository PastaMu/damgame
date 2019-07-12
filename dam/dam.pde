int s = 0; //time
int wn=600; //水の数
int rectY=800;//メーター
int rectD=0;//メーター
int cnt=0;//落ちた水の数
int n=1;//メーターで使ったよ
int ls=15;//大きい水が出てくるタイム的な
int wingLR; //風が左右どちらからくるかsetupで
float woodx0=10 + 110/2; 
float woody0=90 + 35/6;
float wx, wy, sx, sy;
int mn=20; //材料の個数
int stonen=0;
int woodn=0;
int n1=0;
int[] n2=new int[mn];
float r; //一番右にある石のx座標
float l; //一番左にある石のx座標
float m; //石たちの真ん中

class Water {
  int size=int(random(25, 35));
  float x;
  float y = random(-400, 20);
  float stepX = 0;
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

class LWater extends Water { //大きい水
  void display() {
    size=35;
    fill(0, 191, 255);
    rect(x, y, size, size);
  }
}

class Material_Stone {//石のクラス
  PImage img = loadImage("stone.png");
  int sizeX = 40;
  int sizeY = 30;
  //stoneの真ん中
  float x = 10+sizeX/2;
  float y = 40+sizeY/2;

  void display() {
    image(img, x-sizeX/2, y-sizeY/2, sizeX, sizeY);
  }
}

class Material_Wood extends Material_Stone {//木のクラス
  PImage img = loadImage("wood.png");
  int sizeX = 110;
  int sizeY = 35;
  //wood の真ん中
  float x = woodx0; 
  float y = woody0;

  void display() {
    image(img, x-sizeX/2, y-sizeY/6, sizeX, sizeY);
  }
}

//クリアしたらクリア画面を表示するクラス
class ClearDis{
  int[] score = new int[10];
  int highScore = 700;
  int max = 10;
  boolean flag = false;
  
  void makeScore(int time){
    if(highScore > time){
      highScore = (time/60);
    }
  }
  
  void resultDisplay(int time){
    textSize(20);
    fill(0);
    text("クリアタイム:"+ (time/60), width/2, height/2);
    text("本日のハイスコア:"+ highScore, width/2, height/2+30);
  }
}
  

//タイトル画面
class Title{
  int x = 0;
  int y = 0;
  int xSize = 500;
  int ySize = 800;
  int diff = 100;//中央にするための差（気にしなくてok）
  PImage img = loadImage("title.png");
  boolean pushSpace = true;
  
  void display(){
    image(img,x,y,xSize,ySize);
    textSize(30);
    fill(0);
    text("Push [space] key", xSize/2-diff, ySize/2);
  }
}


Material_Stone[] stones;
Material_Wood woods;
Title startImg; //タイトル画面
ClearDis endImg; //クリア後の画面

Water[] w1; 
LWater w2;

void setup() {
  size(500, 800);
  stones = new Material_Stone[mn];
  woods = new Material_Wood();
  startImg = new Title();
  endImg = new ClearDis();
  w1 = new Water[wn];
  w2 = new LWater(); 
  for (int i = 0; i < mn; i++) {
    stones[i]=new Material_Stone();
    n2[i]=0;
  }
  for (int i = 0; i < wn; i++) {
    w1[i]=new Water();
    w1[i].x=random(195, 305);
  }
  w2.x=random(200, 300);
  wingLR=int(random(1, 3));
}

void back() {//背景
  background(255);
  stroke(255, 0, 0);
  line(0, 700, 600, 700);
  fill(0);
  textSize(20);
  text("time:"+s/60, 10, 20);
  noStroke();
  for (int i = 0; i < mn; i++) {
    stones[i].display();
  }
  woods.display();
}

boolean isHit(float x, float sizeX, float y, float sizeY, Water water) {
  if ((x-sizeX)<(water.x+water.size/2)&&water.x<(x+sizeX)&&(water.y+water.size)>=(y-sizeY)&&(water.y+water.size)>=(y-sizeY)) {
    return true;
  }
  return false;
}

void doHit(float x, float sizeX, float y, float sizeY, Water water) {
  if (isHit(x, sizeX, y, sizeY, water)==true) {
    water.stepY=0;
    if (m<(water.x+water.size/2)) {
      if (water.x<r||water.x<(x+sizeX)) {
        water.stepX=random(3,5);
        if((water.x+water.size)>width&&water.y<y) {
          water.stepX*=-1;
        }
        water.x += water.stepX;
      }
    } else {
      if ((water.x+water.size/2)>l||(water.x+water.size/2)>(x-sizeX)) {
        water.stepX=random(3,5);
        if(water.x<0&&water.y<y) {
          water.stepX*=-1;
        }
        water.x-=water.stepX;
      }
    }
  } else {
    water.stepX=0;
    water.stepY=water.stepY2;
  }
}

void fallingWater1(Water[] water) {
  for (int i = 0; i < wn; i++) {
    water[i].display();
    water[i].flow();
    doHit(woods.x, woods.sizeX/2, woods.y, woods.sizeY/5, water[i]);
    for (int j = 0; j <= stonen; j++) {
      doHit(stones[j].x-7, stones[j].sizeX/2+1.5, stones[j].y, stones[j].sizeY/2+5, water[i]);
      for (int k = 0; k<=stonen; k++) {
        if (isHit(stones[k].x-7, stones[k].sizeX/2+1.5, stones[k].y, stones[k].sizeY/2+5, water[i])==true) {
          doHit(stones[k].x-7, stones[k].sizeX/2+1.5, stones[k].y, stones[k].sizeY/2+5, water[i]);
        }
      }
    }

    if (s/60>=20&&25>=s/60) {
      if (water[i].y>height/5&&water[i].y<height*3/5) {
        //wing(water[i]);
      }
    }
    meter(water[i]);
  }
}

void fallingWater2() {
  if (s/60>ls) {
    w2.display();
    w2.flow();
  }
  if (w2.falled()==true&&s/60>0) {
    w2.y=0;
    ls+=ls;
    n+=5; //落ちたら一気にメーターが増える
  }
}

void meter(Water w) {
  if (w.falled()==true) {
    w.x=random(195, 305);
    cnt+=1;
  }
}

void wing(Water w) {
  if (wingLR==1) {
    w.x-=2;
  } else {
    w.x+=2;
  }
}

void draw() {
  if(startImg.pushSpace == true){
    startImg.display();
    if((keyPressed == true) && (key == ' ')){
      startImg.pushSpace = false;
    }
  }else{
    back();
    for(int i = 1; i < wn; i++){
      if(clearCondition(w1[i],w1[i-1]) == true){ //クリア条件を満たしたら
        endImg.flag = true; //クリア時のフラグをかえる
        endImg.makeScore(s); //ハイスコアを生成
      }
    }
    if(endImg.flag == true){
      endImg.resultDisplay(s/60); //クリア画面を表示
    }
    if (rectY==700) {
      fill(0);
      text("game over", width/2, height/2);
    } else {
      fallingWater1(w1);
      fallingWater2();
      if (cnt>wn) { //水が150個落ちたらメーターが増える
        rectD=n;
        rectY=height-n;
        n+=1;
        cnt=0;
      }
      //メーター
      fill(0, 245, 255, 70);
      rect(0, rectY, width, rectD);
      //時間
      s++;
    }
    put();
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
        if (stonen==0) {
          r=stones[0].x+stones[0].sizeX/2;
          l=stones[0].x-stones[0].sizeX/2;
        } else {
          if (r<(stones[stonen].x+stones[stonen].sizeX/2)) {
            r=stones[stonen].x+stones[stonen].sizeX/2;
          }
          if (l>(stones[stonen].x-stones[stonen].sizeX/2)) {
            l=stones[stonen].x-stones[stonen].sizeX/2;
          }
        }
        m=(r+l)/2;
        n2[stonen]=0;
        stonen++;
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

boolean clearCondition(Water w, Water pw){ //pwはwの一つ前の水
  int clearCnt = 0; //水が何個か地面に触れていなければクリア
  if( (s/60) > 15){
    if(w.falled() == false && pw.falled() == false){ //ある時間で水と一個前の水が地面に落ちていなければ
      clearCnt++;
    }
    if(clearCnt > wn){ //水が全部落ちてなければゲームクリア
      return  true;
    }else{
      return false;
    }
  }else{
    return false;
  }
}
