# Thesis Project Archive  
Interactive Telecommunications Program - NYU  
Spring 2012  

Enhanced Visualization Therapy  
	- aka: Intelligent Healing Spaces or Interactive Healing Spaces  


### R&D Documentation:   
[Interactive Healing Spaces](https://www.flickr.com/photos/jaycody9/albums/72157637800982304)  

### Project Videos:
[Vimeo](https://vimeo.com/album/2004737)    
[youTube](http://www.youtube.com/user/jaycody9)

### Press:    
[CNET](http://news.cnet.com/8301-27083_3-20070346-247/kinect-hack-allows-for-intelligent-healing-massage/)    
[Gizmodo](http://gizmodo.com/5910630/i-let-a-weird-man-rub-me-for-10-minutes-in-the-name-of-journalism)  
[PCWorld](http://www.techhive.com/article/227759/kinect_hack_helps_therapists_track_their_session_progress.html)  
[engadget](http://www.engadget.com/2011/05/14/kinect-hack-enables-psychedelic-acupressure-far-out-graphics-v/)  
[MedGadget:  Journal of Emerging Medical Technologies](http://www.medgadget.com/2011/06/kinect-helps-power-a-futuristic-massage-table.html)  
[KinectHacks](http://www.kinecthacks.com/massage-therapy-using-the-kinect/)  

________


Definition:
Interactive Healing Spaces are mixed-reality environments which augment, and assist with, traditional massage modalities.

Interactive Healing Spaces integrate therapeutic bodywork (deep tissue, sports massage, Swedish, Tui-Na, acupressure) with interactive technology (computer vision, augmented reality, volumetric sensors, video projections, video goggles). Using a depth-sensing camera, the system translates body shapes, positions, movements, and gestures into visualizations. During a massage session, these visuals are projected into both real space and augmented reality on and around the massage table. Two sets of video goggles provide the client and the therapist with a real-time out-of-body perspective of this mixed-reality environment.

REASON:
In the massage community, ancient modalities are often respected the most. But I believe that healers of every generation are presented with new ideas that can extend or supplement established methods. Interactive technology and augmented reality represent just a fraction of the novelty now available to alternative medicine practitioners. I chose these specific technologies because they offered themselves as ideal extensions to my own evolving practice in the healing arts.

Software Description:

1. AcuNetics: CyberNetic Acupressure.  The treatment of acupressure points using self-guided, self-steering, semi-autonomous objects in augmented reality (AcuNetic_AR) and in immersive video environments (AcuNetic_Projections).  See note*.  

2. Acu2D:  Virtual Pressure Objects.  
2-D objects projected directly onto the client

3. AcuAR:  Augmented Reality Acupressure  

4. Massage Table Matrix:    
A Conway Game of Life existing on the massage table.  Goal:  propagating waves and interference patterns affected by client’s body on the table.

5. Depth Informed Flow Field:    
A particle system whose behavior is informed by depth and movement on and around the massage table

6. Proprioception Enhancement Tools (PET):    
This app combines the scene’s RGB information with its point cloud information.  The Processing version proved to be too slow.  An OpenFrameworks version 

_____

AcuNetics:  Cybernetic Acupressure  -  an explanation:  

AcuNetics : An aspect of Enhanced Visualization (EV) Therapy :: EV_AcuNetic_AR and EV_AcuNetic_Projections. AcuNetic objects (both projections and AR) are distinguished from other methods of EV_Therapy by their intelligence, awareness, and ability to behave in life-like and improvisation ways. Whereas standard EV_Objects in AR and projected space may be placed at a specific location on the client’s body, AcuNetic objects are introduced into a session and are allowed to determine their own course of action based on the unique circumstances of the healing session. This allows the therapist the opportunity to continue working with the client, while self-guided AcuNetic objects determine for themselves their own behavior, location, and appearance. An AcuNetic object may sense shallow breathing and will position itself over the client’s chest and transform itself into a reflection of the client while allowing its own size and shape to be influenced by magnitude of client’s breathing. Or the AcuNetic object may sense a higher than normal heart rate, and in response may assemble with other AcuNetic object to form themselves into a pattern around the client’s heart that changes shape based on the heart rate. In this way, the client becomes aware of their own heart rate through a form of biofeedback. The difference between standard biofeedback and this AcuNetic feedback technique is that the therapist need not monitor the client’s heart rate, nor does the therapist need to stop the session in order to respond to a higher than average heart rate. A therapist need only invite the AcuNetic objects to the session.
The objects themselves will analyse the details of the treatment (and of all previous treatments with this client) and from that information will determine their own course of action. If an AcuNetic object senses that the therapist is spending extra time with one part of the client’s body, the object may resolve to directly assist the therapist by transforming into pulsating light at that spot, or it may decide to transform into a bright pulsating line that runs along the local acupressure meridian and connects the therapist’s treatment area with the previous 5 major acupressure points along the main meridian line. If an AcuNetic object senses that the therapist is already receiving adequate help from other objects, then the object will continue to act in other supporting ways. The object may notice that during the client’s previous 5 sessions, a considerable amount of attention was given to the right hand, but that during this current session, the client’s right hand has yet to be treated. Based on this, the AcuNetic object may decide to visit that area in the form of darkness, or bright light, or in the form of sprouting trees or flowing water. The AcuNetic Object may even inhabit the pixels from which the image of the hand is created, and they may change the color or dimensions of the hand to make it look bigger or smaller in an attempt to increase the client’s proprioception in that area. Whenever the therapist is occupied working on one part of the body, the AcuNetic objects can be off treating the rest of the body. In this way, the therapist doesn’t have to constantly direct the interactive visualizations during a session. The therapist can rely on the intelligence and self-determination of these objects. With situational awareness, awareness of their own goals, and equipped with their own abilities to take appropriate action, the AcuNetic objects can cooperate if need be, or can act as independent agents of light during a client’s treatment.

 



