float scale=1;
float mX=0;
float mY=0;
int iter=40;
float s=1;

float Ca=0.112;
float Cb=0.582;
void setup()
{
  //fullScreen();
  colorMode(HSB,255);
  size(800,650,P3D);
  frameRate(60);
  paint();
}

void keyPressed()
{
  println(keyCode);
  switch(keyCode)
  {
    case 38: mY-=scale/3; break; //-->
    case 40: mY+=scale/3; break; //<--
    case 37: mX-=scale/3; break;
    case 39: mX+=scale/3; break;
    case 107: scale-=scale*0.3; break;
    case 109: scale+=scale*0.3; break;
    case 65: Ca-=0.01; break; //-->
    case 68: Ca+=0.01; break; //<--
    case 87: Cb-=0.01; break;
    case 83: Cb+=0.01; break;
    case 10: saveFrame("00.PNG"); break;
    case 32: if(s==1) s=3; else s=1; break;
  }
  println("Ca: " + Ca);
  println("Cb: " + Cb);
  paint ();
}

void draw()
{
}


void paint()
{
  rotateX(20);
  noStroke();
  //scale(s);
  background(255);
  //scale(scale);
for(int x=0;x<width/s;x++)
  for(int y=0;y<height/s;y++)
  {
    float a=map(x,0,width/s,-2*scale+mX,2*scale+mX);
    float b=map(y,0,width/s,-2*scale+mY,2*scale+mY);
    
    int max;
    if(s==1) max=iter;
    else    max=200;
    
    int n;
    for(n=0;n<max;n++)
    {
      float a2 = a*a-b*b;
      float b2 = 2.1*a*b;
      a=a2+Ca;
      b=b2+Cb;
      if(a*a+b*b>16) break;
    }
    
    float bri = map(n,0,max,0,1);
    if(n==max)
    {
    fill(0);
    rect(x*s,y*s,s,s);
    }
  }
  write();
}

void write()
{
  fill(255);
  textSize(15);
  String txt= "Parametr a= " + Ca;
  txt+= "\nParametr b= " + Cb;
  txt+= "\nPowiększenie * " + 1/scale;
  text(txt,10,20);
}
