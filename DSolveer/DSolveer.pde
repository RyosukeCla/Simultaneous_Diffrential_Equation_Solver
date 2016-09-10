DEquation nino1, nino2;
void setup () {
  nino1 = new DEquation ();
  nino1.setInitialX (1.0);
  nino1.setDEquation (new DEquationDelegate () {
    public float equation (float t, Parameter para) {
      return para.get(0) - pow (para.get(0), 3) - para.get(1);
    }
  });
  a = 1.0;
  b = 1.0;
  c = 1.0;
  nino2 = new DEquation ();
  nino2.setInitialX (-1.0);
  nino2.setDEquation (new DEquationDelegate () {
    public float equation (float t, Parameter para) {

      return a - b * para.get(1) + c;
    }
  });
  
  /*
  DEquation lotka_volterraPrey = new DEquation ();
  lotka_volterraPrey.setInitialX (2.0);
  lotka_volterraPrey.setDEquation (new DEquationDelegate () {
    public float equation (float t, Parameter para) {
      float alpha = 1.0;
      float beta = 1.1;
      return (alpha - beta * para.get (1) )* para.get(0);
    }
  });
  DEquation lotka_volterraPredeter = new DEquation ();
  lotka_volterraPredeter.setInitialX (2.0);
  lotka_volterraPredeter.setDEquation (new DEquationDelegate () {
    public float equation (float t, Parameter para) {
      float ganmma = 1.5;
      float delta = 1.0;
      return (-ganmma + delta * para.get(0)) * para.get(1);
    }
  });
  */
  solve = new DSolve (0.01,  100.0);
  solve.addDEquation (nino1);
  solve.addDEquation (nino2);
  solve.solve ();
  
  graph = new Graph ();
  graph.setSize (600, 400);
  graph.setRange (-5.0, 5.0, -5.0, 20.0);
  //solve.display ();
  size (800, 500);
  graph.displayFrame ();
  graph.displayPlot (nino1.getData(), nino2.getData());
  //translate (width/100.0, height*90.0/100.0);
  //solve.graph (0.5, 100.0);
}
DSolve solve;
Graph graph;
float a, b, c;
void draw () {
  solve.solve ();
  graph.displayPlot (nino1.getData(), nino2.getData());
}

class Parameter {
  ArrayList<Float> parameters;
  Parameter () {
    parameters = new ArrayList<Float>();
  }
  
  void add () {
    parameters.add (0.0);
  }
  
  void set (int index, float value) {
    parameters.set (index, value);
  }
  
  float get (int index) {
    return parameters.get (index);
  }
  
  int size () {
    return this.parameters.size();
  }
}

interface DEquationDelegate {
  public float equation (float t, Parameter paras);
}

class DEquation {
  float initialX;
  DEquationDelegate dEquation;
  float[] separateX;
  public void setting (int separation) {
    this.separateX = new float [separation];
    for (int i = 0; i < this.separateX.length; i++) {
      this.separateX[i] = 0.0;
    }
  }
  public void setDEquation (DEquationDelegate de) {
    this.dEquation = de;
  }
  public void setInitialX (float x) {
    this.initialX = x;
  }
  
  public float[] getData () {
    return separateX;
  }
}

class DSolve {
  ArrayList <DEquation> dEquations;
  Parameter parameters;
  float t;
  float h;
  float range;
  int n;
  DSolve (float h, float range) {
    dEquations = new ArrayList <DEquation> ();
    parameters = new Parameter ();
    this.t = 0;
    this.h = h;
    this.range = range;
    this.n = (int)( this.range / this.h);
  }

  void addDEquation (DEquation dq) {
    parameters.add();
    parameters.set (parameters.size() - 1, dq.initialX);
    dq.setting (n);
    dEquations.add (dq);
  }
  
  void solve () {
    this.t = 0.0;   
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < dEquations.size(); j++) {
        float temp = dEquations.get(j).dEquation.equation (this.t, parameters);
        parameters.set (j, parameters.get(j) + this.h * temp);
        dEquations.get(j).separateX[i] = parameters.get(j);
        
      }
      this.t += this.h;
    }
  }
  
  void graph (float sclX, float sclY) {
    float tt;
    noFill ();
    for (int j = 0; j < dEquations.size(); j++) {
      tt = 0.0;
      beginShape();
      for (int i = 0; i < n; i++) {
        vertex (tt * sclX, -dEquations.get(j).separateX[i] * sclY);
        tt += this.h;
      }
      endShape ();
    }
  }
  
  void graph2 (float sclX, float sclY) {
    float tt;
    noFill ();
      tt = 0.0;
      beginShape();
      for (int i = 0; i < n; i++) {
        vertex (-dEquations.get(0).separateX[i] * sclX, -dEquations.get(1).separateX[i] * sclY);
        tt += this.h;
      }
      endShape ();
  }
  
  void display () {
    String res = "";
    float tt;
    for (int j = 0; j < dEquations.size(); j++) {
      res = j + " : ";
      tt = 0.0;
      for (int i = 0; i < n; i++) {
        res += "(";
        res += tt + ", "+dEquations.get(j).separateX[i];
        res += ")";
        tt += this.h;
      }
      println (res);
    }
  }
}

class Graph {
  float leftX, rightX, leftY, rightY;
  float sizeX, sizeY;
  float posX, posY;
  
  Graph () {
    leftX = leftY = 0.0;
    rightX = rightY = 10.0;
    sizeX = sizeY = 100.0;
    posX = posY = 0;
  }
  
  void setPosition (float x, float y) {
    posX = x;
    posY = y;
  }
  
  void setSize (float x, float y) {
    sizeX = x;
    sizeY = y;
  }
  
  void setRange (float lx, float rx, float ly, float ry) {
    leftX = lx;
    rightX = rx;
    leftY = ly;
    rightY = ry;
  }
  
  void displayFrame () {
    pushMatrix ();
    stroke(255);
    fill (0, 0);
    translate (posX, posY);
    rect (0.0, 0.0, sizeX, sizeY);
    popMatrix ();
  }
  
  void displayPlot (float[] x, float[] y) {
    float scaledX, scaledY;
    pushMatrix ();
    translate (posX, posY);
    fill (200, 20);
    stroke (0);
    rect (0.0, 0.0, sizeX, sizeY);
    beginShape ();
    for (int i = 0; i < x.length; i++) {
      scaledX = map (x[i], leftX, rightX, 0.0, sizeX);
      scaledY = map (y[i], leftY, rightY, 0.0, sizeY);
      vertex (scaledX, sizeY-scaledY);
    }
    endShape ();
    popMatrix ();
  }
}