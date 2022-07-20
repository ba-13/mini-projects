# Assignment 3

## Task 1

Implemented 2nd degree Polynomial Regression in Julia from scratch, through mathematically calculating the gradient as well as calculating the gradient via the package `Zygote`.  
The results were quite accurate for coefficients of x^2 and x, while error was quite large for constant term.  
While implementing with Zygote, it was actually taking too long to reach error below 1, so stopped at the value of 44.

---

## Task 2

Implementing derivatives and gradients from scratch in Julia, by percieving the derivative terms as a unique quantity, not unlike how we treat imaginary numbers.  
The main principle was to obtain derivatives, through forward differentiation, by defining a constant ![\epsilon](https://latex.codecogs.com/gif.latex?\epsilon) such that ![equation](https://latex.codecogs.com/gif.latex?\epsilon^2&space;=&space;0).  
This leads to quite convinient process of redefining the representation of derivatives that can be handled quite well algorithmically.  
We use the equation:  
![equation](<https://latex.codecogs.com/gif.latex?f(x&space;+&space;\epsilon)&space;=&space;f(x)&space;+&space;\epsilon\cdot&space;f'(x)&space;+&space;\sigma(\epsilon^2)>)  
Now, implementing basic derivative rules was quite straightforward, we just treated derivatives as linear transformations, which they indeed are, and wrote down few rules that would cover derivatives of the majority of nice functions.  
This was done using the struct _Dual_.

Now for multidimensional functions, gradients hold more meaning. This can still be solved using Duals, Duals can be thought of as a 1D vector, which we adjust accordingly to yield gradients of higher dimensions. It would be much more neat to define, what we call the _MultiDual_ which holds a value, and a direction, i.e. its gradient.  
For example, the coordinate (3,0,0) can be represented as MultiDual(3,(1,0,0)).  
The only difference in implementation part is that we used `SVector` package that increased calculation speed.  
Redefining derivative rules for our new struct _MultiDual_, we obtained, again quite a large range of functions, into which if we input a set of MultiDuals, we obtain another MultiDual, which consists of the function's output as well as gradient at that point.  
Something to NOTE:

- The functions defined for MultiDuals take in input an array, a vector of coordinates.
- Throughout the code, I have assumed the use of Standard Basis for all representations.
- If we define both Structures as a Subset of Number, we need to involve only Float64 in the calculations, otherwise bugs occur. This is due to the fact that Julia involves multiple dispatch, and I haven't defined everything for each kind of number types.

In order to create a wrapper function, the _Gradient_, I used the fact that all MultiDuals are actually, gradients and values, themselves. We are just manipulating them more, by inputing them into functions.  
In order to find the gradient of a function at a coordinate, we need to input the function, and the coordinates as an array to the `Gradient` function.  
The function itself first creates MultiDuals out of each coordinate, pushes that into an array, and then passes the array to the function provided.
This function then returns the output through the `show` function.

In order to approach creating the Jacobian function, we know that the Jacobian is actually the determinant of a matrix consisting of the partial derivatives of the function at the given coordinates.
So implementation has a few drawbacks, but still is general.  
You have to modify the function whose Jacobian you are calculating, directly inside the `Jacobian` function. It can be extended to any number of dimensions as long as the input is consistent.  
You also have to modify the `final` array, to add the added dimensions in the output.  
The output is an array of SVectors, therefore is always consistent, i.e. you don't need to have a same dimensional Input and Output Space.  
This project was quite fun, ngl, would have enjoyed if it was longer.

---

Credits:

- [Pramodh Gopalan](https://github.com/Pramodh-G)
- [Som Tambe](https://github.com/SomTambe)
