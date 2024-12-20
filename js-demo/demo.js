"use strict";

const VALID_MOVE_REGEX =
  /^Move *\( *-?[0-9]+(\.[0-9]+)? *, *-?[0-9]+(\.[0-9]+)? *\)$/;

window.onload = function () {
  recreate();

  document.getElementById("code").oninput = recreate;
  document.getElementById("iters").oninput = recreate;
  document.getElementById("bg-color").oninput = recreate;
  document.getElementById("stroke-color").oninput = recreate;
  document.getElementById("stroke-width").oninput = recreate;
};

function recreate() {
  const dimension = Math.min(
    document.getElementById("canvas").offsetWidth,
    document.getElementById("canvas").offsetHeight
  );

  const moves = document
    .getElementById("code")
    .value.trim()
    .split("\n")
    .map((s) => s.trim());

  const iters = Math.min(document.getElementById("iters").value, 20); // > 20 seems to cause some problems (exponential growth!)
  const strokeWidth = document.getElementById("stroke-width").value;
  const strokeColor = document.getElementById("stroke-color").value;
  const bgColor = document.getElementById("bg-color").value;

  if (moves.length > 0 && moves.every((line) => VALID_MOVE_REGEX.test(line))) {
    createDragonCurve(
      moves,
      iters,
      strokeWidth,
      strokeColor,
      bgColor,
      dimension
    );
    document.getElementById("p5-js-code").innerHTML = movesToJs(
      moves,
      iters,
      strokeColor,
      bgColor,
      dimension
    );

    document.getElementById("p5-js-code").removeAttribute("data-highlighted");
    hljs.highlightAll(); // re-run highlighter
  } else {
    document.getElementById("errors").innerHTML =
      "<p><strong>Error: invalid syntax.</strong></p>";
  }
}

function createDragonCurve(
  moves,
  iters,
  strokeWidth,
  strokeColor,
  bgColor,
  dimension
) {
  document.getElementById("canvas").innerHTML = "";
  document.getElementById("errors").innerHTML = "";

  const sketch = (p) => {
    class Move {
      constructor(startXDir, startYDir) {
        this.xDir = startXDir;
        this.yDir = startYDir;
      }

      rotated() {
        return new Move(-this.yDir, this.xDir);
      }
    }

    function drawCurve(curve, color, startX, startY) {
      let currentX = startX;
      let currentY = startY;

      for (let i = 0; i < curve.length; i++) {
        let oldX = currentX;
        let oldY = currentY;

        currentX += curve[i].xDir;
        currentY += curve[i].yDir;

        p.stroke(color);
        p.strokeWeight(strokeWidth);
        p.line(oldX, oldY, currentX, currentY);
      }
    }

    function doubleAndRotate(curve) {
      for (let i = curve.length - 1; i >= 0; i--) {
        curve.push(curve[i].rotated());
      }
    }

    p.setup = function () {
      p.createCanvas(dimension, dimension);
      p.background(bgColor);

      const dragonCurve = [];

      moves.forEach((move) => {
        dragonCurve.push(eval("new " + move));
      });

      for (let i = 0; i < iters; i++) {
        doubleAndRotate(dragonCurve);
      }

      drawCurve(dragonCurve, strokeColor, dimension / 2, dimension / 2);
    };
  };

  new p5(sketch, document.getElementById("canvas"));
}

function movesToJs(moves, iters, strokeColor, bgColor, dimension) {
  return `// Generated for p5.js v1.11.1; try pasting this code in the sandbox! https://editor.p5js.org/
// this function is part of processing's structure.
// see: https://p5js.org/reference/p5/setup/
function setup() {
  // general processing setup
  createCanvas(${dimension}, ${dimension}); // change these numbers to have a different width and height
  background("${bgColor}");  // change this for a new background color!

  const strokeColor = "${strokeColor}";     // change this for a new line color!

  // set up our initial moves; change these to change the shape of your curve!
  const dragonCurve = [
    ${moves.map((move) => "new " + move).join(",\n    ")}
  ];

  // double and rotate for a set number of times (in this case, ${iters})
  for (let i = 0; i < ${iters}; i++) {
    doubleAndRotate(dragonCurve);
  }

  // draw our final curve!
  drawCurve(dragonCurve, strokeColor, ${dimension / 2}, ${dimension / 2});
}

// this class stores one "move". strictly speaking, you can think of this
// as a vector: it expresses a change in x, and a change in y.
// the "rotated" method returns a new version that's rotated 90 degrees.
class Move {
  constructor(startXDir, startYDir) {
    this.xDir = startXDir;
    this.yDir = startYDir;
  }

  rotated() {
    return new Move(-this.yDir, this.xDir);
  }
}

// this function implements our "double, pinch, and rotate" rule. pretty neat!
function doubleAndRotate(curve) {
  for (let i = curve.length - 1; i >= 0; i--) {
    curve.push(curve[i].rotated());
  }
}

// this function draws the curve. it's not the most efficient way to do so,
// but does it step-by-step (tracing through the curves one by one)!
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
`;
}
