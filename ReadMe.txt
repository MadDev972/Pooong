Hi !
To make this code work, you will need to install the Cocos2D library.
For this, open up a terminal window in the Cocos2D directory and enter the following command : 
./install-templates.sh -f -u

All done !

About this code
This code implements a simple Pong game app for iPhone and iPad, with single and dual playing modes.
I have chosen to use all the advantages of an object oriented language, and created 3 classes for expendability and usability purposes.
These parent classes are found under “Supportive Files”. They are :

- PlayLayer, the class for all playing views. 
It sets up a playable view with 2 paddles - one of which is touch-controlled - , and 1 ball.
It also implements the physics simulation needed for the movements of the ball, as well as all the logic behind the managing of points and game phases (back to menu, win, lose, restart).
The classes SingleModeLayer and DualModeLayer inherit from PlayLayer.
The SingleModeLayer, as its name implies, is for playing against the “computer”. It implements a simple AI for the computer-controlled paddle, and its own way of managing the scoring, namely playing a buzzing sound instead of a cheer in case the computer scores.
The DualModeLayer is for playing one-on-one with someone else. Both paddles are then touch-controlled.  

- Paddle, the class for the paddles.
It takes care of all the needed elements to create an object with which the player(s) can interact, and that can interact with the simulated world (namely the contours of the screen and the ball).
This means creating a picture(sprite), a body and a fixture for this object.

- Ball, the class for the ball.
As for the Paddle class, everything is taken care in this class to create a ball that can interact with its environment. 

I specifically chose to take advantage of classes and inheritance in order to create a game that could be very easily and quickly expanded upon.
Simply creating a new child to the PlayLayer class would allow for new play modes, for instance with more than 2 paddles, possibly one more on the top edge, and one more on the bottom edge. 
The Paddle class can also be easily used to create different types of paddles(longer, shorter, with different properties...). 
As with the paddles, it could also be fun to create new game modes with multiples balls, or different types of balls. All this is made very easy thanks to the use of classes and inheritance.