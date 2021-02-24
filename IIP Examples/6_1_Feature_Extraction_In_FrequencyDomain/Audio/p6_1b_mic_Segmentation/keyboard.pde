void keyPressed() {
  if (key == 'A' || key == 'a') {
    energyThld = min(energyThld+5, 100);
  }
  if (key == 'Z' || key == 'z') {
    energyThld = max(energyThld-5, 10);
  }
}
