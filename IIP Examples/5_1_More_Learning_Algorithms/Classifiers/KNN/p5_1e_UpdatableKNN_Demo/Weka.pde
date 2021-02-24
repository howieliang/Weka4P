import weka.core.converters.CSVLoader;
import weka.classifiers.lazy.IBk;
import weka.classifiers.Classifier;
import weka.classifiers.AbstractClassifier;
//import weka.classifiers.updateableClassifier;
import weka.core.Attribute;
import weka.core.DenseInstance;
import weka.core.Instance;
import weka.core.Instances;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.NumericToNominal;
import weka.classifiers.Evaluation;
import java.util.Random;
import java.util.Enumeration;
import java.io.File;

Instances training;
Instances data;
IBk cls; //extends AbstractClassifier implements UpdateableClassifier
ArrayList<Attribute> attributes;

void printEvalResults(String filename, int n_feature, int n_fold) {
  try {
    readCSVNominal(filename, n_feature);
    Evaluation eval = new Evaluation(training);
    eval.crossValidateModel(cls, training, n_fold, new Random(1)); //10-fold cross validation
    System.out.println(eval.toSummaryString("\nResults\n======\n", false));
    System.out.println(eval.toMatrixString());
    System.out.println(eval.toClassDetailsString());
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

void readCSVNominal(String fileName, int index) throws Exception {
  CSVLoader loader = new CSVLoader();
  //loader.setNoHeaderRowPresent(true);
  loader.setSource(new File(dataPath(fileName)));
  data = loader.getDataSet();
  data.setClassIndex(index);

  NumericToNominal convert= new NumericToNominal();
  String[] options= new String[2];
  options[0]="-R";
  options[1]=""+(index+1); //range of variables to make numeric
  try {
    // have to get the data out of Instances
    convert.setOptions(options);
    convert.setInputFormat(data);
    training=Filter.useFilter(data, convert);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }

  println("Attributes : " + training.numAttributes());
  println("Instances : " + training.numInstances());
  println("Name : " + training.classAttribute().toString());

  attributes = new ArrayList<Attribute>();
  for (int i = 0; i < training.numAttributes(); i++) {
    attributes.add(new Attribute(training.attribute(i).name()));
  }

  training.setClassIndex(index);
}

void loadCSVNominal(String fileName, int index) throws Exception {
  CSVLoader loader = new CSVLoader();
  //loader.setNoHeaderRowPresent(true);
  loader.setSource(new File(dataPath(fileName)));
  data = loader.getDataSet();
  data.setClassIndex(index);

  NumericToNominal convert= new NumericToNominal();
  String[] options= new String[2];
  options[0]="-R";
  options[1]=""+(index+1); //range of variables to make numeric
  try {
    // have to get the data out of Instances
    convert.setOptions(options);
    convert.setInputFormat(data);
    training=Filter.useFilter(data, convert);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }

  println("Attributes : " + training.numAttributes());
  println("Instances : " + training.numInstances());
  println("Name : " + training.classAttribute().toString());

  attributes = new ArrayList<Attribute>();
  for (int i = 0; i < training.numAttributes(); i++) {
    attributes.add(new Attribute(training.attribute(i).name()));
  }
}

void initTrainingSet(Table _csvData) {
  String[] attrStr = _csvData.getColumnTitles();
  int attrNum = attrStr.length;
  attributes = new ArrayList<Attribute>();
  for (int i = 0; i < attrStr.length; i++) {
    attributes.add(new Attribute(attrStr[i]));
  }
  // Make an empty training set
  training = new Instances("Train Data", attributes, _csvData.getRowCount());
  // The last element is the "class"?
  training.setClassIndex(attrNum-1);

  for (int i = 0; i < _csvData.getRowCount(); i++) {
    //// Add training data
    Instance inst = new DenseInstance(attrNum);
    TableRow row = csvData.getRow(i);
    for (int j = 0; j< attrNum; j++) {
      inst.setValue(attributes.get(j), row.getFloat(attrStr[j]));
    }
    training.add(inst);
  }
}

PGraphics getModelImage(PGraphics pg, Classifier cls, Instances training) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };
  //drawModelImage
  pg.beginDraw();
  pg.background(255);
  for (int x = 0; x < pg.width; x++) {
    for (int y = 0; y < pg.height; y++) {
      Instance inst = new DenseInstance(3);     
      inst.setValue(training.attribute(0), (float)x); 
      inst.setValue(training.attribute(1), (float)y); 

      // "instance" has to be associated with "Instances"
      Instances testData = new Instances("Test Data", attributes, 0);
      testData.add(inst);
      testData.setClassIndex(2);        
      float classification = -1;
      try {
        // have to get the data out of Instances
        classification = (float) cls.classifyInstance(testData.firstInstance());
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
      if (classification>=0) {
        pg.stroke(colors[(int)classification]);
      } else {
        pg.stroke(255);
      }
      pg.point(x, y);
    }
  }
  pg.endDraw();
  return pg;
}

PGraphics getModelImage(PGraphics pg, Classifier cls, Instances training, int w, int h) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };
  //drawModelImage
  pg.beginDraw();
  pg.rectMode(CENTER);
  pg.background(255);
  for (int x = 0; x <= pg.width; x+=w) {
    for (int y = 0; y <= pg.height; y+=h) {
      Instance inst = new DenseInstance(3);     
      inst.setValue(training.attribute(0), (float)x); 
      inst.setValue(training.attribute(1), (float)y); 

      // "instance" has to be associated with "Instances"
      Instances testData = new Instances("Test Data", attributes, 0);
      testData.add(inst);
      testData.setClassIndex(2);        

      float classification = -1;
      try {
        // have to get the data out of Instances
        classification = (float) cls.classifyInstance(testData.firstInstance());
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
      pg.noStroke();
      if (classification>=0) {
        pg.fill(colors[(int)classification]);
      } else {
        pg.fill(255);
      }
      pg.rect(x, y, w, h);
    }
  }
  pg.endDraw();
  return pg;
}
