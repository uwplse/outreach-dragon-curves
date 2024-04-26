//Creates perfectly fitted dragon curves of different colors

ArrayList<Move> redDragonCurve=new ArrayList<Move>();
ArrayList<Move> greenDragonCurve=new ArrayList<Move>();
ArrayList<Move> blueDragonCurve=new ArrayList<Move>();
ArrayList<Move> purpleDragonCurve=new ArrayList<Move>();

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
