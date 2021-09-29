let canvas;
let ctx;
let canvasWidth = 1200;
let canvasHeight = 700;
let keys = [];
let ship;
let speed = 0.1;
let bullets = [];
let asteroids = [];
let score = 0;
let lives = 3;

document.addEventListener("DOMContentLoaded", SetupCanvas);

function SetupCanvas() {
  canvas = document.getElementById("my-canvas");
  ctx = canvas.getContext("2d");
  canvas.width = canvasWidth;
  canvas.height = canvasHeight;
  ctx.fillStyle = "black";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ship = new Ship();
  for (let i = 0; i < 8; i++) {
    asteroids.push(new Asteroid());
  }

  // For handling multiple keystrokes
  document.body.addEventListener("keydown", function (e) {
    keys[e.key] = true;

    if (e.key === "p") {
      console.log(bullets.length);
    }
  });
  document.body.addEventListener("keyup", function (e) {
    keys[e.key] = false;
    if (e.key === " ") {
      bullets.push(new Bullet(ship.angle));
    }
  });
  Render();
}

class Ship {
  constructor() {
    this.visible = true;
    this.x = canvasWidth / 2;
    this.y = canvasHeight / 2;
    this.movingForward = false;
    this.speed = speed;
    this.velX = 0;
    this.velY = 0;
    this.rotateSpeed = 0.001;
    this.radius = 15;
    this.angle = 0;
    this.strokeColor = "#FFF";
    this.noseX = canvasWidth / 2 + this.radius;
    this.noseY = canvasHeight / 2;
  }
  Rotate(dir) {
    this.angle += this.rotateSpeed * dir;
  }
  Update() {
    let radians = calcRadians(this.angle);
    if (this.movingForward) {
      this.velX += Math.cos(radians) * this.speed;
      this.velY += Math.sin(radians) * this.speed;
    }
    if (this.x < this.radius) {
      this.x = canvas.width;
    }
    if (this.x > canvas.width) {
      this.x = this.radius;
    }
    if (this.y < this.radius) {
      this.y = canvas.height;
    }
    if (this.y > canvas.height) {
      this.y = this.radius;
    }
    this.velX *= 0.99;
    this.velY *= 0.99; // friction
    this.x -= this.velX;
    this.y -= this.velY; // movement
  }
  Draw() {
    ctx.strokeStyle = this.strokeColor;
    ctx.beginPath();
    let vertAngle = (Math.PI * 2) / 3;
    let radians = calcRadians(this.angle);
    this.noseX = this.x - this.radius * Math.cos(radians);
    this.noseY = this.y - this.radius * Math.sin(radians);
    for (let i = 0; i < 3; i++) {
      ctx.lineTo(
        this.x - this.radius * Math.cos(vertAngle * i + radians),
        this.y - this.radius * Math.sin(vertAngle * i + radians)
      );
    }
    ctx.closePath();
    ctx.stroke();
  }
}

class Bullet {
  constructor(angle) {
    this.speed = 6;
    this.visible = true;
    this.x = ship.noseX;
    this.y = ship.noseY;
    this.angle = angle;
    this.height = 4; // 4*4 sized bullets
    this.width = 4;
    this.velX = 0;
    this.velY = 0;
  }
  Update() {
    let radians = calcRadians(this.angle);
    this.x -= Math.cos(radians) * this.speed;
    this.y -= Math.sin(radians) * this.speed;
  }
  Draw() {
    ctx.fillStyle = "white";
    ctx.fillRect(this.x, this.y, this.width, this.height);
    // console.log("Being drawn");
  }
}
class Asteroid {
  constructor(x, y, radius, level, collisionRadius, speed) {
    this.visible = true;
    this.x = x || Math.floor(Math.random() * canvasWidth);
    this.y = y || Math.floor(Math.random() * canvasWidth);
    // console.log(this.x, this.y);
    this.speed = speed || 4;
    this.radius = radius || 50;
    this.angle = Math.floor(Math.random() * 359);
    this.strokeColor = "white";
    this.collisionRadius = collisionRadius || 46;
    this.level = level || 1;
  }
  Update() {
    let radians = calcRadians(this.angle);
    this.x += Math.cos(radians) * this.speed;
    this.y += Math.sin(radians) * this.speed;
    if (this.x < this.radius) {
      this.x = canvas.width;
    }
    if (this.x > canvas.width) {
      this.x = this.radius;
    }
    if (this.y < this.radius) {
      this.y = canvas.height;
    }
    if (this.y > canvas.height) {
      this.y = this.radius;
    }
  }
  Draw() {
    ctx.beginPath();
    let vertAngle = (Math.PI * 2) / 6;
    let radians = calcRadians(this.angle);
    for (let i = 0; i < 6; i++) {
      ctx.lineTo(
        this.x - this.radius * Math.cos(vertAngle * i + radians),
        this.y - this.radius * Math.sin(vertAngle * i + radians)
      );
    }
    ctx.closePath();
    ctx.stroke();
  }
}

function CircleCollision(p1x, p1y, r1, p2x, p2y, r2) {
  let radiusSum;
  let xDiff = p1x - p2x;
  let yDiff = p1y - p2y;
  radiusSum = r1 + r2;
  if (radiusSum > Math.sqrt(xDiff * xDiff + yDiff * yDiff)) {
    return true;
  } else {
    return false;
  }
}

function DrawLifeShips() {
  let startX = 1350;
  let startY = 10;
  let points = [
    [9, 9],
    [-9, 9],
  ];
  ctx.strokeStyle = "white";
  for (let i = 0; i < lives; i++) {
    ctx.beginPath();
    ctx.moveTo(startX, startY);
    for (let j = 0; j < points.length; j++) {
      ctx.lineTo(startX + points[j][0], startY + points[j][1]);
    }
    ctx.closePath();
    ctx.stroke();
    startX -= 30;
  }
}

function Render() {
  // W-key
  ship.movingForward = keys["w"];

  if (keys["d"]) {
    // D-key
    ship.Rotate(1);
  }
  if (keys["a"]) {
    // A-key
    ship.Rotate(-1);
  }
  ctx.clearRect(0, 0, canvasWidth, canvasHeight);

  // Text on screen
  ctx.fillStyle = "white";
  ctx.font = "21px Arial";
  ctx.fillText(`SCORE: ${score}`, 20, 35);

  if (ship.visible) {
    ctx.fillStyle = "white";
    ctx.font = "21px Arial";
    ctx.fillText(`LIVES: ${lives}`, canvasWidth - 120, 35);
  }

  if (lives <= 0) {
    ship.visible = false;
    ctx.fillStyle = "white";
    ctx.font = "150px Arial";
    ctx.fillText("GAME OVER", canvasWidth / 2 - 450, canvasHeight / 2 + 50);
  }
  DrawLifeShips();

  if (asteroids.length !== 0 && ship.visible) {
    for (let k = 0; k < asteroids.length; k++) {
      if (
        CircleCollision(
          ship.x,
          ship.y,
          11,
          asteroids[k].x,
          asteroids[k].y,
          asteroids[k].collisionRadius
        )
      ) {
        ship.x = canvasWidth / 2;
        ship.y = canvasHeight / 2;
        ship.velX = 0;
        ship.velY = 0;
        lives -= 1;
        asteroids = [];
        for (let i = 0; i < 8; i++) {
          asteroids.push(new Asteroid());
        }
      }
    }
  }

  if (asteroids.length !== 0 && bullets.length !== 0 && ship.visible) {
    // Using labels to break from deep loops
    loop1: for (let l = 0; l < asteroids.length; l++) {
      for (let m = 0; m < bullets.length; m++) {
        if (
          CircleCollision(
            bullets[m].x,
            bullets[m].y,
            3,
            asteroids[l].x,
            asteroids[l].y,
            asteroids[l].collisionRadius
          )
        ) {
          if (asteroids[l].level === 1) {
            asteroids.push(
              new Asteroid(asteroids[l].x - 5, asteroids[l].y - 5, 25, 2, 22, 3)
            );
            asteroids.push(
              new Asteroid(asteroids[l].x + 5, asteroids[l].y + 5, 25, 2, 22, 3)
            );
          } else if (asteroids[l].level === 2) {
            asteroids.push(
              new Asteroid(asteroids[l].x - 3, asteroids[l].y - 3, 12, 3, 10, 1)
            );
            asteroids.push(
              new Asteroid(asteroids[l].x + 3, asteroids[l].y + 3, 12, 3, 10, 1)
            );
          }
          // deleting the asteroid that got hit.
          asteroids.splice(l, 1);
          bullets.splice(m, 1);
          score += 5;
          break loop1;
        }
      }
    }
  }

  // To update ship only when game is running
  if (ship.visible) {
    ship.Update();
    ship.Draw();
  }

  for (let i = 0; i < bullets.length; i++) {
    if (
      bullets[i].x > canvasWidth ||
      bullets[i].x < 0 ||
      bullets[i].y > canvasHeight ||
      bullets[i].y < 0
    ) {
      console.log("Spliced!");
      bullets.splice(i, 1);
    }
  }

  // loop to delete extra bullets and render others
  if (bullets.length > 0 && ship.visible) {
    for (let i = 0; i < bullets.length; i++) {
      bullets[i].Update();
      bullets[i].Draw();
    }
  }

  // loop to render asteroids
  if (asteroids.length > 0 && ship.visible) {
    for (let i = 0; i < asteroids.length; i++) {
      asteroids[i].Update();
      asteroids[i].Draw(i);
    }
  }
  requestAnimationFrame(Render);
}

// Helper function
function calcRadians(angle) {
  return (180 * angle) / Math.PI;
}
