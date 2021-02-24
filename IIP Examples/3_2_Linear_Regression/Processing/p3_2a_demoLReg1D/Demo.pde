import weka.core.Attribute; //https://weka.sourceforge.io/doc.dev/weka/core/Attribute.html
import weka.core.Instances; //https://weka.sourceforge.io/doc.dev/weka/core/Instances.html
import weka.core.Instance; //https://weka.sourceforge.io/doc.dev/weka/core/Instances.html
import weka.core.DenseInstance; //https://weka.sourceforge.io/doc.dev/weka/core/DenseInstance.html
import weka.classifiers.Classifier; //https://weka.sourceforge.io/doc.stable-3-8/weka/classifiers/Classifier.html
import weka.classifiers.Evaluation; //https://weka.sourceforge.io/doc.dev/weka/classifiers/Evaluation.html
import weka.classifiers.AbstractClassifier; //https://weka.sourceforge.io/doc.dev/weka/classifiers/AbstractClassifier.html
import weka.filters.Filter; //https://weka.sourceforge.io/doc.dev/weka/filters/Filter.html
import weka.filters.unsupervised.attribute.NumericToNominal; //https://weka.sourceforge.io/doc.dev/weka/filters/unsupervised/attribute/NumericToNominal.html
import java.util.Random; //https://docs.oracle.com/javase/8/docs/api/java/util/Random.html
import weka.classifiers.functions.SMO; //https://weka.sourceforge.io/doc.stable/weka/classifiers/functions/SMO.htm
import weka.classifiers.functions.supportVector.RBFKernel; //https://weka.sourceforge.io/doc.dev/weka/classifiers/functions/supportVector/RBFKernel.html
import weka.classifiers.functions.supportVector.PolyKernel; //https://weka.sourceforge.io/doc.dev/weka/classifiers/functions/supportVector/PolyKernel.html
import weka.classifiers.functions.LinearRegression; //https://weka.sourceforge.io/doc.dev/weka/classifiers/functions/LinearRegression.html
import weka.classifiers.evaluation.RegressionAnalysis; //https://weka.sourceforge.io/doc.dev/weka/classifiers/evaluation/RegressionAnalysis.html

Table csvData;
String fileName = "data/testData.csv";
boolean b_saveCSV = false;
boolean b_train = false;
boolean b_test = false;

int label = 0;
LinearRegression lReg;
Instances training;
ArrayList<Attribute> attributes;
PGraphics pg2;

void initDemo() {
  //Initiate the dataList and set the header of table
  csvData = new Table();
  csvData.addColumn("x");
  csvData.addColumn("y");
  csvData.addColumn("label");

  pg2 = createGraphics(width, height);
}

void modelEvaluation() {
  try {
    double slope = lReg.coefficients()[0];
    double intercept = lReg.coefficients()[lReg.coefficients().length-1];
    double ssr = RegressionAnalysis.calculateSSR(training, attributes.get(0), slope, intercept);
    double rSquared = RegressionAnalysis.calculateRSquared(training, ssr);
    
    Evaluation eval = new Evaluation(training);
    eval.crossValidateModel(lReg, training, 10, new Random(1)); //10-fold cross validation
    weka.core.SerializationHelper.write(dataPath("lReg.model"), lReg);
    b_train = false;
    b_test = true;
    pg2 = get2DRegLine(pg2, (Classifier)lReg, training);
    
    println(eval.toSummaryString("\nResults\n======\n", false));
    println(lReg);
    println("slope:", slope);
    for (int n=0; n<1; n++) {
      println("intercept"+n+":", lReg.coefficients()[n]);
    }
    println("ssr:", ssr);
    println("r-Square:", rSquared);
  } catch (Exception e) {
    e.printStackTrace();
  }
}

double g(float x) {
  double Y = -1;
  //println(attributes.size());
  Instance inst = new DenseInstance(2);     
  inst.setValue(training.attribute(0), (float)x); 
  // "instance" has to be associated with "Instances"
  Instances testData = new Instances("Test Data", attributes, 0);
  testData.add(inst);
  testData.setClassIndex(1);    
  try {
    // have to get the data out of Instances
    Y = lReg.classifyInstance(testData.firstInstance());
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
  return Y;
}

void saveCSV(Table csvData, String fileName) {
  //Save the table to the file folder
  saveTable(csvData, fileName); //save table as CSV file
  println("Saved as: ", fileName);
  //reset b_saveCSV;
  b_saveCSV = false;
}

void drawCSVData() {
  for (int i = 0; i < csvData.getRowCount(); i++) { 
    //read the values from the file
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    int index = (int) row.getFloat("y");

    //form a feature array
    float[] features = {x};

    //draw the data on the Canvas
    drawDataMono(index, features);
  }
}

void drawMouseMono(double _cls) {
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);
  stroke(52);
  line(mouseX,0,mouseX,height);
  if (mousePressed) {
    stroke(0);
    fill(255);
  } else { 
    noStroke();
    fill(0);
  }
  
  ellipse(mouseX, mouseY, 40, 40);

  if (mousePressed) {
    noStroke();
    fill(0);
  } else { 
    fill(255);
  }
  text((int)_cls, mouseX, mouseY);

  popStyle();
}

void drawMouseCursor(int _index) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);
  if (mousePressed) {
    stroke(0);
    fill(255);
  } else { 
    noStroke();
    fill(colors[_index]);
  }
  ellipse(mouseX, mouseY, 20, 20);

  if (mousePressed) {
    noStroke();
    fill(0);
  } else { 
    fill(255);
  }
  text(_index, mouseX, mouseY);

  popStyle();
}

void drawDataMono(int _index, float[] _features) {
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);

  stroke(0);
  fill(255);
  ellipse(_features[0], _index, 20, 20);

  noStroke();
  fill(0);
  text(_index, _features[0], _index);

  popStyle();
}

void drawDataPoint(int _index, float[] _features) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);

  stroke(0);
  fill(colors[_index]);
  ellipse(_features[0], _features[1], 20, 20);

  noStroke();
  fill(0);
  text(_index, _features[0], _features[1]);

  popStyle();
}

void initTrainingSet(Table _csvData, int _featureNum) {
  String[] attrStr = _csvData.getColumnTitles();
  attributes = new ArrayList<Attribute>();
  for (int i = 0; i < _featureNum; i++) {
    attributes.add(new Attribute(attrStr[i]));
  }
  // Make an empty training set
  training = new Instances("Train Data", attributes, _csvData.getRowCount());
  // The last element is the "class"?
  training.setClassIndex(_featureNum-1);

  for (int i = 0; i < _csvData.getRowCount(); i++) {
    //// Add training data
    Instance inst = new DenseInstance(_featureNum);
    TableRow row = csvData.getRow(i);
    for (int j = 0; j< _featureNum; j++) {
      inst.setValue(attributes.get(j), row.getFloat(attrStr[j]));
    }
    training.add(inst);
  }
}

PGraphics get2DRegLine(PGraphics pg, Classifier cls, Instances training) {
  //draw2DRegressionLine
  pg.beginDraw();
  pg.background(255);
  pg.strokeWeight(2);
  for (int x = 0; x < pg.width; x++) {
    Instance inst = new DenseInstance(2);     
    inst.setValue(training.attribute(0), (float)x);
    // "instance" has to be associated with "Instances"
    Instances testData = new Instances("Test Data", attributes, 0);
    testData.add(inst);
    testData.setClassIndex(1);        

    float classification = -1;
    try {
      // have to get the data out of Instances
      classification = (float) cls.classifyInstance(testData.firstInstance());
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    pg.stroke(0);
    pg.point(x, classification);
  }
  pg.endDraw();
  return pg;
}
