/*--------------------------------------------------------------------------------------------
 * Author: Carlos Carbajal & Graham Place
 *
 * Class: Button
 * 
 * Description: Create a button on window that is clickable
 *
 * Credit: https://blog.startingelectronics.com/a-simple-button-for-processing-language-code/
 *-------------------------------------------------------------------------------------------*/

class Button {
  String label;
  float x, y, w, h;

  /**
   * Constructor
   *
   * Parameters: bName: 
   */
  Button(String bName, float xPos, float yPos, float bWidth, float bHeight)
  {
    label = bName;
    x = xPos;
    y = yPos;
    w = bWidth;
    h = bHeight;
  }//End Constructor

  //set to allow changing button text
  void setText(String text){
    label = text;
  }
  
  /*
    * buttonDraw()
   * Makes button on window
   */
  void drawButton() {
    fill(218);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x+ (w/2), y+(h/2)); //Aligns text inside button
    fill(256,256,256);
  }

  /*
   * mouseOver()
   *
   * Description: Check to see if mouse is place over the parameters of the button when the button is clicked.
   *
   * Return: true - if mouse is within bounds
   *         false -  mouse is not wthin bounds
   */
  boolean mouseOver() {
    if (mouseX > x && mouseX <(x+w) && mouseY > y && mouseY < (y+h))
      return true;
    return false;
  }//END mouseOver
}//END Button Class