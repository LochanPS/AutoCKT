circuit: sample
vcc: 5V
net: OUT
voltage_source: name=V1 value=5V pos=VCC neg=GND
ground: name=GND
resistor: name=R1 value=1k node1=VCC node2=OUT
capacitor: name=C1 value=1uF node1=OUT node2=GND
