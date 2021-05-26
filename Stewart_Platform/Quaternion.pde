/***************************************************************************
 * Quaternion class written by BlackAxe / Kolor aka Laurent Schmalen in 1997
 * Translated to Java(with Processing) by RangerMauve in 2012
 * this class is freeware. you are fully allowed to use this class in non-
 * commercial products. Use in commercial environment is strictly prohibited
 */

public static class Quaternion {
  public  float W, X, Y, Z;      // components of a quaternion

  // default constructor
  public Quaternion() {
    W = 1.0;
    X = 0.0;
    Y = 0.0;
    Z = 0.0;
  }

  // initialized constructor

  public Quaternion(float w, float x, float y, float z) {
    W = w;
    X = x;
    Y = y;
    Z = z;
  }

  // quaternion multiplication
  public Quaternion mult (Quaternion q) {
    float w = W*q.W - (X*q.X + Y*q.Y + Z*q.Z);

    float x = W*q.X + q.W*X + Y*q.Z - Z*q.Y;
    float y = W*q.Y + q.W*Y + Z*q.X - X*q.Z;
    float z = W*q.Z + q.W*Z + X*q.Y - Y*q.X;

    W = w;
    X = x;
    Y = y;
    Z = z;
    return this;
  }
  static Quaternion mult(Quaternion q1, Quaternion q2){
    Quaternion copy = new Quaternion(q1.W, q1.X, q1.Y, q1.Z);
    return copy.mult(q2);
  }

  // conjugates the quaternion
  public Quaternion conjugate () {
    return new Quaternion(W, -X, -Y, -Z);
  }
  

  // inverts the quaternion
  public Quaternion reciprical () {
    float norme = sqrt(W*W + X*X + Y*Y + Z*Z);
    if (norme == 0.0)
      norme = 1.0;

    float recip = 1.0 / norme;

    W =  W * recip;
    X = -X * recip;
    Y = -Y * recip;
    Z = -Z * recip;

    return this;
  }

  // sets to unit quaternion
  public Quaternion normalize() {
    float norme = sqrt(W*W + X*X + Y*Y + Z*Z);
    if (norme == 0.0)
    {
      W = 1.0; 
      X = Y = Z = 0.0;
    }
    else
    {
      float recip = 1.0/norme;

      W *= recip;
      X *= recip;
      Y *= recip;
      Z *= recip;
    }
    return this;
  }

  // Makes quaternion from axis
  public Quaternion fromAxis(float Angle, float x, float y, float z) { 
    float omega, s, c;
    int i;

    s = sqrt(x*x + y*y + z*z);

    if (abs(s) > Float.MIN_VALUE)
    {
      c = 1.0/s;

      x *= c;
      y *= c;
      z *= c;

      omega = -0.5f * Angle;
      s = (float)sin(omega);

      X = s*x;
      Y = s*y;
      Z = s*z;
      W = (float)cos(omega);
    }
    else
    {
      X = Y = 0.0f;
      Z = 0.0f;
      W = 1.0f;
    }
    normalize();
    return this;
  }

  public Quaternion fromAxis(float Angle, PVector axis) {
    return this.fromAxis(Angle, axis.x, axis.y, axis.z);
  }

  // Rotates towards other quaternion
  public void slerp(Quaternion a, Quaternion b, float t)
  {
    float omega, cosom, sinom, sclp, sclq;
    int i;


    cosom = a.X*b.X + a.Y*b.Y + a.Z*b.Z + a.W*b.W;


    if ((1.0f+cosom) > Float.MIN_VALUE)
    {
      if ((1.0f-cosom) > Float.MIN_VALUE)
      {
        omega = acos(cosom);
        sinom = sin(omega);
        sclp = sin((1.0f-t)*omega) / sinom;
        sclq = sin(t*omega) / sinom;
      }
      else
      {
        sclp = 1.0f - t;
        sclq = t;
      }

      X = sclp*a.X + sclq*b.X;
      Y = sclp*a.Y + sclq*b.Y;
      Z = sclp*a.Z + sclq*b.Z;
      W = sclp*a.W + sclq*b.W;
    }
    else
    {
      X =-a.Y;
      Y = a.X;
      Z =-a.W;
      W = a.Z;

      sclp = sin((1.0f-t) * PI * 0.5);
      sclq = sin(t * PI * 0.5);

      X = sclp*a.X + sclq*b.X;
      Y = sclp*a.Y + sclq*b.Y;
      Z = sclp*a.Z + sclq*b.Z;
    }
  }

  public Quaternion exp()
  {                               
    float Mul;
    float Length = sqrt(X*X + Y*Y + Z*Z);

    if (Length > 1.0e-4)
      Mul = sin(Length)/Length;
    else
      Mul = 1.0;

    W = cos(Length);

    X *= Mul;
    Y *= Mul;
    Z *= Mul; 

    return this;
  }

  public Quaternion log()
  {
    float Length;

    Length = sqrt(X*X + Y*Y + Z*Z);
    Length = atan(Length/W);

    W = 0.0;

    X *= Length;
    Y *= Length;
    Z *= Length;

    return this;
  }
  
  PMatrix3D getRotMatrix(){
    PMatrix3D rot = new PMatrix3D();
    rot.m00 = 1 - 2*Y*Y - 2*Z*Z;
    rot.m01 = 2*X*Y - 2*Z*W;
    rot.m02 = 2*X*Z + 2*Y*W;
    
    rot.m10 = 2*X*Y + 2*Z*W;
    rot.m11 = 1 - 2*X*X - 2*Z*Z;
    rot.m12 = 2*Y*Z - 2*X*W;
    
    rot.m20 = 2*X*Z - 2*Y*W;
    rot.m21 = 2*Y*Z + 2*X*W;
    rot.m22 = 1 - 2*X*X - 2*Y*Y;
    
    rot.m33 = 1;
    
    return rot;
  }
  
  static Quaternion fromEuler(float x, float y, float z){
    float cy = cos(z*0.5);
    float sy = sin(z*0.5);
    float cp = cos(y*0.5);
    float sp = sin(y*0.5);
    float cr = cos(x*0.5);
    float sr = sin(x*0.5);
    
    float qw = cr * cp * cy + sr * sp * sy;
    float qx = sr * cp * cy - cr * sp * sy;
    float qy = cr * sp * cy + sr * cp * sy;
    float qz = cr * cp * sy - sr * sp * cy;
    
    return new Quaternion(qw, qx, qy, qz);
  }
  void calcFromEuler(float x, float y, float z){
    float cy = cos(z*0.5);
    float sy = sin(z*0.5);
    float cp = cos(y*0.5);
    float sp = sin(y*0.5);
    float cr = cos(x*0.5);
    float sr = sin(x*0.5);
    
    this.W = cr * cp * cy + sr * sp * sy;
    this.X = sr * cp * cy - cr * sp * sy;
    this.Y = cr * sp * cy + sr * cp * sy;
    this.Z = cr * cp * sy - sr * sp * cy;
  }
};
