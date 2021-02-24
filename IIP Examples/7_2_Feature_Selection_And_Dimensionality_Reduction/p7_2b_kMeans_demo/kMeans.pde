
ArrayList <Dot> dots;
ArrayList <Dot> clusters;

int numClusters = 3;
int numDots = 1000;

int iterations = 0;

boolean bUpdate = false;
boolean bStable = false;

int[] tempNumGroup = new int[numClusters];

void resetData() {
  dots = new ArrayList<Dot>();
  for (int i = 0; i < numDots; i++) {
    PVector loc = new PVector(random(width), random(height));
    dots.add(new Dot(loc) );
  }

  clusters = new ArrayList<Dot>();
  for (int i = 0; i < numClusters; i++) {
    PVector loc = new PVector(random(width), random(height));
    clusters.add(new Dot(loc) );
  }
}
