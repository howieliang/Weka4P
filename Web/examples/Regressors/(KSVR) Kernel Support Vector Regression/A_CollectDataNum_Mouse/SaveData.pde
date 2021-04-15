/* Save the generated data */
void saveData() {
  //Save the table to the file folder
  saveCSV(dataSetName, csvData);
  saveARFF(dataSetName, csvData);
}


/* Saves the Table data to a .csv file in the data folder */
void saveCSV(String dataSetName, Table csvData) {
  saveTable(csvData, dataPath(dataSetName+".csv")); //save table as CSV file
  println("Saved as: ", dataSetName+".csv");
}

/* Converts the Table data to ARFF format and saves a .arff file in the data folder */
void saveARFF(String dataSetName, Table csvData) {
  String[] attrNames = csvData.getColumnTitles();
  int[] attrTypes = csvData.getColumnTypes();
  int lineCount = 1 + attrNames.length + 1 + (csvData.getRowCount()); //@relation + @attribute + @data + CSV
  String[] text = new String[lineCount];

  text[0] = "@relation "+dataSetName;

  for (int i = 0; i < attrNames.length; i++) {
    String s = "";
    ArrayList<String> dict = new ArrayList<String>();
    s += "@attribute "+attrNames[i];
    if (attrTypes[i]==0) {
      for (int j = 0; j < csvData.getRowCount(); j++) {
        TableRow row = csvData.getRow(j);
        String l = row.getString(attrNames[i]);
        boolean found = false;
        for (String d : dict) {
          if (d.equals(l)) found = true;
        }
        if (!found) dict.add(l);
      }
      s += " {";
      for (int n=0; n<dict.size(); n++) {
        s += dict.get(n);
        if (n != dict.size()-1) s += ",";
      }
      s += "}";
    } else s+=" numeric";
    text[1+i] = s;
  }

  text[1+attrNames.length] = "@data";

  for (int i = 0; i < csvData.getRowCount(); i++) {
    String s = "";
    TableRow row = csvData.getRow(i);
    for (int j = 0; j < attrNames.length; j++) {
      if (attrTypes[j]==0) s += row.getString(attrNames[j]);
      else s += row.getFloat(attrNames[j]);
      if (j!=attrNames.length-1) s +=",";
    }
    text[2+attrNames.length+i] = s;
  }

  saveStrings(dataPath(dataSetName+".arff"), text);
  println("Saved as: ", dataSetName+".arff");
}

/* Converts an interger to a char */
/* 0 = A, 1 = B, and so forth */
String getCharFromInteger(double i) { 
  return ""+char(min((int)(i+'A'), 90));
}
