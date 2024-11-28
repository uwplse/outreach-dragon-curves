"use strict";

const VALID_MOVE_REGEX =
  /^Move *\( *[0-9]+(\.[0-9]+)? *, * [0-9]+(\.[0-9]+)? *\)$/;

window.onload = function () {
  recreate();

  document.getElementById("code").oninput = recreate;
  document.getElementById("iters").oninput = recreate;
  document.getElementById("bg-color").oninput = recreate;
  document.getElementById("stroke-color").oninput = recreate;
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
  const iters = document.getElementById("iters").value;
  const strokeColor = document.getElementById("stroke-color").value;
  const bgColor = document.getElementById("bg-color").value;

  if (moves.length > 0 && moves.every((line) => VALID_MOVE_REGEX.test(line))) {
    createDragonCurve(moves, iters, strokeColor, bgColor, dimension);
  } else {
    document.getElementById("errors").innerHTML =
      "<p><strong>Error: invalid syntax.</strong></p>";
  }
}

function createDragonCurve(moves, iters, strokeColor, bgColor, dimension) {
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
