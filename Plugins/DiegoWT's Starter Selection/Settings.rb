#===============================================================================
# DiegoWT's Starter Selection script settings
#===============================================================================
module StarterSelSettings

# To start the scene, call the script "DiegoWTsStarterSelection.new(x,y,z)", where x, y and z are the species ID of your starters.
# Example of the script call using Bulbasaur, Charmander and Squirtle: 
# DiegoWTsStarterSelection.new(:BULBASAUR,:CHARMANDER,:SQUIRTLE)

# Level of your starters:
  STARTERL = 5
 
# Interface style (1 for HGSS, 2 for BW):
  INSTYLE = 1

# Form of each Starter species:
  STARTER1F = 0 # First Starter
  STARTER2F = 0 # Second Starter
  STARTER3F = 0 # Third Starter
  
# Horizontal and vertical values for editing the starter position:
  STARTER1X = 0; STARTER1Y = 0 # First Starter
  STARTER2X = 0; STARTER2Y = 0 # Second Starter
  STARTER3X = 0; STARTER3Y = 0 # Third Starter
# Here, for the horizontal lines, negative numbers are left and the positive 
# ones are right. For the vertical lines, negative numbers are up and the
# positive ones are down.
  
# Starter's circle size configuration. Configure how big you want the Starter
# white circle to be:
  STARTERCZ = 0 # 0 is normal size; 1 is double the size
  
# Set true if you want the script to play the selected starter's cry when selected, 
# or false if not:
  STARTERCRY = true

# Configuration for allowing gratients to show both types of the starter. This will
# also show an extra gradient with the 2nd type's color.
# Set true if you want it, or false if not:
  TYPE2COLOR = false

end
