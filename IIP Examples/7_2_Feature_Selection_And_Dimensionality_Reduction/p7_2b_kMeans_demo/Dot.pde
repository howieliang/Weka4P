class Dot {
  PVector loc;
  color c;
  int group;

  Dot(PVector loc) {
    this.loc = loc;
    c = color(random(255), random(255), random(255));
  }

  Dot() {
  }


  void update() {
  }

  void setColor(color c) {
    this.c = c;
  }

  void setGroup(int g) {
    group = g;
  }

  color getColor() {
    return c;
  }

  int getGroup() {
    return group;
  }

  void draw(int size) {
    int circleSize = size;
    pushMatrix();
    translate(loc.x, loc.y);
    fill(c);
    ellipse(0, 0, circleSize, circleSize);
    popMatrix();
  }
}
