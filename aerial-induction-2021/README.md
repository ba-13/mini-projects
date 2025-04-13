# InductionY20

This will have all the links for softwares to be installed, resources for various topics and assignments that will be given to you during the induction period. 

All the links for the references are given in this [doc](https://docs.google.com/document/d/1tlWWxvqxxRihGTLHX_BZnDqyFVVY5CSu_ZV70bWjWLI/edit).

---

# Assignments

Assignment questions/tasks will be uploaded in the assignmenty20 folder and for submission follow these instructions: 

1. Fork the repository using the button on top right corner.
2. Clone this forked repo on your laptop using the command

```
git clone https://github.com/${your_username}/InductionY20
```
<!-- 3. Create a new branch using the command ( keep your branch name ariitk/name_inductiony20)
```
git checkout -b ${your_branch_name}
``` -->
### Pushing your work back up to your fork: 

4. Navigate to the top-level repo directory and:
``` 
git add .
git commit -m "Explainative commit message"
git push origin main 
``` 
5. Try to follow this convention for writing your commit message: Write as if you're giving an instruction to someone which should explain what you've done in the commit. Eg. Instead of "Added submission file" write "**Add** submission file". For the convention guide you can refer to [this](https://chris.beams.io/posts/git-commit/).
### Submit a Pull request so that we can review your changes:

6. Create a new pull request from the `Pull Requests` tab on this repo, not the fork.

### Ediiting files after you've made a Pull Request :

7. Simply commit and push to your branch. It automatically gets added to the Pull Request as well

### Updating your forked repository for **New Assignments** :

8. Firstly add a new remote using the command: (You have to do this command only once. No need to repeat this step again and again for every assignment.)
```
git remote add upstream https://github.com/AerialRobotics-IITK/InductionY20
```
```
git pull upstream
```
9. To pull the new assignment in your fork follow these sequential commands:

```
git checkout upstream/main
```
```
git pull upstream main
```
```
git checkout main
```
```
git merge upstream/main
```

10. Now you'll be able to see the new assignment in the respective folder and can repeat the submission steps to create another Pull Request for the new assignment.

---

# Tentative Timeline for Induction
This is a rough timeline with dates subject to change according to the situation. Also a brief overview of what has to be done in that period is given. 

---
## Part 1 | Installation | 12-13 May
- Installation of Ubuntu 18.04 ([Installation Guide](https://rajneesh44.medium.com/dual-booting-ubuntu-in-ssd-with-windows-installed-b2ffcfc7b452))
- To be installed:
    - [ros_melodic](http://wiki.ros.org/melodic/Installation/Ubuntu)
    - [Gazebo](http://gazebosim.org/tutorials?cat=install&tut=install_ubuntu&ver=9.0)
    - git (sudo apt-get install git)
    - vscode (sudo snap install --classic code)
    - [QGroundControl](https://docs.qgroundcontrol.com/master/en/getting_started/download_and_install.html)
    
---
## Part 2 | The basics of programming | 14-16 May
- [Introduction to basic linux commands](https://medium.com/swlh/basic-linux-commands-we-should-all-know-35e646d38a08)
- [Introduction to open source , git and github](https://www.youtube.com/watch?v=cEGIFZDyszA&list=PL6gx4Cwl9DGAKWClAD_iKpNC0bGHxGhcx)
- Basic Programming (if else ,switch , loops, pointers) and Assignment 1 for the same
- Basic Data Structures in C++ using [STL](https://www.geeksforgeeks.org/the-c-standard-template-library-stl/) and Assignment 2 for the same.

---

## Part 3 | Basics of Hardware and Design| 17-18 May
- An introduction to aerodynamics of the quadrotor and its components
- Control theory introduction along with implementation of PID controller
- Tutorial on Blender and AutoCAD, both important softwares when it comes to designing your aerial vehicle.
---
## Part 4 | Introduction to OOPs | 19-20 May
- Introduction to objects, classes , methods ,inheritance in [C++](https://www.w3schools.com/cpp/cpp_oop.asp). 
---

## Part 5 | Introduction to ROS | 21-26 May
- Here you'll be introduced to basics of ROS and how to setup a ROS based pipeline for a project. 
- This topic will be divided into 3 lectures along with mulitple tutorials for practice. You'll also be given assignments to complete which would be available in the assignments folder.
- Here's the official [wiki](http://wiki.ros.org/Documentation) which should be used as a constant reference
---
## Part 6 | Gazebo basics | 27-28 May
- Overview of the Gazebo environment, handling models and sdf files to simulate different components of a robot. Here's the official [wiki](http://gazebosim.org/tutorials) which we'll loosely follow.
---
## Part 7 | Basics of Computer Vision | 29-30 May
- Computer vision is another important aspect of autonmous flying robots. Here we'll introduce the [OpenCV](https://docs.opencv.org/master/d1/dfb/intro.html) library.
- Introduction to [CMake](https://cmake.org/cmake/help/latest/guide/tutorial/index.html).
- Also learn to integrate OpenCV modules with ROS architecture using [cv_bridge](http://wiki.ros.org/cv_bridge/Tutorials/UsingCvBridgeToConvertBetweenROSImagesAndOpenCVImages)
---

## Part 8 | PX4 Firmware and QGC | 1-3 June
- Introduction to Firmwares along with tutorials from the official [PX4 wiki](https://docs.px4.io/master/en/)
- Operating QGC along with your gazebo environemnt to give waypoints to a vehicle
---
## Part 9 | Advanced Topics | TBD 
- Path Planning Algorithms
- Gazebo Plugins
- 
---

# Creating Issues
Throughout the induction period and even after that, you'll face a plethora of errors. It is a good practice to document these errors from the start so as to avoid wasting time on them in future and to create an accumulation of these tweaks and solutions to resolve them. For the same, you can upload your error logs by creating an issue where we can resolve them for everyone to refer to in future.

## Steps to create an issue
1. Go to the issues tab and click on the new issue button
2. Follow this [guide](https://github.com/codeforamerica/howto/blob/master/Good-GitHub-Issues.md) which also has a good enough template for writing a good issue.
3. Adding labels is also a good practice so use them if possible
4. Always check closed issues before opening a new one to avoid repititons
---
