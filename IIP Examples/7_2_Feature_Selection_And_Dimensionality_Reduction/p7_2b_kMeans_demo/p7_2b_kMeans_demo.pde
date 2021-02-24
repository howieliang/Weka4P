//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

void setup() {
  size(800, 600);
  background(0);
  resetData();
}

void draw() {
  if (bUpdate) {
    //caculateDistance
    for (int i = 0; i < dots.size(); i++) {
      Dot dot = dots.get(i);
      PVector dis = PVector.sub(dot.loc, clusters.get(0).loc);
      float min = dis.mag();
      for (int j = 0; j < clusters.size(); j++) {
        Dot cluster = clusters.get(j);  
        float disX = dot.loc.x - cluster.loc.x;
        float disY = dot.loc.y - cluster.loc.y;
        float distance = sqrt( sq(disX) + sq(disY) );
        if (distance <= min) {
          dot.setGroup(j);
          dot.setColor(cluster.c);
          min = distance;
        }
      }
    }

    //centroid
    PVector[] centroid = new PVector[clusters.size()];
    for (int j = 0; j < clusters.size(); j++) {
      centroid[j] = new PVector(0, 0, 0);
    }
    int[] numGroup = new int[clusters.size()];

    for (int i = 0; i < dots.size(); i++) {
      Dot dot = dots.get(i);
      int count = 0;
      for (int j = 0; j < clusters.size(); j++) {
        if (dot.getGroup() == j) {
          centroid[j].add(dot.loc); 
          numGroup[j]++;
        }
      }
    }
    
    println(numGroup);
    for (int j = 0; j < clusters.size(); j++) {
      Dot cluster = clusters.get(j);
      centroid[j].div(numGroup[j]);
      if (cluster.loc != centroid[j]) {
        cluster.loc = centroid[j];
      }
    }
    ++iterations;
    bUpdate = false;
  }
  
  background(0);
  for (int i = 0; i < clusters.size(); i++) {
    Dot cluster = clusters.get(i);
    cluster.draw(25);
  }
  for (int i = 0; i < dots.size(); i++) {
    Dot dot = dots.get(i);
    dot.draw(10);
  }
  
  pushStyle();
  fill(255);
  textSize(24);
  text("[SPACE]: next iter  [ENTER]: reset", 100, 50);
  textSize(48);
  text("Iteration #"+iterations, 100, 100);
  popStyle();
}
