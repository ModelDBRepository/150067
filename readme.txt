
This is the readme for the model associated with the publication:

1. Garrido JA, Luque NR, DÕAngelo E and Ros E (2013) Distributed cerebellar plasticity
implements adaptable gain control in a manipulation task: a closed-loop robotic 
simulation. Front. Neural Circuits 7:159. doi: 10.3389/ fncir.2013.00159

Abstract: 

Adaptable gain regulation is at the core of the forward controller operation performed by
the cerebro-cerebellar loops and it allows the intensity of motor acts to be finely tuned 
in a predictive manner. In order to learn and store information about body-object dynamics 
and to generate an internal model of movement, the cerebellum is thought to employ long-
term synaptic plasticity. LTD at the PF-PC synapse has classically been assumed to 
subserve this function (Marr, 1969). However, this plasticity alone cannot account for the 
broad dynamic ranges and time scales of cerebellar adaptation. We therefore tested the 
role of plasticity distributed over multiple synaptic sites (Hansel et al., 2001; Gao et 
al., 2012) by generating an analog cerebellar model embedded into a control loop connected 
to a robotic simulator. The robot used a three-joint arm and performed repetitive fast 
manipulations with different masses along an 8-shape trajectory. In accordance with 
biological evidence, the cerebellum model was endowed with both LTD and LTP at the PF-PC, 
MF-DCN and PC-DCN synapses. This resulted in a network scheme whose effectiveness was 
extended considerably compared to one including just PF-PC synaptic plasticity. Indeed, 
the system including distributed plasticity reliably self-adapted to manipulate different 
masses and to learn the arm-object dynamics over a time course that included fast learning 
and consolidation, along the lines of what has been observed in behavioral tests. In 
particular, PF-PC plasticity operated as a time correlator between the actual input state 
and the system error, while MF-DCN and PC-DCN plasticity played a key role in generating 
the gain controller. This model suggests that distributed synaptic plasticity allows 
generation of the complex learning properties of the cerebellum. The incorporation of 
further plasticity mechanisms and of spiking signal processing will allow this concept to 
be extended in a more realistic computational scenario.

----------------------------------------------------------------------------------

Prerequisites:

In order to run this model you need the following software:
- Matlab and simulink. It has been tested with Matlab 2013a, but older versions should be 
compatible too.
- Robotics Toolbox for Matlab Release 8. It can be found in this link
(http://petercorke.com/Robotics_Toolbox.html). Newer versions might not be compatible 
since important changes have been done from release 9. Be sure that all the Robotics 
Toolbox subfolders are in your Matlab path.
- C++ compiler to compile the cerebellum model and other modules.

----------------------------------------------------------------------------------

Compiling the cerebellar model:

This instructions are though for compiling in Mac OS X. Similar steps should be followed 
in Unix systems (also with gcc compiler) and equivalent with Windows systems (it has been 
tested by using Visual Studio .NET. More information about the supported compilers with 
any Matlab version can be found in the site 
http://www.mathworks.it/support/sysreq/previous_releases.html.

- Unzip the model .zip file.

- Go to the EDLUTAbstract subfolder.

- Open and edit the makefile file.

- Set the matlabrootdir variable to your system setting. In Mac OS X and with Matlabr2013a 
this path is:

matlabrootdir := /Applications/MATLAB_R2013a.app/

- Set the mex32suffix and mex64suffix according to your operating system (mexglx and 
mexa64 for Unix systems, mexmaci and mexmacia64 for MAC systems, mexw32 and mexw64 for 
Windows systems). If you are not sure about your system, just run mextext command on 
MATLAB command line.

mex32suffix := mexmaci
mex64suffix := mexmaci64

- Compile the source files of the cerebellar model with the makefile.

make

- If everything goes as expected a new file has been created in the sfunction folder with 
name EDLUTAbstract.mexmaci64 (or a different extension depending on the operating system 
and the architecture).

----------------------------------------------------------------------------------

Compiling other control loop modules:

- From the MATLAB command line go to the MEX subfolder

- Compile fRBFcontext1.c:

mex fRBFcontext1.c

- Compile fRBF.c:

mex fRBF.c

- Add all the subfolders of the model to the MATLAB path.

----------------------------------------------------------------------------------

Compiling Robotics Toolbox mex sources:

- Go to the robottoolbox/mex folder

- Compile frne module:

mex frne.c ne.c vmath.c

- Add all the subfolders of the robotic toolbox to the MATLAB path.

----------------------------------------------------------------------------------

Running the simulation:

- From matlab command line just lunch the script LaunchSimulink.m. In this file you can 
set some simulation parameters (e.g. simulation length, time-step, mass under 
manipulation) and after finishing the simulation it shows several figures with some data 
of the simulation. For more information, please check the file LaunchSimulink.m.


----------------------------------------------------------------------------------

Files included in this zip:

The following files are included:
- LaunchSimulink.m: The main script to run and visualize the simulation.
- Video3D.m: Matlab script that generates a movie with the simulation data. Several 
parameters of the video can be set inside.
- EDLUTSimulink.mdl: Simulink model of the robotic platform.
- Parametros.txt: In this file the parameters of the learning rules have been defined.
- *.mat: All the mat files provide the robotic arm model when manipulating a mass (the 
files for 1kg, 1.5kg, 2kg, 2.5kg, 5kg, 6kg, and 10kg are provided.
- EDLUTAbstract folder: Source code of the cerebellar model.
- Other matlab files that are internal functions called from the simulator.
 
----------------------------------------------------------------------------------

This model files were supplied by Jesus Garrido. If you have any question/comments/
feedback, please send me an email to jesus.garrido at unipv.it.
