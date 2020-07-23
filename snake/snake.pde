import java.util.LinkedList;
import java.util.Deque;

class Board {
  // Keep these constants in the aspect ratio of your monitor. 
  int WIDTH = 80;
  int HEIGHT = 45;
  Square[][] squares = new Square[WIDTH][HEIGHT];
  Food food;

  Board() {
    float squareHeight = width / WIDTH;
    for (int i = 0; i < WIDTH; i++) {
      for (int j = 0; j < HEIGHT; j++) {
        squares[i][j] = new Square(i * width / WIDTH, j * height / HEIGHT, squareHeight);
      }
    }
    spawnFood();
  }

  Square get(int x, int y) {
    return squares[x][y];
  }

  void spawnFood() {
    food = new Food(squares[int(random(WIDTH))][int(random(HEIGHT))]);
  }

  void draw() {
    for (int i = 0; i < WIDTH; i++) {
      for (int j = 0; j < HEIGHT; j++) {
        squares[i][j].draw();
      }
    }
    food.draw();
  }
}

class Food {
  static final int ANIMATION_DURATION = 3;
  static final color BRIGHT = #3db83b;
  static final color DARK = #40a33e;
  Square square;
  int timer;
  color currentColor = BRIGHT;

  Food(Square square) {
    this.square = square;
    timer = 0;
  }

  void draw() {
    if (timer == ANIMATION_DURATION) {
      if (currentColor == BRIGHT) {
        currentColor = DARK;
      } else {
        currentColor = BRIGHT;
      }
      timer = 0;
    }
    timer++;
    this.square.drawColor(currentColor);
  }
}

class Square {
  float x;
  float y;
  float diameter;
  boolean alive;
  static final int ON_COLOR = 200;
  static final int OFF_COLOR = 75;

  Square(float x, float y, float diameter) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
  }

  void on() {
    alive = true;
  }

  void off() {
    alive = false;
  }

  boolean isAlive() {
    return alive;
  }

  void draw() {
    if (alive) {
      drawColor(ON_COLOR);
    } else {
      drawColor(OFF_COLOR);
    }
  }

  void drawColor(color c) {
    fill(c);
    rect(x, y, diameter, diameter);
  }
}

class Snake {
  Board board;
  boolean alive = true;
  int growCount = 0;
  int headX;
  int headY;
  Deque<Square> body;
  int direction;
  Snake(int headX, int headY, Board board) {
    this.headX = headX;
    this.headY = headY;
    this.board = board;
    body = new LinkedList<Square>();
    Square head = board.get(headX, headY);
    head.on();
    body.addFirst(head);
    direction = RIGHT;
  }

  void setDirection(int direction) {
    if (!areOpposed(snake.direction, direction)) {
      this.direction = direction;
    }
  }

  void grow() {
    growCount++;
  }

  void next() {
    for (Square square: body) {
      square.off();
    }
    if (!alive) {
      return;
    }
    // Increment the location of the head if it doesn't go out of bounds
    if (direction == UP && headY-1 >= 0) {
      headY--;
    } else if (direction == DOWN && headY+1 < board.HEIGHT) {
      headY++;
    } else if (direction == RIGHT && headX+1 < board.WIDTH) {
      headX++;
    } else if (direction == LEFT && headX-1 >= 0) {
      headX--;
    } else {
      alive = false;
      return;
    }
    Square newHead = board.get(headX, headY);
    // Check to see if the snake collides with itself
    for (Square square: body) {
      if (newHead == square) {
        alive = false;
        return;
      } 
    }
    // Check to see if the snake eats the food
    if (newHead == board.food.square) {
      board.spawnFood();
      grow();
    }
    body.addFirst(newHead);
    if (growCount > 0) {
      growCount--;
    } else {
      body.removeLast();
    }
    for (Square square: body) {
      square.on();
    }
  }
}


int[] xAxisOpposites = {LEFT, RIGHT};
int[] yAxisOpposites = {UP, DOWN};
int[][] axesOpposites = {xAxisOpposites, yAxisOpposites};
boolean areOpposed(int direction, int other) {
  return areOpposed(direction, other, axesOpposites);
}

boolean areOpposed(int direction, int other, int[][] axesOpposites) {
  if (direction == other) {
    return false;
  }
  for (int[] opposites: axesOpposites){
    int total = 0;
    for (int dir: opposites) {
      if (dir == direction || dir == other) {
        total++;
      }
    }
    if (total == opposites.length) {
      return true;
    } 
  }
  return false;
}

Board board;
Snake snake;

void setup() {
  // 120 fps for smooth input 
  frameRate(120);
  fullScreen();
  board = new Board();
  snake = new Snake(1, 1, board);
  board.draw();
}

// Each draw lasts 20 frames
int timer = 0;
int frameLength = 20;
void draw() {
  timer++;
  if (timer >= frameLength) {
    timer = 0;
    snake.next();
    board.draw();
  }
}

void keyPressed() {
  if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
      snake.setDirection(keyCode);
    }
}
