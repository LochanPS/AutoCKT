from dsl.parser import parse
text = (
"circuit: simple_rc\n"
"vcc: 5V\n"
"net: OUT\n"
"resistor: name=R1 value=10k node1=VCC node2=OUT\n"
"capacitor: name=C1 value=1uF node1=OUT node2=GND\n"
)
print(parse(text))
