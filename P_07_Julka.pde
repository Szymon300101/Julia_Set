float Ca= 0.112;  //A parameter
float Cb= 0.582;  //B parameter

float scale=1; //Zoom value
float mX=0;  //X position of camera
float mY=0;  //Y position of camera
int max=4000;  //number of tests for each pixel
float s=1;  //current value of display simplification (1 or sMax)
float sMax=2;  //simplification if it is ON
int col=1000;  //color scaling (substituting max in color mapping for better control)

void setup()
{
  fullScreen();
  colorMode(HSB,255);
  //size(600,600);
  frameRate(60);
  paint();
}

//scrolling event
void mouseWheel(MouseEvent event) {
    scale+=event.getCount()*scale*0.3;
    fill(255);
  paint();
}

//keyes events
void keyPressed()
{
  //println(keyCode);
  switch(keyCode)
  {
    case 38: max/=0.1; break; //-->
    case 40: max*=0.1; break; //<--
    case 109: if(sMax>2)sMax-=1; if(s>1) s=sMax; break;  //-
    case 107: sMax+=1; if(s>1) s=sMax; break;  //+
    case 65: Ca-=0.001; break; //a
    case 68: Ca+=0.001; break; //d
    case 87: Cb-=0.001; break; //s
    case 83: Cb+=0.001; break; //w
    case 91: col/=0.4; break; //]
    case 93: col*=0.4; break; //[
    case 10: saveFrame(); break; //ENTER
    case 32: if(s==1) s=sMax; else s=1; break; //SPACE
  }
  paint ();
}

//camera movement function
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
  noStroke();
  background(51);
  //for each point
for(int x=0;x<width/s;x++)
  for(int y=0;y<height/s;y++)
  {
    //mapping coordinates of point in complex space
    float a=map(x,0,width/s,-2*scale+mX,2*scale+mX);
    float b=map(y,0,width/s,-2*scale+mY,2*scale+mY);
    
    //checking if string for this point has a limit
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
    
    float bri = map(n,0,col,0,1);
    //if it hadn't fill with black, if not map a color to it
    if(n==max)
    fill(0);
    else
    fill(map(pow(bri,0.175),0,1,120,255),255,255);
    
    rect(x*s,y*s,1,1);
  }
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
  txt+= "\nColor = " + col;
  txt+= "\nPreview = " + s + "/" + sMax;
  text(txt,10,15);
}
