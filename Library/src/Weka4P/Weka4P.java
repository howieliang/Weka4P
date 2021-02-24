package Weka4P;

import processing.core.*;
import processing.data.Table;
import processing.data.TableRow;

import weka.core.converters.CSVLoader;

import weka.core.converters.ConverterUtils.DataSource; //https://weka.sourceforge.io/doc.stable-3-8/weka/core/converters/ConverterUtils.DataSource.html
import weka.core.Attribute; //https://weka.sourceforge.io/doc.dev/weka/core/Attribute.html
import weka.core.Instances; //https://weka.sourceforge.io/doc.dev/weka/core/Instances.html
import weka.core.DenseInstance; //https://weka.sourceforge.io/doc.dev/weka/core/DenseInstance.html
import weka.core.Instance;
import weka.classifiers.Classifier; //https://weka.sourceforge.io/doc.stable-3-8/weka/classifiers/Classifier.html
import weka.classifiers.Evaluation; //https://weka.sourceforge.io/doc.dev/weka/classifiers/Evaluation.html
import weka.classifiers.AbstractClassifier; //https://weka.sourceforge.io/doc.dev/weka/classifiers/AbstractClassifier.html
import weka.filters.Filter; //https://weka.sourceforge.io/doc.dev/weka/filters/Filter.html
import weka.filters.unsupervised.attribute.NumericToNominal; //https://weka.sourceforge.io/doc.dev/weka/filters/unsupervised/attribute/NumericToNominal.html

import java.io.File;
import java.util.ArrayList;
import java.util.Random; //https://docs.oracle.com/javase/8/docs/api/java/util/Random.html
import java.util.Enumeration;

import weka.classifiers.functions.SMO; //https://weka.sourceforge.io/doc.stable/weka/classifiers/functions/SMO.htm
import weka.classifiers.functions.SMOreg;
import weka.classifiers.functions.supportVector.RBFKernel; //https://weka.sourceforge.io/doc.dev/weka/classifiers/functions/supportVector/RBFKernel.html
import weka.classifiers.functions.supportVector.PolyKernel; //https://weka.sourceforge.io/doc.dev/weka/classifiers/functions/supportVector/PolyKernel.html
import weka.classifiers.functions.LinearRegression; //https://weka.sourceforge.io/doc.dev/weka/classifiers/functions/LinearRegression.html
import weka.classifiers.evaluation.RegressionAnalysis; //https://weka.sourceforge.io/doc.dev/weka/classifiers/evaluation/RegressionAnalysis.html
import weka.classifiers.functions.supportVector.RegSMOImproved; //https://weka.sourceforge.io/doc.dev/weka/classifiers/functions/supportVector/RegSMOImproved.html
import weka.classifiers.lazy.IBk;
import weka.classifiers.meta.AttributeSelectedClassifier; //https://weka.sourceforge.io/doc.dev/weka/classifiers/meta/AttributeSelectedClassifier.html
import weka.attributeSelection.InfoGainAttributeEval; //https://weka.sourceforge.io/doc.dev/weka/attributeSelection/InfoGainAttributeEval.html
import weka.attributeSelection.CorrelationAttributeEval;
import weka.attributeSelection.Ranker; //https://weka.sourceforge.io/doc.dev/weka/attributeSelection/Ranker.html
import weka.classifiers.functions.MultilayerPerceptron; //https://weka.sourceforge.io/doc.dev/weka/classifiers/functions/MultilayerPerceptron.html

/**
 * Main class for Weka Machine Learning library for Processing 3
 * 
 * @author Rong-Hao Liang: r.liang@tue.nl
 * @author Janet Huang: Y.C.huang@tue.nl
 * @author Wesley Hartogs: wesleyhartogs.nl
 * 
 */
public class Weka4P implements PConstants {

	// sketchParent is a reference to the parent sketch
	PApplet pa;
	public final static String VERSION = "##library.prettyVersion##";

	public DataSource source;
	public Instances train;
	public Instances test;
	public ArrayList<Attribute> attributesTrain;
	public ArrayList<Attribute> attributesTest;
	public Evaluation eval;

	public PGraphics pg;
	public Classifier cls;

	public AttributeSelectedClassifier attrSelCls;
	public CorrelationAttributeEval corrEval;
	public Ranker ranker;
	public InfoGainAttributeEval IGEval;

	public int nClassesTrain;
	public int nAttributesTrain;
	public int nInstancesTrain;
	public double accuracyTrain, weightedPrecisionTrain, weightedRecallTrain;
	public double weightedFprTrain, weightedFnrTrain, weightedFTrain;
	public double weightedMccTrain, weightedRocTrain, weightedPrcTrain;
	public double[] precisionTrain, recallTrain, tprTrain, fprTrain, fnrTrain, fTrain, mccTrain, rocTrain, prcTrain;
	public double[][] confusionMatrixTrain;
	public double maeTrain = 0;
	public double rmseTrain = 0;
	public double raeTrain = 0;
	public double rrseTrain = 0;

	public int nClassesTest;
	public int nAttributesTest;
	public int nInstancesTest;
	public double accuracyTest, weightedPrecisionTest, weightedRecallTest;
	public double weightedFprTest, weightedFnrTest, weightedFTest;
	public double weightedMccTest, weightedRocTest, weightedPrcTest;
	public double[] precisionTest, recallTest, tprTest, fprTest, fnrTest, fTest, mccTest, rocTest, prcTest;
	public double[][] confusionMatrixTest;
	public double maeTest = 0;
	public double rmseTest = 0;
	public double raeTest = 0;
	public double rrseTest = 0;

	public double slope = 0;
	public double intercept = 0;
	public double corrCoef = 0;

	public double ssr = 0;
	public double rSquared = 0;

	public String dataset = "";
	public String model = "";
	public double C = 64;
	public double gamma = 64;
	public double epsilon = 64;
	public double corrThld = 0.5;
	public double learningRate = 0.3;
	public int K = 1;
	public String hiddenLayers = "10,20,10";
	public int trainingTime = 500;
	public int fold = 5;
	public int unit = 2;
	public long timeStamp = 0;
	public long timeLapse = 0;

	public PImage[][] modelImageGrid;// = new double[numOfC][numOfGamma];
	public double[][] accuracyGrid;// = new double[numOfC][numOfGamma];
	// public double[][] timeLapseGrid;// = new double[numOfC][numOfGamma];
	public boolean showEvalDetails = true;
	public boolean isRegression = false;
	public boolean drawModels = true;

	public double[] CList;
	public double[] gammaList;
	public double[] EpsList;
	public int[] KList;

	public Instances data;
	public Instances training;
	// public IBk cls;
	public ArrayList<Attribute> attributes;

	public int colors[];

	/**
	 * Weka4P constructor. Use in setup()
	 * 
	 * @param parent the parent PApplet
	 */
	public Weka4P(PApplet parent) {
		pa = parent;
		colors = loadColors();
	}

	/**
	 *  Loads all PApplet colors to an Int array.
	 * @return int array of predefined colors
	 */
	private int[] loadColors() {

		int[] arr = { pa.color(155, 89, 182), pa.color(63, 195, 128), pa.color(214, 69, 65), pa.color(82, 179, 217),

				pa.color(244, 208, 63), pa.color(242, 121, 53), pa.color(0, 121, 53), pa.color(128, 128, 0),

				pa.color(52, 0, 128), pa.color(128, 52, 0), pa.color(52, 128, 0), pa.color(128, 52, 0) };
		return arr;

		// return { }

	}

	/**
	 * return the version of the Library.
	 * 
	 * @return String Version
	 */
	public static String version() {
		return VERSION;
	}


	/**
	 * 
	 * @param filename filename of ARFF file in the data folder
	 * @return instances from the ARFF file
	 */
	public Instances loadTrainARFFToInstances(String filename) {
		Instances insts;
		try {
			source = new DataSource(pa.dataPath(filename));
			insts = source.getDataSet();
			insts.setClassIndex(insts.numAttributes() - 1);
			nClassesTrain = insts.numClasses();
			nAttributesTrain = insts.numAttributes();
			nInstancesTrain = insts.numInstances();
			// attrs = new ArrayList<Attribute>();
			// for (int i = 0; i < nAttributesTrain; i++) {
			// attrs.add(insts.attribute(i));
			// }
			PApplet.println("===");
			PApplet.println("Data set: " + filename);
			PApplet.println("Attributes: " + insts.numAttributes());
			PApplet.println("Instances: " + insts.numInstances());
			PApplet.println("Classes: " + insts.numClasses());
			PApplet.println("Name: " + insts.classAttribute().toString());
			return insts;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
			return null;
		}
	}

	/**
	 * 	Loads attributes form instances
	 * 
	 * @param _insts instances
	 * @return Attributes ArrayList
	 */
	public ArrayList<Attribute> loadAttributesFromInstances(Instances _insts) {
		ArrayList<Attribute> attrs;
		try {
			attrs = new ArrayList<Attribute>();
			for (int i = 0; i < nAttributesTrain; i++) {
				attrs.add(_insts.attribute(i));
			}
			return attrs;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
			return null;
		}
	}

	/**
	 * Loads ARFF file into public train variable
	 * 
	 * @param filename filename of ARFF file in the data folder
	 */
	public void loadTrainARFF(String filename) {
		try {
			source = new DataSource(pa.dataPath(filename));
			train = source.getDataSet();
			train.setClassIndex(train.numAttributes() - 1);
			nClassesTrain = train.numClasses();
			nAttributesTrain = train.numAttributes();
			nInstancesTrain = train.numInstances();

			attributesTrain = new ArrayList<Attribute>();
			for (int i = 0; i < nAttributesTrain; i++) {
				attributesTrain.add(train.attribute(i));
			}
			PApplet.println("===");
			PApplet.println("Train set: " + filename);
			PApplet.println("Attributes: " + nAttributesTrain);
			PApplet.println("Instances: " + nInstancesTrain);
			PApplet.println("Classes: " + nClassesTrain);
			PApplet.println("Name: " + train.classAttribute().toString());
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Loads ARFF file into public test variable
	 * 
	 * @param filename filename of ARFF file in the data folder
	 */
	public void loadTestARFF(String filename) {
		try {
			source = new DataSource(pa.dataPath(filename));
			test = source.getDataSet();
			test.setClassIndex(test.numAttributes() - 1);
			nClassesTest = test.numClasses();
			nAttributesTest = test.numAttributes();
			nInstancesTest = test.numInstances();

			attributesTest = new ArrayList<Attribute>();
			for (int i = 0; i < nAttributesTest; i++) {
				attributesTest.add(test.attribute(i));
			}
			PApplet.println("===");
			PApplet.println("Test set: " + filename);
			PApplet.println("Attributes: " + nAttributesTest);
			PApplet.println("Instances: " + nInstancesTest);
			PApplet.println("Classes: " + nClassesTest);
			PApplet.println("Name: " + test.classAttribute().toString());
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Loads nominal CSV file into global train variable
	 * @param _filename CSV file in data folder
	 */
	public void loadCSV(String _filename) {
		try {
			readCSVNominal(_filename);
			nClassesTrain = train.numClasses();
			nAttributesTrain = train.numAttributes();
			nInstancesTrain = train.numInstances();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	/**
	 * Loads numeric CSV file into global train variable
	 * @param _filename CSV file in data folder
	 */
	public void loadCSVNumeric(String _filename) {
		Table _csvData = pa.loadTable(_filename, "header");
		String[] attrStr = _csvData.getColumnTitles();
		int attrNum = attrStr.length;
		attributesTrain = new ArrayList<Attribute>();
		for (int i = 0; i < attrStr.length; i++) {
			attributesTrain.add(new Attribute(attrStr[i]));
		}
		// Make an empty training set
		train = new Instances("Train Data", attributesTrain, _csvData.getRowCount());
		// The last element is the "class"?
		train.setClassIndex(attrNum - 1);

		for (int i = 0; i < _csvData.getRowCount(); i++) {
			// Add training data
			Instance inst = new DenseInstance(attrNum);
			TableRow row = _csvData.getRow(i);
			for (int j = 0; j < attrNum; j++) {
				inst.setValue(attributesTrain.get(j), row.getFloat(attrStr[j]));
			}
			train.add(inst);
		}
	}

	/**
	 * Combines classifier with filename to save a model
	 * @param _filename
	 */
	public void saveModel(String _filename) {
		saveClassifier(cls, _filename);
	}

	/**
	 * Combines classifier with filename to save a model
	 * @param _filename
	 */
	public void saveSVC(String _filename) {
		saveModel(_filename);
	}

	/**
	 * Saves a model to specified file
	 * 
	 * @param _cls classifier
	 * @param _filename intended filename for model file.
	 */
	public void saveClassifier(Classifier _cls, String _filename) {
		try {
			weka.core.SerializationHelper.write(pa.dataPath(_filename), _cls);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// /**
	//  * 
	//  * @param _features
	//  * @param _attributes
	//  * @return probability of 
	//  */
	// public double[] getProbability(float[] _features, ArrayList<Attribute> _attributes) {
	// 	double[] prob = new double[nClassesTrain];
	// 	try {
	// 		Instances test = new Instances("Test Data", _attributes, 0);
	// 		test.setClassIndex(_attributes.size() - 1);
	// 		Instance instance = new DenseInstance(_attributes.size());
	// 		for (int i = 0; i < _features.length; i++) {
	// 			instance.setValue(_attributes.get(i), _features[i]);
	// 		}
	// 		instance.setDataset(test);
	// 		prob = cls.distributionForInstance(instance);
	// 		double maxP = 0;
	// 		for (int i = 0; i < prob.length; i++) {
	// 			maxP = (prob[i] > maxP ? prob[i] : maxP);
	// 		}
	// 		for (int i = 0; i < prob.length; i++) {
	// 			prob[i] = prob[i] /= maxP;
	// 		}
	// 	} catch (Exception ex) {
	// 		ex.printStackTrace();
	// 	}
	// 	return prob;
	// }

	/**
	 * Gets the prediction index from public test data, uses public attributesTrain
	 * 
	 * @param _features
	 * @return prediction index
	 */
	public double getPredictionIndex(float[] _features) {
		double _pred = -1;
		try {
			Instances test = new Instances("Test Data", attributesTrain, 0);
			test.setClassIndex(attributesTrain.size() - 1);
			Instance instance = new DenseInstance(attributesTrain.size());
			for (int i = 0; i < _features.length; i++) {
				instance.setValue(attributesTrain.get(i), _features[i]);
			}
			instance.setDataset(test);
			_pred = cls.classifyInstance(instance);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return _pred;
	}

	/**
	 * Gets the prediction index from public test data, with specified classifier and attributes
	 * 
	 * @param _features
	 * @param _cls
	 * @param _attrs
	 * @return prediction index
	 */
	public double getPredictionIndex(float[] _features, Classifier _cls, ArrayList<Attribute> _attrs) {
		double _pred = -1;
		try {
			Instances test = new Instances("Test Data", _attrs, 0);
			test.setClassIndex(_attrs.size() - 1);
			Instance instance = new DenseInstance(_attrs.size());
			for (int i = 0; i < _features.length; i++) {
				instance.setValue(_attrs.get(i), _features[i]);
			}
			instance.setDataset(test);
			_pred = _cls.classifyInstance(instance);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return _pred;
	}

	/**
	 * Gets the prediction index from public test data, with specified classifier, uses public attributesTrain
	 * 
	 * @param _features
	 * @param _cls
	 * @return prediction index
	 */
	public double getPredictionIndex(float[] _features, Classifier _cls) {
		double _pred = -1;
		try {
			Instances test = new Instances("Test Data", attributesTrain, 0);
			test.setClassIndex(attributesTrain.size() - 1);
			Instance instance = new DenseInstance(attributesTrain.size());
			for (int i = 0; i < _features.length; i++) {
				instance.setValue(attributesTrain.get(i), _features[i]);
			}
			instance.setDataset(test);
			_pred = _cls.classifyInstance(instance);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return _pred;
	}


	/**
	 * Gets the label of the prediction
	 * 
	 * @param _features
	 * @param _cls
	 * @param _attrs
	 * @param _insts
	 * @return label of the prediction
	 */
	public String getPrediction(float[] _features, Classifier _cls, ArrayList<Attribute> _attrs, Instances _insts) {
		String label = "";
		try {
			Instances test = new Instances("Test Data", _attrs, 0);
			test.setClassIndex(_attrs.size() - 1);
			Instance instance = new DenseInstance(_attrs.size());
			for (int i = 0; i < _features.length; i++) {
				instance.setValue(_attrs.get(i), _features[i]);
			}
			instance.setDataset(test);
			int _pred = (int) _cls.classifyInstance(instance);
			label = _insts.classAttribute().value(_pred);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return label;
	}


	/**
	 * Gets the label of the prediction, with specified classifier
	 * 
	 * @param _features
	 * @param _cls
	 * @return label of the prediction
	 */
	public String getPrediction(float[] _features, Classifier _cls) {
		String label = "";
		try {
			Instances test = new Instances("Test Data", attributesTrain, 0);
			test.setClassIndex(attributesTrain.size() - 1);
			Instance instance = new DenseInstance(attributesTrain.size());
			for (int i = 0; i < _features.length; i++) {
				instance.setValue(attributesTrain.get(i), _features[i]);
			}
			instance.setDataset(test);
			int _pred = (int) _cls.classifyInstance(instance);
			label = train.classAttribute().value(_pred);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return label;
	}

	/**
	 * Gets the label of the prediction from features array
	 * 
	 * @param _features
	 * @return label of the prediction
	 */
	public String getPrediction(float[] _features) {
		String label = "";
		try {
			Instances test = new Instances("Test Data", attributesTrain, 0);
			test.setClassIndex(attributesTrain.size() - 1);
			Instance instance = new DenseInstance(attributesTrain.size());
			for (int i = 0; i < _features.length; i++) {
				instance.setValue(attributesTrain.get(i), _features[i]);
			}
			instance.setDataset(test);
			int _pred = (int) cls.classifyInstance(instance);
			label = train.classAttribute().value(_pred);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return label;
	}


	/**
	 * Loads model file and loads into public cls variable
	 * @param fileName filename of model file in data folder
	 */
	public void loadModel(String fileName) {
		try {
			cls = (Classifier) weka.core.SerializationHelper.read(pa.dataPath(fileName));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

/** 
 * Loads model into classifier
 * @param fileName
 * @return classifier from model file
 */
	public Classifier loadModelToClassifier(String fileName) {
		Classifier _cls;
		try {
			_cls = (Classifier) weka.core.SerializationHelper.read(pa.dataPath(fileName));
			return _cls;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	/**
	 * Evaluates test set and prints results
	 * 
	 * @param _cls
	 * @param _insts
	 * @param _isRegression
	 * @param _showEvalDetails
	 */
	public void evaluateTestSet(Classifier _cls, Instances _insts, boolean _isRegression, boolean _showEvalDetails) {
		showEvalDetails = _showEvalDetails;
		try {
			eval = new Evaluation(_insts);
			eval.evaluateModel(_cls, _insts);
			if (_isRegression) {
				corrCoef = eval.correlationCoefficient();
				maeTest = eval.meanAbsoluteError();
				rmseTest = eval.rootMeanSquaredError();
				raeTest = eval.relativeAbsoluteError();
				rrseTest = eval.rootRelativeSquaredError();

				if (showEvalDetails) {
					PApplet.println(_cls);
					PApplet.println(eval.toSummaryString("\nResults\n======\n", false));
				}
			} else if (!_isRegression) {
				if (showEvalDetails) {
					PApplet.println(_cls);
					PApplet.println(eval.toSummaryString("\nResults\n======\n", false));
					PApplet.println(eval.toMatrixString());
					PApplet.println(eval.toClassDetailsString());
				}
				accuracyTest = eval.pctCorrect();
				maeTest = eval.meanAbsoluteError();
				rmseTest = eval.rootMeanSquaredError();
				raeTest = eval.relativeAbsoluteError();
				rrseTest = eval.rootRelativeSquaredError();
				weightedPrecisionTest = eval.weightedPrecision();
				weightedRecallTest = eval.weightedRecall();
				weightedFprTest = eval.weightedFalsePositiveRate();
				weightedFnrTest = eval.weightedFalseNegativeRate();
				weightedFTest = eval.weightedFMeasure();
				weightedMccTest = eval.weightedMatthewsCorrelation();
				weightedRocTest = eval.weightedAreaUnderROC();
				weightedPrcTest = eval.weightedAreaUnderPRC();

				confusionMatrixTest = eval.confusionMatrix();

				precisionTest = new double[nClassesTest];
				recallTest = new double[nClassesTest];
				tprTest = new double[nClassesTest];
				fprTest = new double[nClassesTest];
				fnrTest = new double[nClassesTest];
				fTest = new double[nClassesTest];
				rocTest = new double[nClassesTest];
				prcTest = new double[nClassesTest];
				mccTest = new double[nClassesTest];
				for (int i = 0; i < nClassesTest; i++) {
					precisionTest[i] = eval.precision(i);
					recallTest[i] = eval.recall(i);
					fnrTest[i] = eval.falseNegativeRate(i);
					fprTest[i] = eval.falsePositiveRate(i);
					tprTest[i] = eval.truePositiveRate(i);
					fTest[i] = eval.fMeasure(i);
					rocTest[i] = eval.areaUnderROC(i);
					prcTest[i] = eval.areaUnderPRC(i);
					mccTest[i] = eval.matthewsCorrelationCoefficient(i);
				}
			}
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Evaluates test set and prints results
	 * 
	 * @param _isRegression
	 * @param _showEvalDetails
	 */
	public void evaluateTestSet(boolean _isRegression, boolean _showEvalDetails) {
		showEvalDetails = _showEvalDetails;
		try {
			eval = new Evaluation(test);
			eval.evaluateModel(cls, test);
			if (_isRegression) {
				corrCoef = eval.correlationCoefficient();
				maeTest = eval.meanAbsoluteError();
				rmseTest = eval.rootMeanSquaredError();
				raeTest = eval.relativeAbsoluteError();
				rrseTest = eval.rootRelativeSquaredError();

				LinearRegression lReg = new LinearRegression();
				lReg.buildClassifier(train);
				slope = lReg.coefficients()[0];
				intercept = lReg.coefficients()[lReg.coefficients().length - 1];
				ssr = RegressionAnalysis.calculateSSR(train, attributesTrain.get(0), slope, intercept);
				rSquared = RegressionAnalysis.calculateRSquared(train, ssr);
				if (showEvalDetails) {
					PApplet.println(eval.toSummaryString("\nResults\n======\n", false));
					PApplet.println(lReg);
					for (int n = 0; n < train.numAttributes() - 1; n++) {
						PApplet.println("slope (" + train.attribute(n).name() + "):", lReg.coefficients()[n]);
					}
					PApplet.println("intercept:", lReg.coefficients()[lReg.coefficients().length - 1]);
					PApplet.println("ssr:", ssr);
					PApplet.println("r-Square:", rSquared);
				}
			} else if (!_isRegression) {
				if (showEvalDetails) {
					PApplet.println(eval.toSummaryString("\nResults\n======\n", false));
					PApplet.println(eval.toMatrixString());
					PApplet.println(eval.toClassDetailsString());
				}
				accuracyTest = eval.pctCorrect();
				maeTest = eval.meanAbsoluteError();
				rmseTest = eval.rootMeanSquaredError();
				raeTest = eval.relativeAbsoluteError();
				rrseTest = eval.rootRelativeSquaredError();
				weightedPrecisionTest = eval.weightedPrecision();
				weightedRecallTest = eval.weightedRecall();
				weightedFprTest = eval.weightedFalsePositiveRate();
				weightedFnrTest = eval.weightedFalseNegativeRate();
				weightedFTest = eval.weightedFMeasure();
				weightedMccTest = eval.weightedMatthewsCorrelation();
				weightedRocTest = eval.weightedAreaUnderROC();
				weightedPrcTest = eval.weightedAreaUnderPRC();

				confusionMatrixTest = eval.confusionMatrix();

				precisionTest = new double[nClassesTest];
				recallTest = new double[nClassesTest];
				tprTest = new double[nClassesTest];
				fprTest = new double[nClassesTest];
				fnrTest = new double[nClassesTest];
				fTest = new double[nClassesTest];
				rocTest = new double[nClassesTest];
				prcTest = new double[nClassesTest];
				mccTest = new double[nClassesTest];
				for (int i = 0; i < nClassesTest; i++) {
					precisionTest[i] = eval.precision(i);
					recallTest[i] = eval.recall(i);
					fnrTest[i] = eval.falseNegativeRate(i);
					fprTest[i] = eval.falsePositiveRate(i);
					tprTest[i] = eval.truePositiveRate(i);
					fTest[i] = eval.fMeasure(i);
					rocTest[i] = eval.areaUnderROC(i);
					prcTest[i] = eval.areaUnderPRC(i);
					mccTest[i] = eval.matthewsCorrelationCoefficient(i);
				}
			}
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Evaluates training set and prints results
	 * 
	 * @param _isRegression
	 * @param _showEvalDetails
	 */
	public void evaluateTrainSet(int _fold, boolean _isRegression, boolean _showEvalDetails) {
		showEvalDetails = _showEvalDetails;
		try {
			eval = new Evaluation(train);
			eval.crossValidateModel(cls, train, _fold, new Random(1)); // 10-fold cross validation
			if (_isRegression) {
				corrCoef = eval.correlationCoefficient();
				maeTrain = eval.meanAbsoluteError();
				rmseTrain = eval.rootMeanSquaredError();
				raeTrain = eval.relativeAbsoluteError();
				rrseTrain = eval.rootRelativeSquaredError();

				LinearRegression lReg = new LinearRegression();
				lReg.buildClassifier(train);
				slope = lReg.coefficients()[0];
				intercept = lReg.coefficients()[lReg.coefficients().length - 1];
				ssr = RegressionAnalysis.calculateSSR(train, attributesTrain.get(0), slope, intercept);
				rSquared = RegressionAnalysis.calculateRSquared(train, ssr);
				if (showEvalDetails) {
					PApplet.println(eval.toSummaryString("\nResults\n======\n", false));
					PApplet.println(lReg);
					for (int n = 0; n < train.numAttributes() - 1; n++) {
						PApplet.println("slope (" + train.attribute(n).name() + "):", lReg.coefficients()[n]);
					}
					PApplet.println("intercept:", lReg.coefficients()[lReg.coefficients().length - 1]);
					PApplet.println("ssr:", ssr);
					PApplet.println("r-Square:", rSquared);
				}
			} else if (!_isRegression) {
				if (showEvalDetails) {
					PApplet.println(eval.toSummaryString("\nResults\n======\n", false));
					PApplet.println(eval.toMatrixString());
					PApplet.println(eval.toClassDetailsString());
				}
				accuracyTrain = eval.pctCorrect();
				maeTrain = eval.meanAbsoluteError();
				rmseTrain = eval.rootMeanSquaredError();
				raeTrain = eval.relativeAbsoluteError();
				rrseTrain = eval.rootRelativeSquaredError();

				weightedPrecisionTrain = eval.weightedPrecision();
				weightedRecallTrain = eval.weightedRecall();
				weightedFprTrain = eval.weightedFalsePositiveRate();
				weightedFnrTrain = eval.weightedFalseNegativeRate();
				weightedFTrain = eval.weightedFMeasure();
				weightedMccTrain = eval.weightedMatthewsCorrelation();
				weightedRocTrain = eval.weightedAreaUnderROC();
				weightedPrcTrain = eval.weightedAreaUnderPRC();

				confusionMatrixTrain = eval.confusionMatrix();

				precisionTrain = new double[nClassesTrain];
				recallTrain = new double[nClassesTrain];
				tprTrain = new double[nClassesTrain];
				fprTrain = new double[nClassesTrain];
				fnrTrain = new double[nClassesTrain];
				fTrain = new double[nClassesTrain];
				rocTrain = new double[nClassesTrain];
				prcTrain = new double[nClassesTrain];
				mccTrain = new double[nClassesTrain];
				for (int i = 0; i < nClassesTrain; i++) {
					precisionTrain[i] = eval.precision(i);
					recallTrain[i] = eval.recall(i);
					fnrTrain[i] = eval.falseNegativeRate(i);
					fprTrain[i] = eval.falsePositiveRate(i);
					tprTrain[i] = eval.truePositiveRate(i);
					fTrain[i] = eval.fMeasure(i);
					rocTrain[i] = eval.areaUnderROC(i);
					prcTrain[i] = eval.areaUnderPRC(i);
					mccTrain[i] = eval.matthewsCorrelationCoefficient(i);
				}
			}
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Ranks Linear Suport Vector
	 * and prints the result
	 * @param C
	 */
	public void rankAttrLSVC(double C) {
		attrSelCls = new AttributeSelectedClassifier();
		corrEval = new CorrelationAttributeEval();
		ranker = new Ranker();
		try {
			cls = new SMO();
			((SMO) cls).setC(C);
			attrSelCls.setClassifier(cls);
			attrSelCls.setSearch(ranker);
			attrSelCls.setEvaluator(corrEval);
			attrSelCls.buildClassifier(train);
			double[][] ra = ranker.rankedAttributes();
			PApplet.println("Rank\tIndex\tAttrName\tValue");
			for (int i = 0; i < ra.length; i++) {
				int index = (int) ra[i][0];
				PApplet.print(i + 1);
				PApplet.print('\t');
				PApplet.print(index);
				PApplet.print('\t');
				PApplet.print(train.attribute(index).name());
				PApplet.print('\t');
				PApplet.print(ra[i][1]);
				PApplet.println();
			}
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Trains a Multilayer Perceptron
	 * Saves it to public cls variable
	 * 
	 * @param _hiddenLayers
	 * @param _trainingTime
	 * @param _learningRate
	 */
	public void trainMLP(String _hiddenLayers, int _trainingTime, double _learningRate) {
		try {
			cls = new MultilayerPerceptron();
			((MultilayerPerceptron) cls).setGUI(false); // visualization network
			((MultilayerPerceptron) cls).setHiddenLayers(_hiddenLayers); // network structure
			((MultilayerPerceptron) cls).setTrainingTime(_trainingTime); // network structure
			((MultilayerPerceptron) cls).setLearningRate(_learningRate);
			((MultilayerPerceptron) cls).setSeed(pa.millis());
			timeStamp = pa.millis();
			PApplet.println("\n=== Training: Multi-layer Perceptron [", _hiddenLayers, "], training time =",
					_trainingTime);
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Trains a Multilayer Perceptron
	 * Saves it to public cls variable
	 * 
	 * @param _hiddenLayers
	 * @param _trainingTime
	 */
	public void trainMLP(String _hiddenLayers, int _trainingTime) {
		try {
			cls = new MultilayerPerceptron();
			((MultilayerPerceptron) cls).setGUI(false); // visualization network
			((MultilayerPerceptron) cls).setHiddenLayers(_hiddenLayers); // network structure
			((MultilayerPerceptron) cls).setTrainingTime(_trainingTime); // network structure
			((MultilayerPerceptron) cls).setSeed(pa.millis());
			timeStamp = pa.millis();
			PApplet.println("\n=== Training: Multi-layer Perceptron [", _hiddenLayers, "], training time =",
					_trainingTime);
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Trains Linear Regression and saves it into public cls variable
	 */
	public void trainLinearRegression() {
		try {
			cls = new LinearRegression();
			PApplet.println("\n=== Training: Linear Regression");
			timeStamp = pa.millis();
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Trains K-nearest Neighbors
	 * saves it into public cls 
	 * @param K
	 */
	public void trainKNN(int K) {
		// PolyKernel poly;
		try {
			cls = new IBk(K); // IBk(int k): kNN classifier.
			PApplet.println("\n=== Training: KNN ( K =", K, ")");
			timeStamp = pa.millis();
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Searches for K in array
	 * @param _KList array of K's to search for
	 */
	public void KSearch(int[] _KList) {
		KList = _KList;
		accuracyGrid = new double[_KList.length][1];
		modelImageGrid = new PImage[_KList.length][1];
		for (int c = 0; c < _KList.length; c++) {
			trainKNN(K = _KList[c]);
			evaluateTrainSet(fold = 5, isRegression = false, showEvalDetails = false); // 5-fold cross validation
			setModelDrawing(unit = PApplet.ceil(PApplet.sqrt(_KList.length)) * 2); // set the model visualization (for
																					// 2D features)
			modelImageGrid[c][0] = pg.get();
			accuracyGrid[c][0] = accuracyTrain;
			PApplet.println(fold + "-fold CV Accuracy:", PApplet.nf((float) accuracyTrain, 0, 2), "%\n");
		}
	}

	/**
	 * Draws a visualization of the K model at specified location
	 * 
	 * @param x x coordinate
	 * @param y y coordinate
	 * @param w width
	 * @param h height
	 */
	public void drawKSearchModels(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.translate(x, y);
		float N = PApplet.ceil(PApplet.sqrt((float) KList.length));
		float W = w / N;
		for (int c = 0; c < KList.length; c++) {
			float X = c % N * W;
			float Y = PApplet.floor(c / N) * W;
			PImage p = modelImageGrid[c][0];
			p.resize((int) W, (int) W);
			pa.image(p, X, Y);
		}
		pa.popStyle();
		pa.popMatrix();
	}

	/**
	 * Draws results of the K model at specified location in text
	 * 
	 * @param x x coordinate
	 * @param y y coordinate
	 * @param w width
	 * @param h height
	 */
	public void drawKSearchResults(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.translate(x, y);
		pa.textSize(32);
		float N = PApplet.ceil(PApplet.sqrt((float) KList.length));
		float W = w / N;
		for (int c = 0; c < KList.length; c++) {
			float X = c % N * W;
			float Y = PApplet.floor(c / N) * W;
			String s = "K=" + KList[c] + "\n" + PApplet.nf((float) accuracyGrid[c][0], 0, 2) + "%";
			pa.fill(255);
			pa.text(s, X + 10, Y + 32);
		}
		pa.popStyle();
		pa.popMatrix();
	}



	/**
	 * Trains a Linear Support Vector Regression
	 * @param epsilon
	 */
	public void trainLinearSVR(double epsilon) {
		RegSMOImproved rsi;
		try {
			cls = new SMOreg();
			rsi = new RegSMOImproved();
			rsi.setTolerance(epsilon);
			((SMOreg) cls).setC(C);
			((SMOreg) cls).setRegOptimizer(rsi);
			timeStamp = pa.millis();
			PApplet.println("\n=== Training: Linear SVR ( C =", C, ", epsilon =", epsilon, ")");
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}


	public void trainRBFSVR(double epsilon, double gamma) {
		RBFKernel rbf;
		RegSMOImproved rsi;
		try {
			cls = new SMOreg();
			rbf = new RBFKernel();
			rbf.setGamma(gamma);
			rsi = new RegSMOImproved();
			rsi.setTolerance(epsilon);
			((SMOreg) cls).setC(C);
			((SMOreg) cls).setKernel(rbf);
			((SMOreg) cls).setRegOptimizer(rsi);
			timeStamp = pa.millis();
			PApplet.println("\n=== Training: RBF SVR ( C =", C, ", gamma =", gamma, ", epsilon =", epsilon, ")");
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Trains a Linear Support Vector Clasifier
	 * @param C
	 */
	public void trainLinearSVC(double C) {
		PolyKernel poly;
		try {
			cls = new SMO();
			poly = new PolyKernel();
			poly.setExponent(1);
			((SMO) cls).setC(C);
			((SMO) cls).setKernel(poly);
			PApplet.println("\n=== Training: Linear SVM ( C =", C, ")");
			timeStamp = pa.millis();
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Trains a Poly Support Vector Classifier
	 * @param exp
	 * @param C
	 */
	public void trainPolySVC(int exp, double C) {
		PolyKernel poly;
		try {
			cls = new SMO();
			poly = new PolyKernel();
			poly.setExponent(exp);
			((SMO) cls).setC(C);
			((SMO) cls).setKernel(poly);
			timeStamp = pa.millis();
			PApplet.println("\n=== Training: Polynomial SVM ( C =", C, ", Exponent=", exp, ")");
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	public void trainRBFSVC(double gamma, double C) {
		RBFKernel rbf;
		try {
			cls = new SMO();
			rbf = new RBFKernel();
			rbf.setGamma(gamma);
			((SMO) cls).setC(C);
			((SMO) cls).setKernel(rbf);
			timeStamp = pa.millis();
			PApplet.println("\n=== Training: RBF SVM ( C =", C, ", gamma =", gamma, ")");
			cls.buildClassifier(train);
			timeLapse = pa.millis() - timeStamp;
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	/**
	 * Saves a Support Vector Machine
	 * @param fileName
	 */	
	public void saveSVM(String fileName) {
		try {
			weka.core.SerializationHelper.write(pa.dataPath(fileName), cls);
		} catch (java.lang.Exception e) {
			PApplet.println(e);
		}
	}

	// /**
	//  * Evaluates and prints evaluation results
	//  * 
	//  * @param ins
	//  * @param cls
	//  * @param n_fold
	//  */
	// public void printEvalResults(Instances ins, Classifier cls, int n_fold) {
	// 	try {
	// 		eval = new Evaluation(ins);
	// 		eval.crossValidateModel(cls, ins, n_fold, new Random(1)); // 10-fold cross validation
	// 		if (showEvalDetails) {
	// 			PApplet.println(eval.toSummaryString("\nResults\n======\n", false));
	// 			PApplet.println(eval.toMatrixString());
	// 			PApplet.println(eval.toClassDetailsString());
	// 		}
	// 		accuracyTrain = eval.pctCorrect();
	// 		weightedPrecisionTrain = eval.weightedPrecision();
	// 		weightedRecallTrain = eval.weightedRecall();
	// 		weightedFprTrain = eval.weightedFalsePositiveRate();
	// 		weightedFnrTrain = eval.weightedFalseNegativeRate();
	// 		weightedFTrain = eval.weightedFMeasure();
	// 		weightedMccTrain = eval.weightedMatthewsCorrelation();
	// 		weightedRocTrain = eval.weightedAreaUnderROC();
	// 		weightedPrcTrain = eval.weightedAreaUnderPRC();

	// 		confusionMatrixTrain = eval.confusionMatrix();

	// 		precisionTrain = new double[nClassesTrain];
	// 		recallTrain = new double[nClassesTrain];
	// 		tprTrain = new double[nClassesTrain];
	// 		fprTrain = new double[nClassesTrain];
	// 		fnrTrain = new double[nClassesTrain];
	// 		fTrain = new double[nClassesTrain];
	// 		rocTrain = new double[nClassesTrain];
	// 		prcTrain = new double[nClassesTrain];
	// 		mccTrain = new double[nClassesTrain];
	// 		for (int i = 0; i < nClassesTrain; i++) {
	// 			precisionTrain[i] = eval.precision(i);
	// 			recallTrain[i] = eval.recall(i);
	// 			fnrTrain[i] = eval.falseNegativeRate(i);
	// 			fprTrain[i] = eval.falsePositiveRate(i);
	// 			tprTrain[i] = eval.truePositiveRate(i);
	// 			fTrain[i] = eval.fMeasure(i);
	// 			rocTrain[i] = eval.areaUnderROC(i);
	// 			prcTrain[i] = eval.areaUnderPRC(i);
	// 			mccTrain[i] = eval.matthewsCorrelationCoefficient(i);
	// 		}
	// 	} catch (Exception e) {
	// 		e.printStackTrace();
	// 	}
	// }

	/**
	 * Set te pixel size of model drawing
	 * 
	 * @param pixelSize Unit of pixels
	 */
	public void setModelDrawing(int pixelSize) {
		if (nAttributesTrain == 3)
			pg = getModelImage(pg, cls, train, pixelSize, pixelSize);
		else
			pg = pa.createGraphics(pa.width, pa.height); // cannot show the KNN model image for now
	}

	/**
	 * Draws a model image on location
	 * 
	 * @param x
	 * @param y
	 */
	public void drawModel(int x, int y) {
		pa.pushMatrix();
		pa.translate(x, y);
		if (pg != null)
			pa.image(pg, 0, 0);
		pa.popMatrix();
	}


	/**
	 * Draws a prediction with text
	 * 
	 * @param X
	 * @param Y
	 */
	public void drawPrediction(float[] X, double Y) {
		pa.pushStyle();
		pa.textSize(12);
		pa.textAlign(LEFT, CENTER);
		pa.noStroke();
		pa.fill(255);
		pa.ellipse(X[0], X[1], 15, 15);

		pa.noStroke();
		if (Y >= 0) {
			int c = pa.lerpColor(colors[PApplet.floor((float) Y) % colors.length],
					colors[PApplet.ceil((float) Y) % colors.length], (float) Y - PApplet.floor((float) Y));
			pa.fill(c);
		}
		if (Y < 0) {
			int c = pa.lerpColor(colors[(PApplet.floor((float) Y) % colors.length + colors.length) % colors.length],
					colors[(PApplet.ceil((float) Y) % colors.length + colors.length) % colors.length],
					(float) Y - PApplet.floor((float) Y));
			pa.fill(c);
		}
		pa.ellipse(X[0], X[1], 10, 10);
		pa.fill(0);
		String label = "X = [" + X[0] + "," + X[1] + "]\nY = " + PApplet.nf((float) Y, 0, 3);
		pa.text(label, X[0] + 10, X[1]);
		pa.popStyle();
	}

	/**
	 * Draws a prediction in text
	 * 
	 * @param X
	 * @param Y
	 * @param c color
	 */
	public void drawPrediction(float[] X, double Y, int c) {
		pa.pushStyle();
		pa.textSize(12);
		pa.textAlign(LEFT, CENTER);
		pa.noStroke();
		pa.fill(255);
		pa.ellipse(X[0], X[1], 15, 15);

		pa.noStroke();
		pa.fill(c);
		pa.ellipse(X[0], X[1], 10, 10);
		pa.fill(0);
		String label = "X = [" + X[0] + "," + X[1] + "]\nY = " + PApplet.nf((float) Y, 0, 3);
		pa.text(label, X[0] + 10, X[1]);
		pa.popStyle();
	}

	/**
	 * Draws a prediction in text
	 * 
	 * @param X
	 * @param Y
	 * @param c color
	 */
	public void drawPrediction(float[] X, String Y, int c) {
		pa.pushStyle();
		pa.textSize(12);
		pa.textAlign(LEFT, CENTER);
		pa.noStroke();
		pa.fill(255);
		pa.ellipse(X[0], X[1], 15, 15);
		pa.fill(c);
		pa.ellipse(X[0], X[1], 10, 10);
		String label = "X = [" + X[0] + "," + X[1] + "]\nY = " + Y;
		pa.text(label, X[0] + 10, X[1]);
		pa.popStyle();
	}

	/**
	 * Draws a prediction in text
	 * 
	 * @param X
	 * @param Y
	 */
	public void drawPrediction(float[] X, String Y) {
		pa.pushStyle();
		pa.textSize(12);
		pa.textAlign(LEFT, CENTER);
		pa.noStroke();
		pa.fill(255);
		pa.ellipse(X[0], X[1], 15, 15);
		pa.fill(colors[train.classAttribute().indexOfValue(Y)]);
		pa.ellipse(X[0], X[1], 10, 10);
		pa.fill(0);
		String label = "X = [" + X[0] + "," + X[1] + "]\nY = " + Y;
		pa.text(label, X[0] + 10, X[1]);
		pa.popStyle();
	}

	/**
	 * Draws all data points
	 * @param db datapoint instance database
	 */
	public void drawDataPoints(Instances db) {
		pa.pushStyle();
		pa.textSize(12);
		pa.textAlign(CENTER, CENTER);

		for (int i = 0; i < db.numInstances(); i++) {
			Instance ins = db.instance(i);
			float[] X = new float[ins.numAttributes() - 1];
			for (int j = 0; j < X.length; j++) {
				X[j] = (float) ins.value(j);
			}

			pa.pushStyle();
			pa.stroke(255);
			double Y = ins.value(ins.numAttributes() - 1);
			if (Y >= 0) {
				int c = pa.lerpColor(colors[PApplet.floor((float) Y) % colors.length],
						colors[PApplet.ceil((float) Y) % colors.length], (float) Y - PApplet.floor((float) Y));
				pa.fill(c);
			}
			if (Y < 0) {
				int c = pa.lerpColor(colors[(PApplet.floor((float) Y) % colors.length + colors.length) % colors.length],
						colors[(PApplet.ceil((float) Y) % colors.length + colors.length) % colors.length],
						(float) Y - PApplet.floor((float) Y));
				pa.fill(c);
			}

			pa.ellipse(X[0], X[1], 10, 10);
			pa.fill(255);
			if (attributesTrain.get(ins.numAttributes() - 1).type() == 0) {
				String strY = "" + ins.value(ins.numAttributes() - 1);
				pa.text(strY.charAt(0), X[0], X[1]);
			} else {
				String strY = ins.stringValue(ins.numAttributes() - 1);
				pa.text(strY.charAt(0), X[0], X[1]);
			}
			pa.popStyle();
		}
	}

	/**
	 * Draws all datapoints form public train variable
	 */
	public void drawDataPoints() {
		pa.pushStyle();
		pa.textSize(12);
		pa.textAlign(CENTER, CENTER);

		for (int i = 0; i < train.numInstances(); i++) {
			Instance ins = train.instance(i);
			float[] X = new float[ins.numAttributes() - 1];
			for (int j = 0; j < X.length; j++) {
				X[j] = (float) ins.value(j);
			}

			pa.pushStyle();
			pa.stroke(255);
			double Y = ins.value(ins.numAttributes() - 1);
			if (Y >= 0) {
				int c = pa.lerpColor(colors[PApplet.floor((float) Y) % colors.length],
						colors[PApplet.ceil((float) Y) % colors.length], (float) Y - PApplet.floor((float) Y));
				pa.fill(c);
			}
			if (Y < 0) {
				int c = pa.lerpColor(colors[(PApplet.floor((float) Y) % colors.length + colors.length) % colors.length],
						colors[(PApplet.ceil((float) Y) % colors.length + colors.length) % colors.length],
						(float) Y - PApplet.floor((float) Y));
				pa.fill(c);
			}
			pa.ellipse(X[0], X[1], 10, 10);
			pa.fill(255);
			if (attributesTrain.get(ins.numAttributes() - 1).type() == 0) {
				String strY = "" + ins.value(ins.numAttributes() - 1);
				pa.text(strY.charAt(0), X[0], X[1]);
			} else {
				String strY = ins.stringValue(ins.numAttributes() - 1);
				pa.text(strY.charAt(0), X[0], X[1]);
			}
			pa.popStyle();
		}
	}

	/**
	 * Generates the model image graphic
	 * 
	 * @param pg
	 * @param cls
	 * @param training
	 * @param w
	 * @param h
	 * @return Graphic image
	 */
	public PGraphics getModelImage(PGraphics pg, Classifier cls, Instances training, int w, int h) {
		// drawModelImage
		pg = pa.createGraphics(pa.width, pa.height);
		pg.beginDraw();
		// pg.rectMode(CORNER);
		pg.background(255);
		for (int x = 0; x <= pg.width; x += w) {
			for (int y = 0; y <= pg.height; y += h) {
				Instance inst = new DenseInstance(3);
				inst.setValue(training.attribute(0), (float) x + w / 2);
				inst.setValue(training.attribute(1), (float) y + h / 2);

				// "instance" has to be associated with "Instances"
				Instances testData = new Instances("Test Data", attributesTrain, 0);
				testData.add(inst);
				testData.setClassIndex(2);

				float classification = -1;
				try {
					// have to get the data out of Instances
					classification = (float) cls.classifyInstance(testData.firstInstance());
				} catch (Exception e) {
					e.printStackTrace();
				}
				pg.noStroke();
				if (classification >= 0) {
					int c = pa.lerpColor(colors[PApplet.floor(classification) % colors.length],
							colors[PApplet.ceil(classification) % colors.length],
							classification - PApplet.floor((float) classification));
					pg.fill(c);
				}
				if (classification < 0) {
					int c = pa.lerpColor(
							colors[(PApplet.floor(classification) % colors.length + colors.length) % colors.length],
							colors[(PApplet.ceil(classification) % colors.length + colors.length) % colors.length],
							classification - PApplet.floor((float) classification));
					pg.fill(c);
				}
				pg.rect(x, y, w, h);
			}
		}
		pg.endDraw();
		return pg;
	}

	/**
	 * Searches for C of a Linear Support Vector Classifier
	 * @param _CList array of C's
	 */
	public void CSearchLSVC(double[] _CList) {
		CList = _CList;
		accuracyGrid = new double[_CList.length][1];
		modelImageGrid = new PImage[_CList.length][1];
		for (int c = 0; c < _CList.length; c++) {
			trainLinearSVC(C = _CList[c]);
			evaluateTrainSet(fold = 5, isRegression = false, showEvalDetails = false); // 5-fold cross validation
			setModelDrawing(unit = PApplet.ceil(PApplet.sqrt(_CList.length)) * 2); // set the model visualization (for
																					// 2D features)
			modelImageGrid[c][0] = pg.get();
			accuracyGrid[c][0] = accuracyTrain;
			PApplet.println(fold + "-fold CV Accuracy:", PApplet.nf((float) accuracyTrain, 0, 2), "%\n");
		}
	}

	/**
	 * Searches for Epsilon for a Linear Suport Vector Regressor
	 * @param _EpsList
	 */
	public void EpsSearchLSVR(double[] _EpsList) {
		EpsList = _EpsList;
		accuracyGrid = new double[_EpsList.length][1];
		modelImageGrid = new PImage[_EpsList.length][1];
		for (int c = 0; c < _EpsList.length; c++) {
			trainLinearSVR(epsilon = _EpsList[c]);
			evaluateTrainSet(fold = 5, isRegression = true, showEvalDetails = false); // 5-fold cross validation
			setModelDrawing(unit = PApplet.ceil(PApplet.sqrt(_EpsList.length)) * 2); // set the model visualization (for
																						// 2D features)
			modelImageGrid[c][0] = pg.get();
			accuracyGrid[c][0] = rmseTrain;
			PApplet.println(fold + "-fold CV Accuracy:", PApplet.nf((float) accuracyTrain, 0, 2), "%\n");
		}
	}

	/**
	 * Draws a graphic representation of C list
	 * 
	 * @param x
	 * @param y
	 * @param w
	 * @param h
	 */
	public void drawCSearchModels(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.translate(x, y);
		float N = PApplet.ceil(PApplet.sqrt((float) CList.length));
		float W = w / N;
		for (int c = 0; c < CList.length; c++) {
			float X = c % N * W;
			float Y = PApplet.floor(c / N) * W;
			PImage p = modelImageGrid[c][0];
			p.resize((int) W, (int) W);
			pa.image(p, X, Y);
		}
		pa.popStyle();
		pa.popMatrix();
	}

	/**
	 * Draws the C search results from CList in text
	 * 
	 * @param x
	 * @param y
	 * @param w
	 * @param h
	 */
	public void drawCSearchResults(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.translate(x, y);
		pa.textSize(32);
		float N = PApplet.ceil(PApplet.sqrt((float) CList.length));
		float W = w / N;
		for (int c = 0; c < CList.length; c++) {
			float X = c % N * W;
			float Y = PApplet.floor(c / N) * W;
			String s = "C=" + CList[c] + "\n" + PApplet.nf((float) accuracyGrid[c][0], 0, 2) + "%";
			pa.fill(255);
			pa.text(s, X + 10, Y + 32);
		}
		pa.popStyle();
		pa.popMatrix();
	}

	/**
	 * Draws the graphic representation of the Epsilon search from EpsList
	 * 
	 * @param x
	 * @param y
	 * @param w
	 * @param h
	 */
	public void drawEpsSearchModels(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.translate(x, y);
		float N = PApplet.ceil(PApplet.sqrt((float) EpsList.length));
		float W = w / N;
		for (int c = 0; c < EpsList.length; c++) {
			float X = c % N * W;
			float Y = PApplet.floor(c / N) * W;
			PImage p = modelImageGrid[c][0];
			p.resize((int) W, (int) W);
			pa.image(p, X, Y);
		}
		pa.popStyle();
		pa.popMatrix();
	}

	/**
	 * Draws the Epsilon Search results in text from Epslist
	 * @param x
	 * @param y
	 * @param w
	 * @param h
	 */
	public void drawEpsSearchResults(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.translate(x, y);
		pa.textSize(32);
		float N = PApplet.ceil(PApplet.sqrt((float) EpsList.length));
		float W = w / N;
		for (int c = 0; c < EpsList.length; c++) {
			float X = c % N * W;
			float Y = PApplet.floor(c / N) * W;
			String s = "e=" + PApplet.nf((float) EpsList[c], 0, 4) + "\n"
					+ PApplet.nf((float) accuracyGrid[c][0], 0, 2);
			pa.fill(255);
			pa.text(s, X + 10, Y + 32);
		}
		pa.popStyle();
		pa.popMatrix();
	}


/**
 * 
 * 
 * @param _EpsList Epsilon array to search for
 * @param _gammaList gamme array to search for
 */
	public void gridSearchSVR_RBF(double[] _EpsList, double[] _gammaList) {
		EpsList = _EpsList;
		gammaList = _gammaList;
		accuracyGrid = new double[_EpsList.length][_gammaList.length];
		modelImageGrid = new PImage[_EpsList.length][_gammaList.length];
		for (int g = 0; g < _gammaList.length; g++) {
			for (int c = 0; c < _EpsList.length; c++) {
				trainRBFSVR(epsilon = _EpsList[c], gamma = _gammaList[g]);
				evaluateTrainSet(fold = 5, isRegression = true, showEvalDetails = false); // 5-fold cross validation
				setModelDrawing(unit = _gammaList.length * 2); // set the model visualization (for 2D features)
				modelImageGrid[c][g] = pg.get();
				accuracyGrid[c][g] = rmseTrain;
				PApplet.println(fold + "-fold CV Accuracy:", PApplet.nf((float) accuracyTrain, 0, 2), "%\n");
			}
		}
	}

	/**
	 * 
	 * @param _CList C array to search for
	 * @param _gammaList Gamma array to search for
	 */
	public void gridSearchSVC_RBF(double[] _CList, double[] _gammaList) {
		CList = _CList;
		gammaList = _gammaList;
		accuracyGrid = new double[_CList.length][_gammaList.length];
		modelImageGrid = new PImage[_CList.length][_gammaList.length];
		for (int g = 0; g < _gammaList.length; g++) {
			for (int c = 0; c < _CList.length; c++) {
				trainRBFSVC(gamma = _gammaList[g], C = _CList[c]);
				evaluateTrainSet(fold = 5, isRegression = false, showEvalDetails = false); // 5-fold cross validation
				setModelDrawing(unit = _gammaList.length * 2); // set the model visualization (for 2D features)
				modelImageGrid[c][g] = pg.get();
				accuracyGrid[c][g] = accuracyTrain;
				PApplet.println(fold + "-fold CV Accuracy:", PApplet.nf((float) accuracyTrain, 0, 2), "%\n");
			}
		}
	}

	/**
	 * Draws graphic represatations of the grid search, uses the CList and gammaList
	 * 
	 * @param x
	 * @param y
	 * @param w
	 * @param h
	 */
	public void drawGridSearchModels(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.translate(x, y);
		float W = w / (float) CList.length;
		float H = h / (float) gammaList.length;
		for (int g = 0; g < gammaList.length; g++) {
			for (int c = 0; c < CList.length; c++) {
				float X = c * W;
				float Y = g * H;
				PImage p = modelImageGrid[c][g];
				p.resize((int) W, (int) H);
				pa.image(p, X, Y);
			}
		}
		pa.popStyle();
		pa.popMatrix();
	}

	/**
	 * Draws graphical representation of grid search model of sthe Support Vector Regression
	 * Uses EpsList and gammaList
	 * 
	 * @param x
	 * @param y
	 * @param w
	 * @param h
	 */
	public void drawGridSearchModels_SVR(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.translate(x, y);
		float W = w / (float) EpsList.length;
		float H = h / (float) gammaList.length;
		for (int g = 0; g < gammaList.length; g++) {
			for (int c = 0; c < EpsList.length; c++) {
				float X = c * W;
				float Y = g * H;
				PImage p = modelImageGrid[c][g];
				p.resize((int) W, (int) H);
				pa.image(p, X, Y);
			}
		}
		pa.popStyle();
		pa.popMatrix();
	}


	/**
	 * Draws the grid search results of the Support Vector Regression in text
	 * 
	 * @param x
	 * @param y
	 * @param w
	 * @param h
	 */
	public void drawGridSearchResults_SVR(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.textSize(32);
		pa.translate(x, y);
		float W = w / (float) EpsList.length;
		float H = h / (float) gammaList.length;
		for (int g = 0; g < gammaList.length; g++) {
			for (int c = 0; c < EpsList.length; c++) {
				float X = c * W;
				float Y = g * H;
				String s = "e=" + PApplet.nf((float) EpsList[c], 0, 4) + "\nG=" + gammaList[g] + "\n"
						+ PApplet.nf((float) accuracyGrid[c][g], 0, 2);
				pa.fill(255);
				pa.text(s, X + 10, Y + 32);
			}
		}
		pa.popStyle();
		pa.popMatrix();
	}

	/**
	 * Draws the grid search results 
	 *	uses Clist and gammaList
	 *
	 * @param x
	 * @param y
	 * @param w
	 * @param h
	 */
	public void drawGridSearchResults(float x, float y, float w, float h) {
		pa.pushMatrix();
		pa.pushStyle();
		pa.textSize(32);
		pa.translate(x, y);
		float W = w / (float) CList.length;
		float H = h / (float) gammaList.length;
		for (int g = 0; g < gammaList.length; g++) {
			for (int c = 0; c < CList.length; c++) {
				float X = c * W;
				float Y = g * H;
				String s = "C=" + CList[c] + "\nG=" + gammaList[g] + "\n" + PApplet.nf((float) accuracyGrid[c][g], 0, 2)
						+ "%";
				pa.fill(255);
				pa.text(s, X + 10, Y + 32);
			}
		}
		pa.popStyle();
		pa.popMatrix();
	}

	/**
	 * Reads the CSV file with nominal values
	 * 
	 * @param fileName filenmae of CSV file in data folder
	 * @throws Exception
	 */
	public void readCSVNominal(String fileName) throws Exception {
		CSVLoader loader = new CSVLoader();
		Instances data;
		int index = pa.loadTable(fileName, "header").getColumnCount() - 1;
		// loader.setNoHeaderRowPresent(true);
		loader.setSource(new File(pa.dataPath(fileName)));
		data = loader.getDataSet();
		data.setClassIndex(index);

		NumericToNominal convert = new NumericToNominal();
		// String[] options= new String[2];
		// options[0]="-R";
		// options[1]=""+(index+1); //range of variables to make numeric
		int[] val = { index };
		try {
			// have to get the data out of Instances
			// convert.setOptions(options);
			convert.setAttributeIndicesArray(val);
			convert.setInputFormat(data);
			train = Filter.useFilter(data, convert);
		} catch (Exception e) {
			e.printStackTrace();
		}

		PApplet.println("Attributes : " + train.numAttributes());
		PApplet.println("Instances : " + train.numInstances());
		PApplet.println("Name : " + train.classAttribute().toString());

		attributesTrain = new ArrayList<Attribute>();
		for (int i = 0; i < train.numAttributes(); i++) {
			attributesTrain.add(new Attribute(train.attribute(i).name()));
		}

		train.setClassIndex(index);
	}

}
