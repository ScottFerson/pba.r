# pba.r
Probability Bounds Analysis S4 library for the R 

Place this file on your computer and, from within R, select 
File/Source R code... from the main menu.  Select this file and
click the Open button to read it into R.  You should see the 
completion message ":pbox> library loaded".  Once the library 
has been loaded, you can define probability distributions 

    a = normal(5,1)
    b = uniform(2,3)

and  p-boxes 

    c = meanvariance(0,2)    
    d = lognormal(interval(6,7), interval(1,2))   
    e = mmms(0,10,3,1) 

and perform mathematical operations on them, including the 
Frechet convolution such as 

    a  %+%  b

or a traditional convolution assuming independence

    a  %|+|%  b

If you do not enclose the operator inside percent signs or 
vertical bars, the software tries to figure out how the
arguments are related to one another. Expressions such as

    a + b  
    a + log(a) * b    

autoselect the convolution to use.  If the software cannot 
tell what dependence the arguments have, it uses a Frechet 
convolution.  


Variables containing probability distributions or p-boxes 
are assumed to be independent of one another unless one 
formally depends on the other, which happens if one was 
created as a function of the other. Assigning a variable 
containing a probability distribution or a p-box to another 
variable makes the two variables perfectly dependent.  To 
make an independent copy of the distribution or p-box, use 
the samedistribution function, e.g., c = samedistribution(a).


By default, separately constructed distributions such as 

    a = normal(5,1)    
    b = uniform(2,3)

will be assumed to be independent (so their convolution a+b 
will be a precise distribution).  You can acknowledge any
dependencies between uncertain numbers by mentioning their 
dependence when you construct them with expressions like 

    b = pbox(uniform(2,3), depends=a)

You can also make an existing uncertain number dependent on 
another with an assignment like

    b = pbox(b, depends=a)

If the variables are mutually dependent, be sure to make the 
reciprocal assignment

    a = pbox(a, depends=b)

You can acknowledge several dependencies at a time, as with

    d = pbox(d, depends=c(a,b))

but you can't mention an uncertain number in the 'depends' 
array before the uncertain number exists.


As alternatives to independence and (unspecified) dependence, 
you can also specify that an uncertain number is perfectly or 
oppositely dependent on another.

      d = beta(2,5, perfect=a)

or

    d = beta(2,5, opposite=a)

Perfect and opposite dependencies are automatically mutual, 
so it is not necessary to explicitly make the reciprocal 
assignment.  Thus

    a = N(5,1)  
    b = U(2,3, perfect=a)  
    c = N(15,2, perfect=b)

suffices to link c with a and vice versa.  The assignments
automatically make a, b, and c mutually perfectly dependent.  
Naturally, it is not possible to be perfectly (or oppositely) 
dependent on more than one quantity unless they are also 
mutually dependent in the same way.  The indep, perfect, 
opposite and depends functions check whether their two 
arguments are independent, perfectly dependent, oppositely 
dependent, or dependent, respectively.  The depends function 
returns an interval code that is zero if its arguments are 
independent, +1 if they are perfect, etc.


The defined mathematical infix operators include these tabled below.


|   | Auto  | Frechet  | Perfect  |Opposite   |Independent|
|---|---|---|---|---|---|
| Addition  |  +  |  %+%  |  %/+/%  |  %o+o%  |  %\|+\|%
|Subtraction  |  -  |  %-%  |  %/-/%  |  %o-o%  |  %\|-\|%
| Product  |  *  |  %*%  |  %/*/%  |  %o*o%  |  %\|*\|%
| Division  |  /  |  %/%  |  %///%  |  %o/o%  |  %\|/\|%
| Minimum  |    |  %m%  |  %/m/%  |  %omo%  |  %\|m\|%
|Maximum  |    |  %M%  |  %/M/%  |  %oMo%  |  %\|M\|%
|Powers  |  ^  |  %^%  |  %/^/%  |  %o^o%  |  %\|^\|%
|Less than  |  \<  |  %\<%  |  %/\</%  |  %o\<o%  |  %\|\<\|%
|Greater than  |  \>  |  %\>%  |  %/\>/%  |  %o\>o%  |  %\|\>\|%
|Less or equal  |  \<=  |  %\<=%  |  %/\<=/%  |  %o\<=o%  |  %\|\<=\|%
|Greater/equal  |  >=  |  %>=%  |  %/>=/%  |  %o>=o%  |  %\|>=\|%
|Conjunction  |    |  %&%  |   |   |  %\|&\|%
|Disjunction  |    |  %\|%  |  |   |  %\|\|\|%

Note that the operators %*% and %/% (which in R normally
invoke matrix multiplication and integer division) have 
been reassigned.  Also notice that &, |, &&, || have not 
been overloaded for uncertain numbers.  R has sealed those operators, so you must use the 
operators with percent signs to compute conjunctions or 
disjunctions.

Alternatively, the various convolution operations can be accessed by calling functions:

    autoselect(x,y,op)  
    frechetconv.pbox(x,y,op)  
    perfectconv.pbox(x,y,op)  
    oppositeconv.pbox(x,y,op)  
    conv.pbox(x,y,op)  
    positiveconv(x,y,op)  
    negativeconv(x,y,op)  

where `x` anf `y` are the operands and `op` denotes the operation, such as '+'.

