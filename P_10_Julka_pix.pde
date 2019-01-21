float Ca= 0.23;  //A parameter
float Cb= 0.55;  //B parameter

float scale=1; //Zoom value
float mX=0;  //X position of camera
float mY=0;  //Y position of camera
int max=4000;  //number of tests for each pixel
float s=1;  //current value of display simplification (1 or sMax)
float sMax=2;  //simplification if it is ON
float colr=0.125;  //color scaling (substituting max in color mapping for better control)
void setup()
{
  fullScreen();
  colorMode(HSB,255);
  frameRate(60);
  loadPixels();
  paint();
}

void mouseWheel(MouseEvent event) {
    scale+=event.getCount()*scale*0.3;
  
  println(scale);
  paint();
}

//keyes events
void keyPressed()
{
  //println(keyCode);
  switch(keyCode)
  {
    case 38: max/=0.1; break; //v
    case 40: max*=0.1; break; //^
    case 109: if(sMax>2)sMax-=1; if(s>1) s=sMax; break;  //-
    case 107: sMax+=1; if(s>1) s=sMax; break;  //+
    case 65: Ca-=0.001; break; //a
    case 68: Ca+=0.001; break; //d
    case 87: Cb-=0.001; break; //s
    case 83: Cb+=0.001; break; //w
    case 91: colr/=0.025; break; //]
    case 93: colr*=0.025; break; //[
    case 10: saveFrame(); break; //ENTER
    case 32: if(s==1) s=sMax; else s=1; break; //SPACE
  }
  paint ();
}

void draw()
{
  if(mouseButton==LEFT && (mouseX-pmouseX!=0 ||mouseY-pmouseY!=0))
  {
    mX-=(mouseX-pmouseX)*scale*0.01;
    mY-=(mouseY-pmouseY)*scale*0.01;
    println(mouseX-pmouseX);
    paint();
  }
}


void paint()
{
  if(s>1)
  for(int i=0;i<pixels.length;i++)
  pixels[i]=color(51);
  
  noStroke();
  background(0);
for(int x=0;x<width/s;x++)
  for(int y=0;y<height/s;y++)
  {
    float a=map(x,0,width/s,-2*scale+mX,2*scale+mX);
    float b=map(y,0,width/s,-2*scale+mY,2*scale+mY);
    int n;
    for(n=0;n<max;n++)
    {
      float a2 = a*a-b*b;
      float b2 = 2.1*a*b;
      a=a2+Ca;
      b=b2+Cb;
      
      if(n==max/4)
        if(a*a+b*b<0.5)
          {
            n=max;
            break;
          }
      if(a*a+b*b>8) break;
    }
    
    float bri = map(n,0,max,0,1);
    if(n==max)
    {
    pixels[int((y*width+x)*s)]=color(0);
    }
    else
    {
    color col = color(map(pow(bri,colr),0,1,120,255),255,255);
    pixels[int((y*width+x)*s)]=col;
    }
  }
  updatePixels();
  write();
}

void write()
{
  fill(255);
  textSize(12);
  String txt= "Parameter a= " + Ca;
  txt+= "\nParameter b= " + Cb;
  txt+= "\nZoom * " + 1/scale;
  txt+= "\nRendering = " + max;
  txt+= "\nColor = " + colr;
  txt+= "\nPreview = " + s + "/" + sMax;
  text(txt,10,15);
}
