class Board {
  // Keep these constants in the aspect ratio of your monitor. 
  int WIDTH = 80;
  int HEIGHT = 45;
  Cell[][] cells = new Cell[WIDTH][HEIGHT];

  Board() {
    float squareHeight = width / WIDTH;
    for (int i = 0; i < WIDTH; i++) {
      for (int j = 0; j < HEIGHT; j++) {
        cells[i][j] = new Cell(i * width / WIDTH, j * height / HEIGHT, squareHeight);
      }
    }
  }

  ArrayList < Cell > getNeighbors(int x, int y) {
    ArrayList < Cell > neighbors = new ArrayList < Cell > ();
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        // Skip if out of bounds or referencing the target cell
        if (i >= WIDTH || j >= HEIGHT || i < 0 || j < 0 || (i == x && j == y)) {
          continue;
        }
        neighbors.add(cells[i][j]);
      }
    }
    return neighbors;
  }

  void next() {
    for (int i = 0; i < WIDTH; i++) {
      for (int j = 0; j < HEIGHT; j++) {
        cells[i][j].next(getNeighbors(i, j));
      }
    }
  }

  void draw() {
    for (int i = 0; i < WIDTH; i++) {
      for (int j = 0; j < HEIGHT; j++) {
        cells[i][j].draw();
      }
    }
  }

  void drawNext() {
    next();
    draw();
  }
}

class Cell {
  float x;
  float y;
  float diameter;
  boolean alive;
  int ON_COLOR = 200;
  int OFF_COLOR = 75;

  Cell(float x, float y, float diameter) {
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

  void next(ArrayList < Cell > neighbors) {
    int liveNeighbors = 0;
    for (Cell cell: neighbors) {
      if (cell.isAlive()) {
        liveNeighbors++;
      }
    }
    // Conway's rules
    if (alive) {
      if (liveNeighbors < 2 || liveNeighbors > 3) {
        off();
      }
    } else {
      if (liveNeighbors == 3) {
        on();
      }
    }
  }

  void draw() {
    if (alive) {
      fill(ON_COLOR);
    } else {
      fill(OFF_COLOR);
    }
    rect(x, y, diameter, diameter);
  }
}

Board board;
float cellHeight;

void setup() {
  fullScreen();
  board = new Board();
  cellHeight = board.cells[0][0].diameter;
}

void mouseDragged() {
  if (board == null) {
    return;
  }
  int x = mouseX / (int) cellHeight;
  int y = mouseY / (int) cellHeight;
  board.cells[x][y].on();
  board.draw();
}

void draw() {
  board.drawNext();
  delay(100);
}
