Project 2: Digital Alarm Clock
Introduction
In this project, we aim to design and implement a simple digital alarm clock using the BASYS3 FPGA board. The digital alarm clock will feature two modes: "adjust" and "clock/alarm", allowing users to set the time and alarm with ease. The project will utilize various peripherals of the BASYS3 board, including LD0, LD12, LD13, LD14, LD15, the 7-Segment display, and push buttons.

Peripherals: The project will exclusively utilize BASYS3 peripherals, including LD0, LD12, LD13, LD14, LD15, the 7-Segment display, and push buttons.
7-Segment Display: Two digits of the 7-Segment display will represent hours (left) and minutes (right).
Modes:
Clock/Alarm Mode: Default mode where the clock displays the current time. In this mode, LD0 is OFF, and the second decimal point from the left blinks at a frequency of 1Hz. When the current time matches the set alarm time, LD0 blinks.
Adjust Mode: Mode for adjusting the clock and alarm settings. In this mode, LD0 is ON, and the second decimal point from the left does not blink.
Mode Switching:
Pressing BTNC transitions from "clock/alarm" mode to "adjust" mode.
Pressing BTNC in "adjust" mode returns to "clock/alarm" mode.
Parameter Adjustment:
Pressing BTNL or BTNR selects the parameter to adjust (e.g., "time hour", "time minute", "alarm hour", "alarm minute").
LD12, LD13, LD14, and LD15 reflect the parameter being adjusted.
Pressing BTNU increments the selected parameter.
Pressing BTND decrements the selected parameter.

Functional Testing: Comprehensive testing will be conducted to verify the correct operation of all functionalities, including mode switching, parameter adjustment, and display updates.
Integration Testing: Testing the integration of all components to ensure proper communication and synchronization.
Usability Testing: User testing will be performed to evaluate the ease of use and intuitiveness of the digital alarm clock interface.
Performance Testing: Testing the performance under various conditions to ensure stability, accuracy, and reliability.
Contributors
Youssef Badawy: Responsible for clock divider implementation and finite state machine (FSM) design and implementation.
Janna Osama: Responsible for AlarmCounter and SecMinHourCounter implementation and button inputs handling.
