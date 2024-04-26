//Creates perfectly fitted dragon curves of different colors

ArrayList<Move> redDragonCurve=new ArrayList<Move>();
ArrayList<Move> greenDragonCurve=new ArrayList<Move>();
ArrayList<Move> blueDragonCurve=new ArrayList<Move>();
ArrayList<Move> purpleDragonCurve=new ArrayList<Move>();


//True if a mouse button was pressed while no other button was.
boolean firstMousePress = false;
HScrollbar hs1, hs2;  // Two scrollbars

void setup() {
  size(750, 750);
  redDragonCurve.add(new Move(5, 0));
  redDragonCurve.add(new Move(0, 5));
  greenDragonCurve.add(new Move(0,5));
  greenDragonCurve.add(new Move(-5,0));
  blueDragonCurve.add(new Move(-5,0));
  blueDragonCurve.add(new Move(0,-5));
  purpleDragonCurve.add(new Move(0,-5));
  purpleDragonCurve.add(new Move(5,0));
  strokeWeight(1.0);

  for (int i=0; i<17; i++) {
    doubledragon();
  }
  
  hs1 = new HScrollbar(0, height/2-8, width, 16, 16);
  hs2 = new HScrollbar(0, height/2+8, width, 16, 16);  
}

void draw() {
   //draws all the moves
  float redX=width/2;
  float redY=height/2;
  float blueX=width/2;
  float blueY=height/2;
  float greenX=width/2;
  float greenY=height/2;
  float purpleX=width/2;
  float purpleY=height/2;
  for (int i = 0; i < redDragonCurve.size(); i++) {
    float oldRedX = redX;
    float oldRedY = redY;
    float oldBlueX = blueX;
    float oldBlueY = blueY;
    float oldGreenX = greenX;
    float oldGreenY = greenY;
    float oldPurpleX = purpleX;
    float oldPurpleY = purpleY;
    redX = redX + redDragonCurve.get(i).xdir;
    redY = redY + redDragonCurve.get(i).ydir;
    blueX = blueX + greenDragonCurve.get(i).xdir;
    blueY = blueY + greenDragonCurve.get(i).ydir;
    greenX = greenX + blueDragonCurve.get(i).xdir;
    greenY = greenY + blueDragonCurve.get(i).ydir;
    purpleX = purpleX + purpleDragonCurve.get(i).xdir;
    purpleY = purpleY + purpleDragonCurve.get(i).ydir;
    stroke(#FC0000); //red
    line(oldRedX, oldRedY, redX, redY);
    stroke(#64FC00); //green
    line(oldBlueX, oldBlueY, blueX, blueY);
    stroke(#00BBFC); //blue
    line(oldGreenX, oldGreenY, greenX, greenY);
    stroke(#8A00FC); //purple
    line(oldPurpleX, oldPurpleY, purpleX, purpleY);
  }
  
  hs1.update();
  hs2.update();
  hs1.display();
  hs2.display();
  
  //After it has been used in the sketch, set it back to false
  if (firstMousePress) {
    firstMousePress = false;
  }
}

void doubledragon() {
  //go through list backwards
  for (int i=redDragonCurve.size() - 1; i>=0; i--) {
    Move current = redDragonCurve.get(i);
    redDragonCurve.add(current.rotated());
  }
  for (int i=greenDragonCurve.size() - 1; i>=0; i--) {
    Move current = greenDragonCurve.get(i);
    greenDragonCurve.add(current.rotated());
    
  }
  for (int i=blueDragonCurve.size() - 1; i>=0; i--) {
    Move current = blueDragonCurve.get(i);
    blueDragonCurve.add(current.rotated());
  }
  for (int i=purpleDragonCurve.size() - 1; i>=0; i--) {
    Move current = purpleDragonCurve.get(i);
    purpleDragonCurve.add(current.rotated());
    
  }
}

class Move {
  float xdir;
  float ydir;

  Move(float startxdir, float startydir) {
    xdir=startxdir;
    ydir=startydir;
  }

  Move rotated() {
    return new Move(-ydir, xdir);
  }
}


void mousePressed() {
  if (!firstMousePress) {
    firstMousePress = true;
  }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (firstMousePress && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
