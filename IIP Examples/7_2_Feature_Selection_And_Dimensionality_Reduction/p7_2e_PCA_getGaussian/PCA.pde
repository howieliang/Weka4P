import Jama.Matrix;
import pca_transform.*;
import papaya.*; //statistic library for processing

Matrix originalData;
Matrix eigenVectors;
PCA pca;
Matrix rotated;

PVector axis1;
PVector axis2;
PVector mean;

float[] allX, allY;

void getEigenVectors(Table csvData) {
  originalData = new Matrix(csvData.getRowCount(), csvData.getColumnCount());
  mean = new PVector();
  allX = new float[csvData.getRowCount()];
  allY = new float[csvData.getRowCount()]; 
  for (int i = 0; i < originalData.getRowDimension(); i++) {
    TableRow row = csvData.getRow(i);
    float xValue = row.getFloat("x");
    float yValue = row.getFloat("y");
    originalData.set(i, 0, xValue);
    originalData.set(i, 1, yValue);
    mean.x += xValue;
    mean.y += yValue;
    //allX[i] = xValue;
    //allY[i] = yValue;
  }
  //originalData.print(10, 2);

  mean.x /= originalData.getRowDimension();
  mean.y /= originalData.getRowDimension();

  pca = new PCA(originalData);
  eigenVectors = pca.getEigenvectorsMatrix();
  println("num eigen vectors: " + eigenVectors.getColumnDimension());
  for (int i = 0; i < eigenVectors.getColumnDimension(); i++) {
    println("eigenvalue for eigenVector " + i + ": " + pca.getEigenvalue(i) );
  }
  eigenVectors.print(10, 2);
  axis1 = new PVector();
  axis2 = new PVector();
  axis1.x = (float)eigenVectors.get(0, 0);
  axis1.y = (float)eigenVectors.get(1, 0);
  axis2.x = (float)eigenVectors.get(0, 1);
  axis2.y = (float)eigenVectors.get(1, 1);  
  rotated = pca.transform(originalData, PCA.TransformationType.ROTATION);

  float angle = -axis1.heading();
  allX = new float[csvData.getRowCount()];
  allY = new float[csvData.getRowCount()]; 
  for (int i = 0; i < csvData.getRowCount(); i++) { 
    //read the values from the file
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float id = row.getFloat("label");
    int index = (int) id;

    //form a feature array
    float[] features = { x-mean.x, y-mean.y };
    float[] newFeatures = {features[0]*cos(angle)-features[1]*sin(angle), features[0]*sin(angle)+features[1]*cos(angle)};
    allX[i]=newFeatures[0];
    allY[i]=newFeatures[1];
  }
  
  axis1.mult(2*Descriptive.std(allX, true));//(float)pca.getEigenvalue(0));
  axis2.mult(2*Descriptive.std(allY, true));//(float)pca.getEigenvalue(1));
  
}

public PVector point_nearest_line(PVector v0, PVector v1, PVector p) {
  PVector vp = null;
  PVector the_line = PVector.sub(v1, v0);
  float lineMag = the_line.mag();
  lineMag = lineMag * lineMag;
  if (lineMag > 0.0) {
    PVector pv0_line = PVector.sub(p, v0);
    float t = pv0_line.dot(the_line)/lineMag;
    if (t >= 0 && t <= 1) {
      vp = new PVector();
      vp.x = the_line.x * t + v0.x;
      vp.y = the_line.y * t + v0.y;
    }
  }
  return vp;
}
