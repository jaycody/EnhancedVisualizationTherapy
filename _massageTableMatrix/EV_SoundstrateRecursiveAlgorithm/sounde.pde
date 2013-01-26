public class complexWave extends Oscillator
{
  public complexWave(float frequency, float amplitude, float sampleRate)
  {
    super(frequency, amplitude, sampleRate);
  }
  
   protected float value(float step)
   {
      return (float)((Math.sin(TWO_PI*(step+0.3))/12) +
                    (Math.cos(TWO_PI*(step+0.2))/12) +
                    (Math.sin(TWO_PI*(step))/2)/*+
                    (Math.cos(TWO_PI*(step+0.2)*2)/6)+
                    (Math.sin(TWO_PI*(step+0.1)*1.5)/6)*/
                    );
   }
}

