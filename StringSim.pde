int chunks = 500;
int chunkSize;
int yEnd, lEnd, rEnd, nEnd = 10;
float T = 50, rhol = 0.00578f, c;
float timestep = 0.9f;
float dampingFactor = 0.9f;
class Chunk
{
  float[] omega;
  float[] A;
  float l;
  Chunk(float h,float c, float l,float d)
  {
    A = new float[nEnd];
    omega = new float[nEnd];
    this.l = l;
    for(int n = 1; n<=nEnd;n++)
    {
      A[n-1] = 2*h*l*l*sin(d*n*PI/l)/(n*n*PI*PI*d*(l-d));
      omega[n-1]  = PI*n*c/l;
    }
    
  }
  float getYPos(float time,int x)
  {
    float y = 0;
    for(int n = 0; n<nEnd; n++)
    {
        y += A[n]*cos(omega[n]*time)*sin((n+1)*PI*x/l);
    }
    return y * dampingFactor;
  }
}

Chunk[] myChunks;
void setup()
{
  size(1000, 800);
  yEnd = height/2;
  lEnd = 0;
  rEnd = screenSize;
  myChunks = new Chunk[width];
  c = sqrt(T/rhol);
}
 
boolean wasPressed = false, startSim = false;
int releasePosX = 0, releasePosY = 0;
float time = 0;

void draw()
{
  background(255, 205, 41);
  stroke(255, 98, 41);
  strokeWeight(3);
  if (wasPressed && !mousePressed)
  {
    wasPressed = false;
    for(int i = 0; i<width; i++)
    {
      myChunks[i] = new Chunk(pmouseY-(float)height/2,c,width,pmouseX);
    }
    
    startSim = true;
    time = 0;
  }
  if (startSim)
  {
    time+= timestep;
    for (int i = 0; i< width; i++)
    {
      point(i,height/2 + myChunks[i].getYPos(time,i));
    }
    dampingFactor *= exp(-time/10000);
    
  }
  if (mousePressed && mouseButton == LEFT)
  {
    wasPressed = true;
    line(0, height/2, mouseX, mouseY);
    line(mouseX, mouseY, width, height/2);
  }
  if (mousePressed && mouseButton == RIGHT)
  {
    startSim = false;
    myChunks = new Chunk[width];
    dampingFactor = 0.9f;
  }
}
