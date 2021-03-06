# FeatureExtractorCuda
A MRI Haralick's feature extractor accelerated by Cuda

## Installation

### Requirements

You must have an Nvidia Gpu on your system before being able to install & run the Sw. That's the only requirement since the CUDA Framework can be installed on many platforms.

### Cmake 3.8

If you want to build this project, you need to have `Cmake 3.8` or higher that introduced native CUDA support.
Download the files and follow the installation instructions at https://cmake.org/download/


### OS

On the Nvidia CUDA Installation reference you can see the list of supported Os for each Cuda version.
Also, you must be SURE that the kernel you are using is listed on the same guide as supported kernel for that Cuda release.

In my case I installed Ubuntu 16.04 and had to downgrade the Kernel to 4.10.0-42

### OpenCV

To acquire images the project uses the OpenCv library
I just used the script provided at https://milq.github.io/install-opencv-ubuntu-debian/

To install openCv from source file on a Linux system:
* Download OpenCv 3.4.1 and extract it
* Create a folder "build" and enter into it `cd build`
* `cmake ..` for creating the make file in the parent directory
* `make` to compile the library
* `sudo make install` to export openCv into the system libraries
	After this you can delete the downloaded folder 

Detailed installation guide at https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html

### Cuda

On my laptop I have a dedicated Nvidia GPU and the Intel's integrated CPU and I wanted to use the latter to manage rendering of every applications leaving the Nvidia GPU to run only Cuda SW avoiding system freeze that could happen with time consuming operations.

I installed Cuda 8 since Cuda 9 had some instability that I wanted to avoid

#### Download

I choose to install Cuda via Runfile.

I had to download:
* Cuda 9 Framework 
* Cuda 8 Framework + Patch

#### Steps

** I will use the default folder locations suggested while installing ** 

* Install latest Gpu Driver from Cuda9
	* Open a shell with `ctrl+alt+f1`
	* Stop the graphic server `sudo service lightdm stop`
	* Make the Cuda9 Runfile executable `chmod +x cuda_9_..._.run`
	* Launch the runfile `./cuda_9_....run --override`
	* Accept the contract
	* ACCEPT installation of the Driver
	* Refuse overwriting of the X display server (allowing this would mean that the only Gpu used by the system will be the Nvidia GPU while we want to use that only for executing Cuda sw )
	* Refuse overwriting of OpenGL
	* Refuse installation of the Cuda Framework (we will use Cuda8 Framework)
	* Reboot
	* Check with `nvidia-smi` if communication with the Gpu is ok (** Note: No process should be using the NvidiaGpu)
* Install Cuda8 Framework
	* Open a shell with `ctrl+alt+f1`
	* Stop the graphic server `sudo service lightdm stop`
	* Make the Cuda8 Runfile executable `chmod +x cuda_8_..._.run`
	* Launch the runfile `./cuda_8_....run --override`
	* Accept the contract
	* Refuse installation of the Driver
	* Refuse overwriting of the X display server 
	* Refuse overwriting of OpenGL
	* ACCEPT installation of the Cuda Framework (we will use Cuda8 Framework)
	* Reboot
	* Check with `nvcc --version` if the framework was correctly installed
		If `nvcc` isn't found you should export paths to the directories where Cuda was installed editing ` ~/.bashrc` appending
		`export PATH=/usr/local/cuda-8.0/bin:$PATH
		export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH`
* Install Cuda8 patch
	* Open a shell with `ctrl+alt+f1`
	* Make the Cuda9 Runfile executable `chmod +x cuda_8_..._.run`
	* Launch the runfile `./cuda_8_....run --override`



### MRI Image Viewer
Since MRI images have high-depth color representation (tipically 16 bit for each pixel) you need to install specialized software before beeing able to view an MRI image on your pc.

For this reason I suggest the installation of ImageJ, an open source tool able to display MRI images encoded in a variety of formats such DICOM, TIF, etc.

On my machine running Ubuntu 16.04 I just needed to execute:
`sudo apt install imagej`

## Feature Extracted

At this moment, only Haralick's Textural Feature extraction is supported

## Compilation

If you want to use or modify the code provided you must: 
* Navigate to the implementation folder of interest
* `cmake CMakeList.txt`
* `make`
* If all the toolkits are present on your machine, an executable file will be put into the `bin` sub-folder

## Command Usage

You must invoke the serial tool with the following syntax:  ./FeatureExtractor [<-s>] [<-i>] [<-d distance>] [<-w windowSize>] [<-n numberOfDirections>] imagePath"

You must invoke the parallel tool with the following syntax:  ./CuFeat [<-s>] [<-i>] [<-d distance>] [<-w windowSize>] [<-n numberOfDirections>] imagePath"


### Command Options

* `-s` create and save feature images from the values of the features
* `-b border` decide what type of border/padding needs to be applied to the image: none (0), zero pixel (1), symmetric (2)
* `-i inputImagePath` specify the path to the image that needs to be processed
* `-o outputFolderPath` specify the name of the folders where the results will be saved
* `- g` decide if the GLCM that will be created will be symmetric 
* `-d distance` choose the modulus of the vector reference-neighbor
* `-w windowSize` choose the side of each squared window that will be creted
* `-t directionType` choose which direction to consider between 0° (1),45° (2),90° (3) and 135° (4)
* `-h` display usage information
