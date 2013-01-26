/*Enhanced Visualization (EV) Therapy :: Technology :: 2 Parts :: 
    1] EV_Projections :: computer1 :: imagery projected directly onto client in physical space :: 
    2] Acu_AR :: computer2 :: visable as Augmented Reality in video goggles or on face-cradle display :: 
        
Naming Convention::
  EV_Projections = drop "Projections" [eg EV_Projection_Foo --> EV_Foo] 
      // updated from previous convention, which also added prefixes [eg Acu(EV_Projection)_Foo --> Acu(EV)_Foo (eg Acu(EV)_Point)]
  Acu_AR = add underscore suffix as necessary, such that FlowFieldFoo --> Acu_AR_FlowFieldFoo
      // updated previous convention, which was :: 
      base case = "EV_AR" :: drop "EV" [eg EV_AR_Foo --> AR_Foo] && Add prefixes [eg Acu(EV_AR)_Foo --> Acu(AR)_Foo (eg Acu(AR)_Point)]

EV_Projections::Computer1::Tronik::MacBookPro_Lion10.7::8gigsRam::Procesing1.5.1
    uses the InFocus ShortThrow projector positioned over the massage table
    uses Kinect positioned near the projector directly above massage table
    includes:  
      EV_PointGenerator :: created and controlled via gesture and touchOSC (via iPad suspended in space and iPhone attached to my arm)
      EV_Point::Acupressure Point via Projections
      EV_Vehicle :: "life-like and improvisational" particles with goals, desires, abilities, behaviors and awareness of self, others, and EV session details
      EV_FlowFieldDepth :: Vector Field :: Direction from depth contours, Force from slope angle + gravity - friction
      EV_FlowFieldIllumination:: Vector Field :: Direction from projected light's location :: Force Magnitude from Brightness of projected light as seen by Kinect1 RGB.
      EV_FeedbackLoop

      
Acu_AR::Computer2::Megatronik::MacPro_8core_3GHz::6gigsRam[sigh]::Processing1.5.1 [after 8 weeks of openFrameworks]
    1st DVI out to 24inch main screen
    2nd DVI out downshifted to VGA and sent to VGA 1x4 splitter
    1x4 VGA Splitters out to:
      1. Face-Cradle Display :: 19inch Dell (1024x768) attached to massage table via manfrotto clamp with articulating joint
      2. Vuzix 920 Video Goggles for client in supine position
      3. Vuzix 920 Video Goggles for therapist
          (Vuzix each also require USB-2 to Computer2 for Power (and Perhaps signal information as well (perhaps USB powered hub would work?))
      4. Video Projector:: rear projected at fabric above space
          making session viewable to public outside space while retaining coherence with healing space with curtains closed
          
          
          

______________________________________
EV_PointGenerator
    created and controlled via gesture and touchOSC (via iPad suspended in space and iPhone attached to my arm)
______________________________________



______________________________________
EV_Point
    Acupressure Point via Projections
______________________________________


______________________________________
EV_Vehicle
    "life-like and improvisational" particles with goals, desires, abilities, behaviors and awareness of self, others, and EV session details
______________________________________



______________________________________
EV_FlowFieldDepth
    Vector Field :: Direction from depth contours, Force from slope angle + gravity - friction
______________________________________




______________________________________
EV_FlowFieldIllumination::
  Vector field whose Direction is a function of the projected light's location, 
  and whose Force Magnitude is a function of Brightness of projected light of Acu(EV)_Point as seen by Kinect1 RGB.
______________________________________




______________________________________
EV_FeedbackLoop
    1.  USE Transparency on PGraphics with createGraphics:
      Unlike the main drawing surface which is completely opaque, 
      surfaces created with createGraphics() can have transparency. 
      This makes it possible to draw into a graphics and maintain the alpha channel. 
      By using save() to write a PNG or TGA file, the transparency of the graphics object will be honored. 
      Note that transparency levels are binary: pixels are either complete opaque or transparent.
  TODO:
  ____use one RVL sample with alpha channel intact.  looping but with feedback added
______________________________________





______________________________________
Acu_AR_PointGenerator::
______________________________________


______________________________________
Acu_AR_Point::Acupressure Points via Augmented Reality
______________________________________

*/
