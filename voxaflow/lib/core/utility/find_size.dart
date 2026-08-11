


double findHeight(double screenHeight, double height){
  // Standard responsive scaling: (desired_height / design_height) * screenHeight
  // Assuming design height is 812 (iPhone X/11/12/13 Pro etc common) or 752 as appearing in original code
  // If original intention was to scale UP on smaller screens, the previous formula (height * design / screen) does that for height but inverse for screen size.
  // Standard flutter usage usually relies on logical pixels.
  // Let's switch to a standard scaling factor if we presume the input 'height' is for a standard base device (e.g. 375x812).
  
  // However, simply returning `height` and letting Flutter's logical pixels handle it is often safest unless "pixel perfect matching to design mockups" is required.
  // The confusing formula `(height * 752)/screenHeight` means if screen is BIGGER, height is SMALLER. This is likely a bug.
  // PROPOSED FIX: Scale proportional to screen height.
  final double newHeight = height * (screenHeight / 752); 
  return newHeight;
}

double findWidth (double screenWidth, double width){
  // Scale proportional to screen width. Base 360.
  final double newWidth = width * (screenWidth / 360);
  return newWidth;
}


double findFontSize (double screenWidth, double width) {
   // Scale proportional to screen width. Base 360.
  final double newWidth = width * (screenWidth / 360);
  return newWidth;
}