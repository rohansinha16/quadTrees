/* Authors: Rohan Sinha, Alex Stanhope
 * Implementation Hw 2: Quadtrees
 * Decemeber 1, 2017
 */
 
import java.util.Random;

QuadNode root;
int nodeNum;
ArrayList<Segment> segments;

// state variables
boolean animation;
boolean insert;
boolean report;
boolean trip;
boolean itrip;
int r, g, b;
// query region
Integer qx1, qy1, qx2, qy2;
int time = 0;

// Buttons
Button readFileButton;
Button restartButton;
Button animationMode;
Button insertMode;
Button reportMode;
Button tripMode;
Button itripMode;

void setup() {
    size(513, 612);
    smooth();
    textSize(14);
    restart();
    //Create Clickable Buttons
    readFileButton = new Button("Read File", 10, 562, 100, 25);
    restartButton = new Button("Restart", 130, 562, 100, 25);
    animationMode = new Button("", 381, 520, 70, 20);
    insertMode = new Button("", 381, 545, 70, 20);
    reportMode = new Button("", 381, 570, 70, 20);
    tripMode = new Button("T", 470, 527, 25, 25);
    itripMode = new Button("I", 470, 558, 25, 25);
}

void draw() {
    smooth();
    // clear screen
    fill(211,211,211);
    rect(-1, -1, 514, 613);
    // footer
    fill(0, 0, 0);
    drawGui();
    // main display
    if(root != null){
        fill(80, 80, 80);
        stroke(100, 100, 100);
        rect(root.x, root.y, root.len, root.len);
        if(trip)
            stroke(r, g, b);
        else
            stroke(256, 256, 0);
        root.drawNode();
    }
    // draw segments
    stroke(256, 256, 256);
    for(int i = 0; i < segments.size(); i++){
        segments.get(i).drawSeg();
    }
    // timer
    if(time > 0){
        time--;
        // draw query region
        stroke(0, 0, 200);
        strokeWeight(3);
        noFill();
        rect(qx1, qy1, qx2 - qx1, qy2 - qy1); 
        strokeWeight(1);
        // timer is up
        if(time == 0){
            // unhighlight root and segments
            root.deSelect();
            for(int i = 0; i < segments.size(); i++){
                segments.get(i).hL = false;
            }
        }
    }
    colorChange();
    if(itrip){
        insertRandSeg();
    }
    smooth();
}

// footer region
void drawGui() {
    stroke(0);
    textAlign(LEFT, TOP);
    text("Number of segments: " + segments.size(), 10, 522, width, height);
    text("Number of nodes: " + nodeNum, 10, 537, width, height);
    text("Animation Mode: ", 256, 522, width, height);
    text("Insert Mode: ", 256, 547, width, height);
    text("Report Mode: ", 256, 572, width, height);
    readFileButton.drawButton();
    restartButton.drawButton();
    // set button text
    if (animation)
        animationMode.setText("On");
    else
        animationMode.setText("Off");
    if (insert)
        insertMode.setText("On");
    else
        insertMode.setText("Off");
    if (report)
        reportMode.setText("On");
    else
        reportMode.setText("Off");
    animationMode.drawButton();
    insertMode.drawButton();
    reportMode.drawButton();
    if(trip){
        if(itrip){
            stroke(r, g, b);
            itripMode.drawButton();
        }
        else{
            itripMode.drawButton();
            stroke(r, g, b);
        }
    }
    tripMode.drawButton();
}

// reset all vars
void restart() {
    root = null;
    nodeNum = 0;
    segments = new ArrayList<Segment>();
    
    animation = true;
    insert = false;
    report = false;
    trip = false;
    r = 256;
    g = 0;
    b = 0;
}

void mousePressed() {
    if (restartButton.mouseOver())
        restart();
    else if (readFileButton.mouseOver())
        selectInput("Select file:", "fileSelected");
    else if (animationMode.mouseOver())
        flipAnimation();
    else if (insertMode.mouseOver())
        flipInsert();
    else if (reportMode.mouseOver())
        flipReport();
    else if (tripMode.mouseOver())
        flipTrip();
    else if (itripMode.mouseOver())
        flipiTrip();
    else if (mouseX > 0 && mouseX < 512 && mouseY > 0 && mouseY < 512){
        if(insert){
            // unhighlight
            root.deSelect();
            Segment newSeg = new Segment(mouseX, mouseX, mouseY);
            if(root.insertSeg(newSeg, animation)){
                segments.add(newSeg);
            }
        }
        else if(report){
            // second click
            if(qx1 != null && qx2 == null){
                qx2 = mouseX;
                qy2 = mouseY;
                time = 300;
                root.report(qx1, qy1, qx2, qy2, animation);
            }
            // first click
            else{
                qx1 = mouseX;
                qy1 = mouseY;
                qx2 = null;
                qy2 = null;
                javax.swing.JOptionPane.showMessageDialog(null, "Report Mode: Top left corner slected. Click where you want the bottom right corner of the query region to be.");
            }
        }
    }
}

// keyboard functionality
void keyPressed() {
    if(key == 'a')
        flipAnimation();
    else if(key == 'i')
        flipInsert();
    else if(key == 'r')
        flipReport();
    else if(key == 't')
        flipTrip();
}

//parse file
void fileSelected(File fileSel) {
    if (fileSel != null) {
        // rest vars for new file
        restart();
        String[] lines = loadStrings(fileSel.getAbsolutePath());
        int h = (int) pow(2, Integer.parseInt(lines[0]));
        root = new QuadNode(0, 0, h); // init root node
        nodeNum++; // add to number of nodes
        for (int i = 1; i < lines.length; i++) {
            if(!lines[i].equals("")){
                // split by ',' and use as coords for segments
                String[] coords = lines[i].split(",");
                Segment newSeg = new Segment(Integer.parseInt(coords[0]), Integer.parseInt(coords[1]), Integer.parseInt(coords[2]));
                if(root.insertSeg(newSeg, false)){
                    segments.add(newSeg);
                }
            }
        }
    }
}

void flipAnimation(){
    animation = !animation;
    if (!animation) {
        root.deSelect();
    }
}

void flipInsert() {
    insert = !insert;
    if (!insert){
        if(root != null)
            root.deSelect(); // unhighlight when insert is off
    }
    else{
        if(report)
            flipReport();
    }
}

void flipReport(){
    report = !report;
    if(report){
        // insert off when report is on
        if(insert)
            flipInsert();
        javax.swing.JOptionPane.showMessageDialog(null, "Report Mode: Click where you want the top left corner of the query region to be.");
    }
    else{
        //deset query coords on off
        qx1 = null;
        qy1 = null;
        qx2 = null;
        qy2 = null;
    }
}

class QuadNode {
    // coordinates
    int x;
    int y;
    int len;
    boolean hL;
    
    // children
    QuadNode[] child;
    
    // segments
    int segNum;
    Segment[] seg;
    
    // constructor
    public QuadNode(int x, int y, int len){
         this.x = x;
         this.y = y;
         this.len = len;
         hL = false;
         seg = new Segment[3];
         segNum = 0;
    }
    
    public void drawNode(){
        if(hL)
            strokeWeight(4);
        //rect(x, y, len, len);
        line(x, y, x + len, y);
        line(x, y, x, y + len);
        line(x + len, y, x + len, y + len);
        line(x, y + len, x + len, y + len);
        strokeWeight(1);
        // draw children
        if(segNum == -1){
            for(int i = 0; i < 4; i++){
                child[i].drawNode();
            }
        }
    }
    
    public boolean splitNode(){
        // don't split if at pixel size
        if(len > 1){
            nodeNum += 4;
            child = new QuadNode[4];
            child[0] = new QuadNode(x, y, len/2);
            child[1] = new QuadNode(x + len/2, y , len/2);
            child[2] = new QuadNode(x, y + len/2, len/2);
            child[3] = new QuadNode(x + len/2, y + len/2, len/2);
            return true;
        }
        return false;
    }
    
    public boolean insertSeg(Segment newSeg, boolean highlight){
        // does the segment belong to current node
        if(newSeg.y >= y && newSeg.y <= y + len && !(newSeg.x1 > x + len || newSeg.x2 < x)){
            if(this == root){
                if(newSeg.x1 < x)
                    newSeg.x1 = x;
                if(newSeg.x2 > x + len){
                    newSeg.x2 = x + len;
                }
            }
            hL = highlight;
            // adding fourth node
            if(segNum == 3){
                // try to split (will fail if at pixel size
                if(splitNode()){
                    // set node to parent and insert parents segments with new segment
                    segNum = -1;
                    for(int i = 0; i < 4; i++){
                        for(int j = 0; j < 3; j++){
                            child[i].insertSeg(seg[j], false);
                        }
                        child[i].insertSeg(newSeg, highlight);
                    }
                }
            }
            // segNum = -1 indicates parent node
            else if(segNum == -1){
                // insert to children
                for(int i = 0; i < 4; i++){
                    child[i].insertSeg(newSeg, highlight);
                }
            }
            else{
                // add to current node
                seg[segNum] = newSeg;
                segNum++;
            }
        }
        else if(this == root){
            return false;
        }
        return true;
    }
    
    public void report(int qx1, int qy1, int qx2, int qy2, boolean highlight){
        // check if in region
        if(!(qx1 > x + len || qx2 < x) && !(qy1 > y + len || qy2 < y)){
            hL = highlight;
            // report children if parent
            if(segNum == -1){
                for(int i = 0; i < 4; i++){
                    child[i].report(qx1, qy1, qx2, qy2, highlight);
                }
            }
            else{
                // set highlight for segments in the region to true
                for(int i = 0; i < segNum; i++){
                    if(seg[i].y > qy1 && seg[i].y < qy2 && !(seg[i].x1 > qx2 || seg[i].x2 < qx1)){
                        seg[i].hL = true;
                    }
                }
            }
        }
    }
    
    public void deSelect(){
        // recurisvely set highlight to fasle for every node
        hL = false;
        if(segNum == -1){
            for(int i = 0; i < 4; i++){
                child[i].deSelect();
            }
        }
    }
}

class Segment {
    int x1;
    int x2;
    int y;
    boolean hL;
    
    public Segment(int x1, int x2, int y){
        this.x1 = x1;
        this.x2 = x2;
        this.y = y;
    }
    
    public void drawSeg(){
        if(hL)
            strokeWeight(3);
        line(x1, y, x2, y);
        strokeWeight(1);
    }
}

// misclleanous visual features
void flipTrip(){
    trip = !trip;
    if(trip){
        javax.swing.JOptionPane.showMessageDialog(null, "Trip Mode enabled. Put on some good music.");
    }
    itrip = false;
}

void flipiTrip(){
    itrip = !itrip;
    if(itrip)
        javax.swing.JOptionPane.showMessageDialog(null, "Insert trip mode enabled. The program will now rapidly randomly introduce new segments.");
}

// controls changing colors at random speeds
void colorChange(){
    Random rand = new Random();
    int speed = rand.nextInt((50 - 1) + 1) + 1;
    if(r == 256 && g < 256 && b == 0){
        g += speed;
        if(g > 256)
            g = 256;
    }
    else if(r > 0 && g == 256 && b == 0){
        r -= speed;
        if(r < 0)
            r = 0;
    }
    else if(r == 0 && g == 256 && b < 256){
        b += speed;
        if(b > 256)
            b = 256;
    }
    else if(r == 0 && g > 0 && b == 256){
        g -= speed;
        if(g < 0)
            g = 0;
    }
    else if(r < 256 && g == 0 && b == 256){
        r += speed;
        if(r > 256)
            r = 256;
    }
    else if(r == 256 && g == 0 && b > 0){
        b -= speed;
        if(b < 0)
            b = 0;
    }
}

// inserts random segments for trip mode
void insertRandSeg(){
    Random rand = new Random();
    int x = rand.nextInt((root.len - 2) + 1) + 1;
    int y = rand.nextInt((root.len - 2) + 1) + 1;
    root.deSelect();
    Segment newSeg = new Segment(x, x, y);
    if(root.insertSeg(newSeg, animation)){
        segments.add(newSeg);
    }
}