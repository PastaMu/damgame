int s = 0; //time
int wn=600; //水の数
int rectY=800;//メーター
int rectD=0;//メーター
int cnt=0;//落ちた水の数
int n=1;//メーターで使ったよ
int ls=15;//大きい水が出てくるタイム的な
int wingLR; //風が左右どちらからくるかsetupで
int n1 = 0,n2=0;
int wx,wy,sx,sy;

class Water {
  int size=int(random(25, 35));
  float x;
  float y = random(-400, 20);
  float stepY = random(2.0, 6.0);

  void display() {
    fill(0, 245, 255, 70);
    rect(x, y, size, size);
  }

  void flow() {
    if (y<height) {
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
  PImage img;
  int sizeX = 40;
  int sizeY = 30;
  float x = 10+sizeX/2;
  float y = 40+sizeY/2;
  Material_Stone(PImage mat) {
    img = mat;
  }

  void display() {
    image(img, x-sizeX/2, y-sizeY/2,sizeX,sizeY);
  }
}

class Material_Wood extends Material_Stone {//木のクラス
  int sizeX = 110;
  int sizeY = 35;
  float x = 10 + sizeX/2;
  float y = 90 + sizeY/6;
  Material_Wood(PImage mat) {
    super(mat);
  }

  void display() {
    image(img, x-sizeX/2, y-sizeY/6, sizeX, sizeY);
  }
}

Material_Stone stones;
Material_Wood woods;

PImage wood, stone;
Water[] w1; 
LWater w2;

void fallingWater1(Water[] w) {
  for (int i = 0; i < wn; i++) {
    w[i].display();
    w[i].flow();
    if (s/60>=20&&25>=s/60) {
      if (w[i].y>height/5&&w[i].y<height*3/5) {
        wing(w[i]);
      }
    }
    meter(w[i]);
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




void setup() {
  size(500, 800);
  wood = loadImage("wood.png");
  stone = loadImage("stone.png");
  stones = new Material_Stone(stone);
  woods = new Material_Wood(wood);
  w1 = new Water[wn];
  w2 = new LWater(); 
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
  stones.display();
  woods.display();
}

void draw() {
  back();
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
  s++;
}

void put() {
  if (operationObject(woods.x, woods.y, woods.sizeX/2, woods.sizeY/6) == true&&n2==0) {
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
  
  if (operationObject(stones.x, stones.y, stones.sizeX/2, stones.sizeY/2) == true&&n1==0) {
    n2=1;
  }
  if (n2==1) {
    if (key==' ') {
      if ((keyPressed == true)) {
        stones.x = mouseX;
        stones.y = mouseY;
        sx=mouseX;
        sy=mouseY;
      } else {
        stones.x=sx;
        stones.y=sy;
        n2=0;
      }
    }
  }
}

boolean operationObject(float x, float y, int sizeX, int sizeY) {
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
