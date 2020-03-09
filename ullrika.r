# UNDER CONSTRUCTION
# solutions to the epistemic probability challenge problems posed by Ullrika and Scott

source("C:\\Users\\Scott's Surface Pro\\Desktop\\sra arlington 2019\\pba.r")

cfg = function(x, cornering=0, rounding=FALSE) {
  y = rep(0,length(x)); 
  for (i in 1:length(x)) 
    if (cornering < runif(1)) y[[i]] = runif(1, left(x[[i]]), right(x[[i]])) else if (0.5 < runif(1)) y[[i]] = left(x[[i]]) else y[[i]] = right(x[[i]]) 
  if (rounding) y = round(y); return(y) 
  }

###################################################################################################
# for greater precision, increase Pbox$steps
Pbox$steps = 200

# 1.0
# omit roughly
x = c(12.1, 6.45, 73, 24.6, 15.2, 44.3, 19.0)
X = X0 = CBlognormal(x)   
plot(X)
abline(v=100,col='red')
1-prob(X,100)

# 1.1

# 1.2
nondetect = interval(1e-8, 20)
x = c(nondetect, nondetect, 73, 24.6, nondetect, 44.3, nondetect)
X = X1 = env(CBlognormal(left(x)), CBlognormal(right(x)))
for (j in 1:100) {
	X = env(X, CBlognormal(cfg(x)))
	X = env(X, CBlognormal(cfg(x,cornering=1)))
	}                       # this takes a couple of minutes to compute
plot(X, lwd=4, xlim=c(0,2000))
lines(X1) 
abline(v=100,col='red')
1-prob(X,100)

# 1.3
x = c(12.1, 6.45, 73, 24.6, 15.2, 44.3, 19.0)
X0 = CBlognormal(x)
X = env(X0,pbox(0))
plot(X)
abline(v=100,col='red')
1-prob(X,100)

# 1.4
y = c(2.1,55,68,12,26,33,29,36,54,1.0,28,22)
Y = CBnonparametric(y)
Z = X %+% Y            # make no assumption about dependence
plot(Z)
abline(v=100,col='red')
1-prob(Z,100)

# 1.5



# 2.0
p = KN(1, 153)
N = CBpoisson(c(12,0,21,14,6))
Q = 1 - (1-p) %^% N            # make no assumption about dependence
plot(Q)
abline(v=0.05,col='red')
1-prob(Q, 0.05)

# 2.1
p = KN(interval(0,1), 153)
N = CBpoisson(c(12,0,21,14,6))
Q = 1 - (1-p) %^% N            # make no assumption about dependence
plot(Q)
abline(v=0.05,col='red')
1-prob(Q, 0.05)

# 2.2
p = KN(1, 153)
n = c(rep(interval(0,4),6), rep(interval(5,9),4), rep(interval(10,14),8), rep(interval(15,19),3), rep(interval(20,24),1), rep(interval(25,29),1))
n = c(n, 12,0,21,14,6)
N = env(CBpoisson(left(n)), CBpoisson(right(n)))
Q = 1 - (1-p) %^% N            # make no assumption about dependence
plot(Q)
abline(v=0.05,col='red')
1-prob(Q, 0.05)

# 2.3
p = KN(interval(0,1), 153)
N = CBpoisson(c(12,0,21,14,6))
Q = 1 - (1-p) %\^\% N          # p increases with N, so (1-p) decreases with N 
plot(Q)
abline(v=0.05,col='red')
1-prob(Q, 0.05)







###################################################################################################
# something like the following should work to generalise sum, log, etc. so they work on lists of intervals
#
#sum.list = function(...) {x=list(...); y=x[[1]]; for (i in 2:length(x)) y = y + x[[i]]; return(y)}
#if(!isGeneric("sum")) quiet <- setGeneric("sum", function(..., na.rm = FALSE) standardGeneric("sum"))
#quiet <- setMethod('sum', 'list', function(..., na.rm = FALSE) sum.list(...))
#
#log.list = function(x, base = exp(1)) {y=x; for (i in 1:length(x)) y[[i]] = log(x[[i]],base); return(y)}
#if(!isGeneric("log")) quiet <- setGeneric("log", function(x,base = exp(1)) standardGeneric("log"))
#quiet <- setMethod('log', 'list', function(x, base = exp(1)) log.list(x,base))
#
###################################################################################################
# but it DOESN'T work because certain things are unhelpfully "sealed"
#
#>quiet <- setMethod('sum', 'list', function(..., na.rm = FALSE) sum.list(...))
#Error in setMethod("sum", "list", function(..., na.rm = FALSE) sum.list(...)) : 
#  the method for function ‘sum’ and signature x="list" is sealed and cannot be re-defined
#
#> quiet <- setMethod('log', 'list', function(x, base = exp(1)) log.list(x,base))
#Error in setMethod("log", "list", function(x, base = exp(1)) log.list(x,  : 
#  the method for function ‘log’ and signature x="list" is sealed and cannot be re-defined
 




###################################################################################################
# what are the c-boxes for Poisson and lognormal when the input data are intervals?

n = c(rep(interval(0,4),6), rep(interval(5,9),4), rep(interval(10,14),8), rep(interval(15,19),3), rep(interval(20,24),1), rep(interval(25,29),1))
N = c(n,12,0,21,14,6)
plotem(N)
m = cfg(N)
for (i in m) abline(v=i, col=2)
for (i in cfg(N,cornering=1,rounding=TRUE)) abline(v=i,col=4)

###################################################################################################
# enveloping the c-boxes from the left endpoints and the right endpoints works for Poisson 
# probably just because it's got a single parameter
A = env(CBpoisson(left(N)), CBpoisson(right(N)))
plot(A, lwd=4)
for (j in 1:500) {
	a = CBpoisson(cfg(N,rounding=TRUE))
	lines(a,col='red')
	a = CBpoisson(cfg(N,cornering=1,rounding=TRUE))
	lines(a,col='blue')
	}

###################################################################################################
# enveloping the c-boxes from the left endpoints and the right endpoints DOES NOT work for lognormal 
# because it's got multiple parameters.  So maybe a brute-force approach for this distribution.

nondetect = interval(1e-8, 20)
x = c(nondetect, nondetect, 73, 24.6, nondetect, 44.3, nondetect)
A = env(CBlognormal(left(x)), CBlognormal(right(x)))
plot(A, lwd=4, xlim=c(0,2000))
for (j in 1:500) {
	a = CBlognormal(cfg(x))
	lines(a,col='red')
	a = CBlognormal(cfg(x,cornering=1))
	lines(a,col='blue')
	}


