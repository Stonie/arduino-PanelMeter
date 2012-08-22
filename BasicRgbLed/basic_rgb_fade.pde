//PWM pins
byte RED = 6;
byte BLUE = 5;
byte GREEN = 3;
byte COLORS[] = {RED, BLUE, GREEN};

void setup ()
{
pinMode(3, OUTPUT);
pinMode(5, OUTPUT);
pinMode(6, OUTPUT);
}

//  MAIN CODE
void loop ()
{
//direction: up = true, down = false
boolean dir = true;
int i = 0;

while(1)
{
  fade(COLORS[i%3], dir);
  i++;
  dir = !dir;
}

}

void fade(byte Led, boolean dir)
{
int i;

//if fading up
if (dir)
{
for (i = 0; i < 256; i++)
{
analogWrite(Led, i);
delay(50);//1);
}
}
else
{
for (i = 255; i >= 0; i--)
{
analogWrite(Led, i);
delay(50);//1);
}
}
}
