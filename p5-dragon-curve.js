// requires p5.js (last tested on: v1.11.1)
function setup() {
  const redDragonCurve = [];
  const greenDragonCurve = [];
  const blueDragonCurve = [];
  const purpleDragonCurve = [];

  createCanvas(750, 750);

  redDragonCurve.push(new Move(5, 0));
  redDragonCurve.push(new Move(0, 5));
  greenDragonCurve.push(new Move(0, 5));
  greenDragonCurve.push(new Move(-5, 0));
  blueDragonCurve.push(new Move(-5, 0));
  blueDragonCurve.push(new Move(0, -5));
  purpleDragonCurve.push(new Move(0, -5));
  purpleDragonCurve.push(new Move(5, 0));

  for (let i = 0; i < 15; i++) {
    doubleAndRotate(redDragonCurve);
    doubleAndRotate(greenDragonCurve);
    doubleAndRotate(blueDragonCurve);
    doubleAndRotate(purpleDragonCurve);
  }

  background(200);

  drawCurve(redDragonCurve, "red", 375, 375);
  drawCurve(greenDragonCurve, "green", 375, 375);
  drawCurve(blueDragonCurve, "blue", 375, 375);
  drawCurve(purpleDragonCurve, "purple", 375, 375);
}

function drawCurve(curve, color, startX, startY) {
  let currentX = startX;
  let currentY = startY;

  for (let i = 0; i < curve.length; i++) {
    let oldX = currentX;
    let oldY = currentY;

    currentX += curve[i].xDir;
    currentY += curve[i].yDir;

    stroke(color);
    line(oldX, oldY, currentX, currentY);
  }
}

function doubleAndRotate(curve) {
  for (let i = curve.length - 1; i >= 0; i--) {
    curve.push(curve[i].rotated());
  }
}

class Move {
  constructor(startXDir, startYDir) {
    this.xDir = startXDir;
    this.yDir = startYDir;
  }

  rotated() {
    return new Move(-this.yDir, this.xDir);
  }
}
