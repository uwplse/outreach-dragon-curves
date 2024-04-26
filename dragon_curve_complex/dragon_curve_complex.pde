//Creates perfectly fitted dragon curves of different colors




//True if a mouse button was pressed while no other button was.
boolean firstMousePress = false;
HScrollbar hs1, hs2, hs3;  // Two scrollbars

void setup() {
  size(750, 750);
  
  strokeWeight(1.0);

  
  
  hs1 = new HScrollbar(0, height-75, width, 16, 16);
  hs2 = new HScrollbar(0, height-50, width, 16, 16);
  hs3 = new HScrollbar(0, height-25, width, 16, 16);
}

float sliderPos(HScrollbar slider) {
   return  ((slider.getPos()-(width/2))*10/width);
}

void draw() {
  background(200, 200, 200);
  ArrayList<Move> redDragonCurve=new ArrayList<Move>();
  ArrayList<Move> greenDragonCurve=new ArrayList<Move>();
  ArrayList<Move> blueDragonCurve=new ArrayList<Move>();
  ArrayList<Move> purpleDragonCurve=new ArrayList<Move>();
  redDragonCurve.add(new Move(5+sliderPos(hs1), 0));
  redDragonCurve.add(new Move(0, 5 + sliderPos(hs2)));
  redDragonCurve.add(new Move(0 + sliderPos(hs3), 0 + sliderPos(hs3)));
  //greenDragonCurve.add(new Move(0,5));
  //greenDragonCurve.add(new Move(-5,0));
  //blueDragonCurve.add(new Move(-5,0));
  //blueDragonCurve.add(new Move(0,-5));
  //purpleDragonCurve.add(new Move(0,-5));
  //purpleDragonCurve.add(new Move(5,0));
  
  for (int i=0; i<16; i++) {
    doubledragon(redDragonCurve);
  }
  
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
    redX = redX + redDragonCurve.get(i).xdir;
    redY = redY + redDragonCurve.get(i).ydir;
    stroke(#FC0000); //red
    line(oldRedX, oldRedY, redX, redY);
 
  }
  
  hs1.update();
  hs2.update();
  hs3.update();
  hs1.display();
  hs2.display();
  hs3.display();
  
  //After it has been used in the sketch, set it back to false
  if (firstMousePress) {
    firstMousePress = false;
  }
}

void doubledragon(ArrayList<Move> array) {
  //go through list backwards
  for (int i=array.size() - 1; i>=0; i--) {
    Move current = array.get(i);
    array.add(current.rotated());
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
