clc;clear;

A = [1,2,4,1;
    6,5,4,7;
    7,8,5,4;
    1,2,5,4;
    9,8,7,4]

B = 2.*A

largo_A = size(A,2)
largo_B = size(B,2)

if largo_A>largo_B
    A = A(1:largo_B,1:largo_B)
    B = B(1:largo_B,1:largo_B)
else
    B = B(1:largo_A,1:largo_A)   
    A = A(1:largo_A,1:largo_A)   
end

