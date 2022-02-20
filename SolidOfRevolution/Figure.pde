class Figure{
  PShape figure;
  public ArrayList<ArrayList<PVector>> meridians;
  
  Figure(ArrayList<PVector> sourceMeridian, PVector rotation, int strips){
    sourceMeridian = points2DTo3D(sourceMeridian);                                       
    move(sourceMeridian, rotation);                                                      
    meridians = createAllMeridians(sourceMeridian, strips);                              
  }
  
  ArrayList<ArrayList<PVector>> createAllMeridians(ArrayList<PVector> sourcePoints, int strips){
    if (3 <= strips){
      float angle = 360.0 / strips;
      ArrayList<ArrayList<PVector>> meridians = new ArrayList<ArrayList<PVector>>();
      meridians.add(sourcePoints);
      for (int i = 1; i <= strips; i++){
        ArrayList<PVector> newMeridian = deepCopy(meridians.get(meridians.size() - 1));
        rotate(newMeridian, radians(angle), 1);
        meridians.add(newMeridian);
      }
      return meridians;
    }
    return null;
  }
  
  void rotate(ArrayList<PVector> points, float angle, int axis){
    for (int i = 0; i < points.size(); i++){
      points.set(i, rotatePoint(points.get(i), angle, axis));
    }
  }
  
  PVector rotatePoint(PVector point, float angle, int axis){
    float[] res;
    switch(axis){
      case 0:                                            
        float[][] X = {{1,          0,           0},
                       {0, cos(angle), -sin(angle)},
                       {0, sin(angle),  cos(angle)}};
        res = multiplication(point.array(), X);
        break;
      case 1:                                            
        float[][] Y = {{ cos(angle), 0, sin(angle)},
                       {          0, 1,          0},
                       {-sin(angle), 0, cos(angle)}};
        res = multiplication(point.array(), Y);
        break;
      case 2:                                            
        float[][] Z = {{ cos(angle),-sin(angle), 0},
                       {sin(angle), cos(angle), 0},
                       {          0,          0, 1}};
        res = multiplication(point.array(), Z);
        break;
      default:                                          
        float[][] NOTHING = {{ 1, 0, 0},
                             { 0, 1, 0},
                             { 0, 0, 1}};
        res = multiplication(point.array(), NOTHING);
        break;

    }
    return new PVector(res[0], res[1], res[2]);
  }
  
  float[] multiplication(float[] A, float[][] B){
    float[] res = new float[A.length];
    for (int i = 0; i < A.length;i++){
      float sum = 0;
      for (int j = 0; j < B[0].length;j++){
        sum += A[j]*B[j][i];
      }
      res[i] = sum;
    }
    return res;
  }
  
  void move(ArrayList<PVector> points, PVector move){
    for (PVector point : points){
      point.x = point.x - move.x;
      point.y = point.y - move.y;
      point.z = point.z - move.z;
    }
  }

  ArrayList<PVector> points2DTo3D(ArrayList<PVector> points){
    if (1 <= points.size()){
      ArrayList<PVector> res = new ArrayList<PVector>();
      for (PVector point : points){
        res.add(new PVector(point.x, point.y, 0.0));
      }
      return res;
    }
    return null;
  }
  
  ArrayList<PVector> deepCopy(ArrayList<PVector> points){
    ArrayList<PVector> res = new ArrayList<PVector>();
    for (PVector point : points){
      res.add(new PVector(point.x, point.y, point.z));
      float[] p = (res.get(res.size()-1)).array();
    }
    return res;
  }
}
