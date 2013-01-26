void circleForRightHand(int userId)
{
  int userNumber = userId;

  if (userNumber==whichUser) {

    // get 3D position of a joint
    PVector jointPos = new PVector();

    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPos);
    // println(jointPos.x);
    // println(jointPos.y);
    // println(jointPos.z);

    // convert real world point to projective space
    PVector jointPos_Proj = new PVector(); 
    context.convertRealWorldToProjective(jointPos, jointPos_Proj);

    // a 200 pixel diameter head
    float headsize = 200;

    // create a distance scalar related to the depth (z dimension)
    float distanceScalar = (525/jointPos_Proj.z);

    // set the fill colour to make the circle green
    fill(0, 255, 0); 

    // draw the circle at the position of the head with the head size scaled by the distance scalar
    ellipse(jointPos_Proj.x, jointPos_Proj.y, distanceScalar*headsize, distanceScalar*headsize);
    passedX = round (jointPos_Proj.x);
    passedY= round (jointPos_Proj.y);
  }
}

void circleForAHead(int userId)
{
  int userNumber = userId;

  if (userNumber==1) {

    // get 3D position of a joint
    PVector jointPos = new PVector();

    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPos);
    // println(jointPos.x);
    // println(jointPos.y);
    // println(jointPos.z);

    // convert real world point to projective space
    PVector jointPos_Proj = new PVector(); 
    context.convertRealWorldToProjective(jointPos, jointPos_Proj);

    // a 200 pixel diameter head
    float headsize = 200;

    // create a distance scalar related to the depth (z dimension)
    float distanceScalar = (525/jointPos_Proj.z);

    // set the fill colour to make the circle green
    fill(0, 255, 0); 

    // draw the circle at the position of the head with the head size scaled by the distance scalar
    ellipse(jointPos_Proj.x, jointPos_Proj.y, distanceScalar*headsize, distanceScalar*headsize);
    //passedX = round (jointPos_Proj.x);
    //passedY= round (jointPos_Proj.y);
  }
}


// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{  
  int userNumber = userId;

  if (userNumber==2) {
    stroke(0, 255, 0);
  }
  // draw limbs  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

