# An Exploration of Computer Based Pointillism
This repository contains code used in Katarina Hoeger's exploration of pointillism using a computer.

![Red Dots of different sizes overlap on a white background to form an abstract apple](publicDomainAppleSample.jpg "Computer-Based Pointillism Apple")
## Why This Technique?

### Pointillism
Pointillism was developed in 1886 by [Georges-Pierre Seurat](https://www.moma.org/collection/works/79333?sov_referrer=art_term&art_term_slug=pointillism).
It involves creating shapes by using small dots of color.

### Inspiration
During Summer 2021, Katarina wanted to modify a photograph using different image processing coding techniques in processing.
She stumbled across code for [pointillism](http://learningprocessing.com/examples/chp15/example-15-14-Pointillism).
Using this as a base, she started making changes with the code, slowly changing the aesthetic of the output.

### Major Ideas
- To Katarina, a non-painter, the painting process looks like the following: Painters often layer paint, with wider, less precise, and more translucent brushstrokes in the background. They often add thinner, more precise, and bolder brushstrokes on top. The code should emulate this.
- A picture is a dataset. If you can access the Red, Green, Blue, and Alpha values of a reference picture, you can use that data to construct a facsimile of the picture.
- Computer users can take advantage of pseudorandom numbers to generate unique but recognizably similar in style copies of the original picture.

## Message to Users
If you use this code, I would appreciate seeing any output you share.
Feel free to contact me here, tweet at or dm me on [twitter](https://twitter.com/kfhoeger), or email me at [katarina@katarinahoeger.com](mailto:katarina@katarinahoeger.com).
Feel free to share suggestions about how to make this repo easier to use / more accessible.
It is the first repo I have worked on that I could potentially see others using. 

## Code-based Exploration
### Code Types
#### Basic Code Available
- Make picture using dots, watch dots appear one by one
- Make picture using dots, faster / "efficiently"
- Make picture using other shapes (needs to be added to only repo)

#### Not Yet Adequately Tested
- More efficient method of determining number of dots placed

### Testing Limits
In progress - Katarina is currently generating examples of what types of pictures works well with each type of code.
She is also seeing what turns out poorly, and trying to figure out why.

#### Observations:
- Fantastic clouds, gravel, and general landscapes
- Best with high contrasting colors
- Best outcomes when granularity is large
- Lines are difficult to perceive
- Shape choice effects picture output greatly
- Watching dots getting placed is interesting

### To Do
- Automatically choose background color with [k-means clustering](https://victorangeloblancada.github.io/blog/2019/10/01/color-palette-clustering.html)
- 3D dots
- Moving dots
- Shaders to produce dots
