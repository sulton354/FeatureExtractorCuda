# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/simo/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/181.4668.70/bin/cmake/bin/cmake

# The command to remove a file.
RM = /home/simo/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/181.4668.70/bin/cmake/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/FeaturesExtractor.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/FeaturesExtractor.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/FeaturesExtractor.dir/flags.make

CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o: CMakeFiles/FeaturesExtractor.dir/flags.make
CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o: ../FeatureExtractor.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o -c /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/FeatureExtractor.cpp

CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/FeatureExtractor.cpp > CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.i

CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/FeatureExtractor.cpp -o CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.s

CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o.requires:

.PHONY : CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o.requires

CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o.provides: CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o.requires
	$(MAKE) -f CMakeFiles/FeaturesExtractor.dir/build.make CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o.provides.build
.PHONY : CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o.provides

CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o.provides.build: CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o


CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o: CMakeFiles/FeaturesExtractor.dir/flags.make
CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o: ../GLCM.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o -c /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/GLCM.cpp

CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/GLCM.cpp > CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.i

CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/GLCM.cpp -o CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.s

CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o.requires:

.PHONY : CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o.requires

CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o.provides: CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o.requires
	$(MAKE) -f CMakeFiles/FeaturesExtractor.dir/build.make CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o.provides.build
.PHONY : CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o.provides

CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o.provides.build: CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o


CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o: CMakeFiles/FeaturesExtractor.dir/flags.make
CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o: ../Windows.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o -c /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/Windows.cpp

CMakeFiles/FeaturesExtractor.dir/Windows.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FeaturesExtractor.dir/Windows.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/Windows.cpp > CMakeFiles/FeaturesExtractor.dir/Windows.cpp.i

CMakeFiles/FeaturesExtractor.dir/Windows.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FeaturesExtractor.dir/Windows.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/Windows.cpp -o CMakeFiles/FeaturesExtractor.dir/Windows.cpp.s

CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o.requires:

.PHONY : CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o.requires

CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o.provides: CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o.requires
	$(MAKE) -f CMakeFiles/FeaturesExtractor.dir/build.make CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o.provides.build
.PHONY : CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o.provides

CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o.provides.build: CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o


# Object files for target FeaturesExtractor
FeaturesExtractor_OBJECTS = \
"CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o" \
"CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o" \
"CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o"

# External object files for target FeaturesExtractor
FeaturesExtractor_EXTERNAL_OBJECTS =

FeaturesExtractor: CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o
FeaturesExtractor: CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o
FeaturesExtractor: CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o
FeaturesExtractor: CMakeFiles/FeaturesExtractor.dir/build.make
FeaturesExtractor: /usr/local/lib/libopencv_shape.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_viz.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_stitching.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_ml.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_objdetect.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_superres.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_videostab.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_photo.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_calib3d.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_dnn.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_video.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_features2d.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_highgui.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_videoio.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_imgcodecs.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_flann.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_imgproc.so.3.4.1
FeaturesExtractor: /usr/local/lib/libopencv_core.so.3.4.1
FeaturesExtractor: CMakeFiles/FeaturesExtractor.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX executable FeaturesExtractor"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/FeaturesExtractor.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/FeaturesExtractor.dir/build: FeaturesExtractor

.PHONY : CMakeFiles/FeaturesExtractor.dir/build

CMakeFiles/FeaturesExtractor.dir/requires: CMakeFiles/FeaturesExtractor.dir/FeatureExtractor.cpp.o.requires
CMakeFiles/FeaturesExtractor.dir/requires: CMakeFiles/FeaturesExtractor.dir/GLCM.cpp.o.requires
CMakeFiles/FeaturesExtractor.dir/requires: CMakeFiles/FeaturesExtractor.dir/Windows.cpp.o.requires

.PHONY : CMakeFiles/FeaturesExtractor.dir/requires

CMakeFiles/FeaturesExtractor.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/FeaturesExtractor.dir/cmake_clean.cmake
.PHONY : CMakeFiles/FeaturesExtractor.dir/clean

CMakeFiles/FeaturesExtractor.dir/depend:
	cd /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++ /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++ /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug /home/simo/Sviluppo/Stage/FeatureExtractor/FeatureExtractor/C++/cmake-build-debug/CMakeFiles/FeaturesExtractor.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/FeaturesExtractor.dir/depend

