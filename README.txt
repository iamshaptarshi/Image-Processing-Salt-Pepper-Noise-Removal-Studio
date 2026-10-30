PROJECT 7 - SALT-AND-PEPPER NOISE REMOVAL STUDIO
RUN INSTRUCTIONS

REQUIREMENTS
- MATLAB R2014
- Image Processing Toolbox

HOW TO RUN
1. Extract the project ZIP file.
2. Open MATLAB.
3. In the Current Folder panel, open the extracted project folder.
4. Make sure main_project7_gui.m and the other project .m files are in that folder.
5. In the MATLAB Command Window, run:

   clear functions;
   close all;
   rehash;
   Salt_Pepper_Noise_Removal_Project_GUI

6. The Noise Removal Studio window will open.

HOW TO USE
1. Click Select Image in the left sidebar.
2. Choose an image from your computer.
3. Adjust the Noise Density slider (5% to 50%).
4. Choose a filter: Mean, Median, Gaussian, or Adaptive Median.
5. Click Process Image.
6. Wait for processing to finish. The noisy image, restored image, and quality metrics will appear.
7. Click Save Restored Image to save the result.
8. Click Reset / New Image to clear the workspace and start again.

IMPORTANT
- Keep all project .m files together in the same folder.
- Do not move or rename the MATLAB files.
- If MATLAB cannot find the main function, set the Current Folder to the extracted project folder and run rehash.
