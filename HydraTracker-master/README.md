# HydraTracker
Automated tracking of Hydra behaviors



## Workflow

**Experiment Directory-->Initialization-->BinaryFeatureExtraction-->HydraBehaviorAnalysis**

### Experiment Directory:

Contains multiple video files from one experiment. *(Recordings last ~2days and each video file is ~4 hours of images)*
*Pending feature: ensure the video files are in chronological order.*

### Initialization:

Use *Hydra ROI.app* to create initialization file.
1. Crop frame for each hydra: Draw rectangle around each hydra chamber.
2. Initialize start position of hydra: Annotate foot, center and mouth coordinates.
3. Create background frame: Draw around Hydra to create background frame.

*Pending Features:*
There is no error checking correctly. Assumes normal case scenario.

Assumptions:
1. File path should be correct.
2. Video files assumed to be are either .mp4 or .avi

*Known issues:*

*1. Frame Cropping ROIs:*
   - Clicking Add ROI while current ROI is not finalized will cause error. Finalize ROI by double clicking the selection.
	 
*2. Initialize Hydra Position:*
   - none known
	 
*3. Background Frame Hydra Mask:*
   - Auto mask feature for background frame creation is not working properly.
	 - Manual ROI selection seems to be fine
	 
### BinaryFeatureExtraction

Parallelize tracking of multiple hydra per frame
