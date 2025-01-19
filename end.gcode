G91 ;Relative positioning
G1 E-2 F2700 ;Retract a bit
G1 E-2 Z0.2 F2400 ;Retract and raise Z
G1 X5 Y5 F3000 ;Wipe out
G1 Z10 ;Raise Z more
G90 ;Absolute positioning

G1 X0 Y{machine_depth} ;Present print

M84 X Y E ;Disable all steppers but Z
M300 S200 P500 
G4 P1000        
M300 S200 P500
G4 P1000        
M300 S200 P500
M190 R40 ;wait until the bed cools to 40C
M300 S200 P3000
M355 S0 P255

M106 S0 ;Turn-off fan
M104 S0 ;Turn-off hotend
M140 S0 ;Turn-off bed