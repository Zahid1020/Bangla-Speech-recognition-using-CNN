## Running the Project Demo

- Be sure to clone the entire project and finish installing the <a href="https://www.mathworks.com/matlabcentral/fileexchange/45182-matlab-support-package-for-usb-webcams">required support package.</a>

- Start MATLAB and selecting the "codes" folder as MATLAB work directory, run the "Main_Code.m" file (Headphone recommended). The following start screen should pop up.

![Home Screen](../images/home_screen.png)

- There are 5 parts of the start screen. The top-left section is the webcam feedback, top-right portion is intended as system feedback where visual data is displayed by the program (photos of books etc). In the bottom section, the first icon indicates presence of a person (green indicates person detected and a session starts). The second icon indicates user voice input prompt (speak to the microphone when green). The third icon indicates sound feedback from the machine (green indicates the program is saying something through speakers).

![Home Screen with person](../images/home_screen_person_detected.png)

- The first time a person is detected, program starts and speaks through the speakers. After a while user is prompted for a voice input or a keyboard input (if voice_input_enable flag is set to 'true' voice input is enabled, otherwise user will have to give inputs via the MATLAB command window)

![Input Via Command Window](../images/command_window_input.png)

![Voice input flag](../images/voice_input_flag.png)

- After you choose a category, several sub-categories of books will be displayed, and in each sub-category several books will be displayed. User input can be provided to add books to carts.

![Categories](../images/showing_category.png)
