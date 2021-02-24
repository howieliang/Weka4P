import de.voidplus.leapmotion.*;

LeapMotion leap;

void setup(){
  size(1280, 480);
  background(255);
  leap = new LeapMotion(this);
}

void draw(){
  background(255);if (leap.hasImages()) {
    for (Image camera : leap.getImages()) {
      if (camera.isLeft()) {
        // Left camera
        image(camera, 0, 0);
      } else {
        // Right camera
        image(camera, camera.getWidth(), 0);
      }
    }
  }

}
