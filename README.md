# 12.747 Problem Set #3

**Instructions:** Download all your files before starting MATLAB. Write an ```m-file``` to reproduce your analysis and upload the ```m-file``` to GitHub. See **12.747 Problem Set Format Instructions** at the end of this problem set for details.

In this problem we are going to explore the uses of **PCA and Factor Analysis (FA)** on real oceanographic data. To get you started we suggest that you download the ```satl.dat``` data set into your working directory now. This is some basic bottle data from the South Atlantic Ventilation Experiment (SAVE), this has data necessary for this PCA/FA problem. While it is downloading let's consider what needs to be accomplished by first examining what you've got. The data file you are downloading contains the following information in the corresponding columns:

Lat. | Long. | depth | temp. | salinity | O2 | PO4 | NO3 | NO2 | SiO2 |
 --- | --- | --- | --- | --- | --- |  --- | --- |  --- | --- |
 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
deg. | deg. | m | deg. C | ND | µmol/kg| µmol/kg | µmol/kg | µmol/kg | µmol/kg |

One word of caution, I strongly recommend that you avoid the use of the word "save" in naming your variables due to the antisocial interactions with MATLAB's ```save``` function (hence I use ```satl```).

To help you get started we are providing a ```m-file``` (function) to calculate the PCAs and some attendant information, you can download the file ```pca2.m``` to get this function.

Now suppose that you suspect that there are at least two underlying factors that are responsible for the distribution of these variables: biogeochemical processes (photosynthesis, respiration, etc.) and physical processes (precipitation, upwelling, etc.). Let's see if you can design a principal component--factor analysis to elucidate these factors.

#### a) First things first, after you have loaded the data, "look at the data". Using MATLAB's ```subplot``` feature, have your ```m-file``` make a four panel plot of temperature, salinity, oxygen, and nitrate all vs. depth. From these plots it should be clear that a separation of the data by depth is in order.

Separate the data into two matrices, one with everything above 1000 m and one with everything below 1000 m. Hint: MATLAB does it like this:
```Matlab
Xupp = satl(satl(:,3)<=1000,4:10);
Xlwr = satl(satl(:,3)>1000,4:10);
```
This command also removes the variables longitude, latitude and depth from the PCA/FA. Is this a good thing? PCA looks for patterns within the data set among and between variables. The location information will be of use in the next assignment (i.e. where the factors are). There is a certain general, monotonous regularity to depth data, have your ```m-file``` display a short note as to why it shouldn't be included in the analysis.

Note that ```pca2.m``` gives you the option to standardize the data into standard normal Z-scores using:

![002](img/image002.gif)

via ```colstd.m```, download it and study it and make sure you know how it works. Here the subscript i refers to the ith observation/sample and the subscript j refers to the jth variable measured. For future reference, download ```rowstd.m``` too.

#### Discuss whether or not you think the data should be standardized; this decision will effect the results of the rest of the problem, so think about it.

#### b) Calculate the eigenvectors, eigenvalues, factor matrix, and factor scores of both ```Xupp``` and ```Xlwr``` with ```pca2.m```. Have your ```m-file``` display only the eigenvectors, the eigenvalues summary table and the factor matrix (loadings).

Remember that the principle components come from the relationship between the singular values of the data matrix (X) and the eigenvalue/eigenvectors of the covariance matrix (R):

![004](img/image004.gif)

where V contains the M eigenvectors and S the diagonal matrix of singular values of X. The singular values are also the square roots of the eigenvalues (Λ) of the covariance matrix:

![006](img/image006.gif)

which are given by the eigenvalue equation:

![008](img/image008.gif)

But in Matlab you can get them from them:
```Matlab
[U lam] = eig(cov(X))
```
notice how you can embed one MATLAB command inside another? Or you could use the ```m-file``` provided to you and X can be standardized or not depending on the value set in the standardization flag in ```pca2.m```. The factor matrix is given by:

![009](img/image009.gif)

and the principle component scores are given by:

![010](img/image010.gif)

#### c) Calculate the communalities of the factors, both above and below 1000m, and report the values. You remember that the communalities are given by:

![011](img/image011.gif)

Here the j refers to the jth variable and the r refers to the rth factor. In PCA j and r range from 1 to M, but this isn't always the case in factor analysis. From a computational point of view, the idea is to sum horizontally across the factor loadings.

#### What do these values represent?

#### d) Here is where we "cross over the line" between PCA and factor analysis. Based on the loadings, magnitudes of the eigenvalues and the communalities, how many factors should be kept for ```Xupp``` and ```Xlwr```? How much variance do they account for? What are their communalities?



**NOTES:**

**1) Remember to use the help feature, if in doubt what a particular ```m-file``` does, use:**

```Matlab
help filename.m
```

and MATLAB will list the header of the m-file in your window. Good hunting.



# 12.747 Problem Set Format Instructions (for all problem sets)

Below are the instructions that you should use to format and hand in your Problem sets. In general, problem sets should be uploaded to GitHub as an ```m-file(s)```; it’s usually best when there is 1 ```m-file``` per problem. ```m-files``` are executable program files; a proper answer will be an m-file that we can execute in Matlab. As a result a successful program will download the necessary data, print text and make graphics using the many features of Matlab.

**Starting Out**

These initial steps include instructions on how to set up your file structure and start programming “in Matlab”. Each time you modify your “```m-file```”, you can save it and then execute it in Matlab to see what it does. With both windows open you can go back and forth between the editor and Matlab alternately tweaking your program and then running it until it does exactly what you want it to do. This method will allow what I am sure will be many hours of totally uninterrupted programming fun and unsurpassed modeling pleasure!

We want the answers uploaded to GitHub as part of your repository (there is ONE exception in a problem set later in the semester). The “answers” will be, most of the time, ```m-files``` (that is, Matlab programs) that we will run to check your answers. Sometimes graphics, too, will be part of your answer; the preferred format is one pdf with graphics as either encapsulated PostScript (```.eps files```) OR portable network graphics (```.png files```) OR JPEG files (```.jpg files```). One thing is absolutely important: YOUR ```m-files``` MUST RUN ON OUR MACHINES, WE WILL NOT DEBUG YOUR MISTAKES. Over the years the most common mistake made by students of 12.747 is that they made “one last, SMALL, change” to their code just before submitting it and did not rerun it to make sure it actually still ran. Often they added a simple, but fatal, error with this last minute addition. So, always, always, always make sure your code runs on your machine before your uploading the final version to GitHub. If it runs on your machine, then the odds are greater than 99% it will run on our machines. To maximize your profit while uploading your answers to us, please pay attention to the following suggestions:

Send your answers (```m-files```) via GitHub and give them unique names so we know which one to run e.g. ```PS01_Q1.m```). We will grade the final commit that was pushed to GitHub and it is helpful if you label this commit with a name such as 'final version'

Include a brief header at the beginning of your ```m-file``` (that’s what the %-sign is for in MatLab: comments). In this header, be sure to include the following information: the name of the program (just in case), a brief explanation of what the program does, your name, and the date(s) you worked on the problem (years from now, when you look back to see how you solved this kind of problem in that 12.747 class, you'll be very grateful you had the discipline to include this kind of information). A brief example header is given below:

```Matlab
% PS99_DMG.M in this problem set I demonstrate how the universe can be simulated
% with just three lines of MatLab code.
% SYNTAX:   [U,W,I]=ps99_dmg(X,Y,alpha)
%
% INPUT:    X = a matrix containing the distribution of religions on earth
%           Y = a vector containing the names of known star systems
%           alpha = an insanity parameter that varies from zero to one
% OUTPUT:   U = the universe matrix, distribution of carfloats
%           W = the world matrix, distribution of ring bearers
%           I = index vector containing the indices of ICBM's
%
% Started 2028:09:11 D. Glover, WHOI
% Modif'd 2028:09:12 DMG added insanity parameter to increase stability
% Modif'd 2028:09:13 DMG fixed disp command in my final run before I
% submitted my answer to the instructors.
```

Of course, not every problem will have complex syntax and/or inputs and outputs, but you get the idea: document what you do. Also, note, the versioning comments in the last few lines are the type of information you can use in you GitHub commit names and descriptions.

One more thing, the most common way students, in the past, have lost points on their problem set answers is that they did not READ the question carefully. Be sure to read the question all the way to the end and answer ALL of the questions it asks of you.

**Example m-file**

 You can load data from a file into Matlab by typing ```load demo1.dat``` (return) and ```load demo2.dat``` (return) at the Matlab prompt.
```Matlab
>>load demo1.dat (return)
>>load demo2.dat (return)
```
Now type demo1 at the Matlab prompt; what happens?
```Matlab
>>load demo2.dat (return)
>>demo1 (return)
```
By loading the demo files into Matlab, you have created a variable of the same name that is a single column matrix with the values from ```demo1.dat```.

Now type demo1(1,1) at the Matlab prompt; what happens?

```Matlab  
>>demo(1,1) (return)
```

By using the index information after the variable name, you can select specific values from a matrix. Note the first value is the row number and the second value is the column number.

Now type ```plot(demo1,demo2)``` at the Matlab prompt.
```Matlab
>>plot(demo1,demo2) (return)
```
Note: you should be getting the idea that you have to type return to get Matlab to take the command so I will exclude it from here on in.

Now type the following and watch what happens.

```Matlab
>> title('Demoplot')
>> xlabel('demo1')
>> ylabel('demo2')
>> text(10,100,'here is some text')
```

From this last item, you see that you can put text information right on the plot, suppose you need to be more long-winded? All you need to do is make your answer a string.

```Matlab
a=('The information in the plot clearly shows the blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah...')
```

After you type your well thought out answer and make it a string, to get it to display in Matlab all you have to do is type a
```Matlab
>>a
```
Suppose we wanted to put all of the above commands in 1 executable file?

If we type the following in the editor window:
```Matlab
% This m-file is part of the problem set demo created by T. Kenna on 8/16/98
% note that lines that begin with % are ignored as program lines by matlab
%
% Here comes the real program
%
load demo1.dat % loads the first demo file
load demo2.dat % loads the second demo file
demo1(1,1) % prints the first member of demo1
figure(1)
plot(demo1,demo2)
title('Demoplot')
xlabel('demo1')
ylabel('demo2')
text(10,100,'here is some text')
a=('The information in the plot clearly shows the blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah...')
```
After you create and save this file as classdemo (make sure you save it in current directory), what happens if you now run the file in Matlab?

```Matlab
>>classdemo
```

Now Matlab does everything from downloading the data to plotting to making comments and writing longer answers.

Suppose you had more than one plot for question one, and you wanted to give me control of the pace of the program. For example, after starting classdemo, I would see the first plot and see your longer answer a. If you put a pause command as the next line, this will suspend the program and give me time to read and make sense of what you have said.

Continuing in the editor with ```classdemo.m```, add the following lines:
```Matlab
        disp('hit any key to resume program' )
        pause % This will suspend the program until you are ready to move on
        figure(2)
        plot(sin(demo1),tan(demo2),'*g')
        title('The second plot')
        xlabel('Sine of demo1')
        ylabel('Tangent of demo2')
        b=('Plot number 2 shows the extent to which plot number 2 was yada yada yada')
```
After saving these changes, run ```classdemo.m``` again. Are you getting the picture?
