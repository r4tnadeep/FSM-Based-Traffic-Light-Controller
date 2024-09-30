# FSM-Based-Traffic-Light-Controller

This project implements a traffic light controller using Verilog HDL for managing the traffic signals at an intersection between a highway and a country road. The system utilizes a finite state machine (FSM) to control the traffic lights based on the presence of a vehicle on the country road and the system clock.
The system operates in a loop, where the default state keeps the highway green and the country road red. When a vehicle is detected on the country road (input x becomes high), the highway signal transitions from green to yellow and then to red, allowing the country road to turn green. After a set delay, the system returns the priority to the highway by turning the country road red and transitioning the highway back to green.

Traffic Light States:

State 0 (s0): Highway green, country road red.
State 1 (s1): Highway yellow, country road red.
State 2 (s2): Highway red, country road red (transition state).
State 3 (s3): Highway red, country road green.
State 4 (s4): Highway red, country road yellow.

Delays:
Y2Rdelay: Delay for the transition from yellow to red.
R2Gdelay: Delay for the transition from red to green.
