/*************************************************************
 ********************Behavior Controls************************
 *****************By Andrew Lazarow***************************
 *******Using elements of: Control P5 Slider and Toggles******
 ************************FINAL Draft 1************************
 ************************************************************/

void Float (boolean theFlag) {
  if (theFlag==true) {
    behavFloat=true;
  }
}

void Glide (boolean theFlag) {
  if (theFlag==true) {
    behavGlide=true;
  }
}

void Dab (boolean theFlag) {
  if (theFlag==true) {
    behavDab=true;
  }
}

void Flick (boolean theFlag) {
  if (theFlag==true) {
    behavFlick=true;
  }
}

void Wring (boolean theFlag) {
  if (theFlag==true) {
    behavWring=true;
  }
}

void Slash (boolean theFlag) {
  if (theFlag==true) {
    behavSlash=true;
  }
}

void Punch (boolean theFlag) {
  if (theFlag==true) {
    behavPunch=true;
  }
}

void Press (boolean theFlag) {
  if (theFlag==true) {
    behavPress=true;
  }
}

void setBahviors () {

  if (behavFloat==true) {
    controlP5.controller("MaxForce").setValue(39);
    controlP5.controller("MaxSpeed").setValue(82);
    controlP5.controller("SeekStrength").setValue(50);
    controlP5.controller("SeparationStrength").setValue(62);
    controlP5.controller("Allignment").setValue(22);
    controlP5.controller("Cohesion").setValue(16);
    controlP5.controller("Indirection").setValue(66);
    behavFloat=false;
    seekOn=true;
    arriverOn=false;
  }

  if (behavGlide==true) {
    controlP5.controller("MaxForce").setValue(60);
    controlP5.controller("MaxSpeed").setValue(76);
    controlP5.controller("SeekStrength").setValue(62);
    controlP5.controller("SeparationStrength").setValue(33);
    controlP5.controller("Allignment").setValue(19);
    controlP5.controller("Cohesion").setValue(30);
    controlP5.controller("Indirection").setValue(0);
    behavGlide=false;
    seekOn=true;
    arriverOn=false;
  }

  if (behavDab==true) {
    controlP5.controller("MaxForce").setValue(79);
    controlP5.controller("MaxSpeed").setValue(100);
    controlP5.controller("SeekStrength").setValue(50);
    controlP5.controller("SeparationStrength").setValue(100);
    controlP5.controller("Allignment").setValue(13);
    controlP5.controller("Cohesion").setValue(99);
    controlP5.controller("Indirection").setValue(13);
    behavDab=false;
    seekOn=true;
    arriverOn=false;
  }

  if (behavFlick==true) {
    controlP5.controller("MaxForce").setValue(100);
    controlP5.controller("MaxSpeed").setValue(100);
    controlP5.controller("SeekStrength").setValue(51);
    controlP5.controller("SeparationStrength").setValue(100);
    controlP5.controller("Allignment").setValue(0);
    controlP5.controller("Cohesion").setValue(14);
    controlP5.controller("Indirection").setValue(68);
    behavFlick=false;
    seekOn=true;
    arriverOn=false;
  }

  if (behavWring==true) {
    controlP5.controller("MaxForce").setValue(17);
    controlP5.controller("MaxSpeed").setValue(41);
    controlP5.controller("SeekStrength").setValue(55);
    controlP5.controller("SeparationStrength").setValue(72);
    controlP5.controller("Allignment").setValue(13);
    controlP5.controller("Cohesion").setValue(22);
    controlP5.controller("Indirection").setValue(63);
    behavWring=false;
    seekOn=true;
    arriverOn=false;
  }

  if (behavSlash==true) {
    controlP5.controller("MaxForce").setValue(100);
    controlP5.controller("MaxSpeed").setValue(100);
    controlP5.controller("SeekStrength").setValue(76);
    controlP5.controller("SeparationStrength").setValue(100);
    controlP5.controller("Allignment").setValue(44);
    controlP5.controller("Cohesion").setValue(19);
    controlP5.controller("Indirection").setValue(82);
    behavSlash=false;
    seekOn=true;
    arriverOn=false;
  }

  if (behavPunch==true) {
    controlP5.controller("MaxForce").setValue(81);
    controlP5.controller("MaxSpeed").setValue(100);
    controlP5.controller("SeekStrength").setValue(78);
    controlP5.controller("SeparationStrength").setValue(34);
    controlP5.controller("Allignment").setValue(15);
    controlP5.controller("Cohesion").setValue(15);
    controlP5.controller("Indirection").setValue(0);
    seekOn=false;
    arriverOn=true;
    behavPunch=false;
  }

  if (behavPress==true) {
    controlP5.controller("MaxForce").setValue(10);
    controlP5.controller("MaxSpeed").setValue(11);
    controlP5.controller("SeekStrength").setValue(50);
    controlP5.controller("SeparationStrength").setValue(50);
    controlP5.controller("Allignment").setValue(19);
    controlP5.controller("Cohesion").setValue(31);
    controlP5.controller("Indirection").setValue(0);
    seekOn=false;
    arriverOn=true;
    behavPress=false;
  }
}

