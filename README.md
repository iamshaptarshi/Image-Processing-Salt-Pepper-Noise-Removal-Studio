# Project 7 — Salt-and-Pepper Noise Removal Studio

A MATLAB-based digital image processing project that adds salt-and-pepper noise to a clean image, restores the noisy image using different spatial filters, and evaluates restoration quality using quantitative image-quality metrics.

The project includes an interactive graphical interface and a separate batch experiment script.

## Requirements

- **MATLAB R2014**
- **Image Processing Toolbox**

The project uses MATLAB-compatible functions such as `imread`, `imwrite`, `imshow`, `padarray`, and `medfilt2`.

## Project files

Keep all the following files together in the same project folder.

| File | Purpose |
|---|---|
| `Salt_Pepper_Noise_Removal_Project_GUI` | Interactive Noise Removal Studio GUI |
| `main_project7.m` | Runs the full batch experiment |
| `add_salt_pepper_fast.m` | Fast salt-and-pepper noise generation for the GUI |
| `add_salt_pepper_custom.m` | Controlled noise generation for batch experiments |
| `mean_filter_custom.m` | Mean (averaging) filter |
| `median_filter_custom.m` | Median filter |
| `gaussian_filter_custom.m` | Gaussian smoothing filter |
| `adaptive_median_filter_custom.m` | Adaptive median filtering routine |
| `calculate_mse.m` | Mean Squared Error calculation |
| `calculate_psnr.m` | Peak Signal-to-Noise Ratio calculation |
| `calculate_ssim_global.m` | Custom local-window SSIM calculation |

Do not move individual `.m` files out of the project folder. MATLAB needs to be able to find the main files and their helper functions.

## Run the project

### Option 1 — Interactive GUI (recommended)

1. Extract the project ZIP file.
2. Open MATLAB.
3. In the **Current Folder** panel, open the extracted `Project7_SaltPepper_MATLAB_R2014` folder. Make sure `main_project7_gui.m` is visible.
4. In the MATLAB Command Window, run:

   ```matlab
   clear functions;
   close all;
   rehash;
   Salt_Pepper_Noise_Removal_Project_GUI
   ```

5. The **DIP Lab | Noise Removal Studio** window will open.

### Option 2 — Full batch experiment

To run the experiment across all configured noise densities and filters, run:

```matlab
clear functions;
close all;
rehash;
main_project7
```

The script asks you to select a clean reference image. It then runs the configured experiments and saves the generated images, metric table, and comparison plots in a `Project7_Results` folder under MATLAB's current working directory.

## How to use the GUI

1. Click **Select Image** in the left sidebar.
2. Choose a clean image from the file-selection dialog. Supported formats are PNG, JPG/JPEG, BMP, TIF, and TIFF.
3. The selected image appears in the **Original Image** panel.
4. Adjust **Noise Density** using the sidebar slider. The available range is **5% to 50%**.
5. Select a **Filter Algorithm**:
   - **Mean**
   - **Median**
   - **Gaussian**
   - **Adaptive Median**
6. Click **Process Image**.
7. The application generates a salt-and-pepper noisy image, displays it in the **Noisy Input** panel, and applies the selected restoration filter. A percentage progress bar appears over the restored-output panel while processing.
8. When processing finishes, the restored image appears in **Restored Output** and the **Quality Report** displays the selected filter, noise density, MSE, PSNR, SSIM, and processing time. The processing overlay is removed when the operation completes.
9. Click **Save Restored Image** to choose a destination and save the restored output as a PNG or JPEG image.
10. Click **Reset / New Image** to clear the current image, noisy image, restored result, and report, then start another experiment.

You can change the filter or noise density and process the same loaded source image again to compare settings.

## Filter algorithms

The GUI and batch experiment provide four filtering methods.

- **Mean filter:** replaces each pixel with the average of values in its local neighbourhood. It smooths noise but can blur edges and fine details.
- **Median filter:** replaces each pixel with the median value in its local neighbourhood. It is commonly used for impulse noise because extreme black and white values have less influence on the median.
- **Gaussian filter:** performs weighted smoothing using a Gaussian kernel. Nearby pixels contribute according to their distance from the centre. It can reduce noise but may also soften edges.
- **Adaptive Median filter:** uses median-filter passes with increasing neighbourhood sizes to replace remaining impulse-valued pixels. The GUI implementation uses a vectorized sequence of `medfilt2` passes for practical interactive performance; it is an adaptive-median approximation rather than a per-pixel textbook implementation.

The current GUI uses 3-by-3 neighbourhoods for Mean, Median, and Gaussian filtering. The Gaussian filter uses sigma `0.8`. The adaptive median routine starts at 3-by-3 and increases up to 7-by-7.

## Noise density and experiment settings

### Interactive GUI

The noise-density slider can be set from **5% to 50%**. The selected value is the approximate fraction of pixel locations replaced by impulse noise. Salt (white) and pepper (black) values are distributed approximately equally.

### Batch experiment

The batch script uses these fixed noise-density levels:

- 5%
- 10%
- 20%
- 30%
- 40%
- 50%

It evaluates all four filters at each noise level. For a given noise density, the same generated noisy image is used as the input to each filter so that the filter results can be compared under the same noise realization.

## Quality metrics

The application compares the restored image with the original clean reference image.

- **MSE — Mean Squared Error:** measures the average squared pixel difference between the reference and restored images. A lower MSE indicates a smaller error.
- **PSNR — Peak Signal-to-Noise Ratio:** expresses reconstruction error in decibels. A higher PSNR generally indicates better reconstruction quality.
- **SSIM — Structural Similarity Index:** estimates similarity in local luminance, contrast, and structure. Values closer to 1 generally indicate greater similarity.
- **Processing Time:** records the elapsed filtering time for the selected operation. It does not represent the time needed for the entire application session.

The project normalizes image data to the range `[0, 1]` before processing and metric calculation. The custom SSIM routine uses an 11-by-11 Gaussian window with sigma 1.5; it is implemented in the project for MATLAB R2014 compatibility and is not a call to MATLAB's newer built-in `ssim` function.

## Batch experiment output

After `main_project7` finishes, open the `Project7_Results` folder. It contains:

- `noisy_XX_percent.png` — generated noisy input for each configured noise density.
- `Mean_XX_percent.png` — mean-filter restoration.
- `Median_XX_percent.png` — median-filter restoration.
- `Gaussian_XX_percent.png` — Gaussian-filter restoration.
- `AdaptiveMedian_XX_percent.png` — adaptive-median restoration.
- `quality_metrics.csv` — metric and processing-time results for each filter/noise-density combination.
- `psnr_comparison.png` — PSNR versus noise-density plot for the four filters.
- `ssim_comparison.png` — SSIM versus noise-density plot for the four filters.

The batch script also opens figures showing the original image, noisy image, and restored results for each noise density.

## Notes and troubleshooting

- **MATLAB cannot find `main_project7_gui`:** use the MATLAB Current Folder panel to navigate to the extracted project directory, then run `rehash` and try again.
- **A helper function is undefined:** confirm that all project `.m` files are in the same folder and that MATLAB's Current Folder is set to that folder.
- **`padarray` or `medfilt2` is undefined:** check that the Image Processing Toolbox is installed and available.
- **Processing takes a long time:** processing time depends on image dimensions, selected filter, and noise density. Test with a smaller image first if needed. Median and adaptive median filtering can take longer than Mean or Gaussian filtering.
- **The output looks blurred:** Mean and Gaussian filters smooth image details as well as noise. Compare the Median and Adaptive Median results too.
- **The metrics are not displayed:** make sure the selected image was processed successfully. MSE, PSNR, and SSIM are calculated by comparing the restored output with the loaded clean reference image.

## Project limitation

This project is an educational image-processing demonstration. Its results depend on the input image, noise density, filter choice, and implementation settings. The filters may remove some image details while suppressing noise; therefore, the highest metric value should not be treated as proof that every visual detail has been perfectly restored.
"# Image-Processing-Salt-Pepper-Noise-Removal-Studio" 
