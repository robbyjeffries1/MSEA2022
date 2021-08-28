### Hello World for Lecture 2
## 2021-08-26
print("hello world")

help("print")

### Data structures

## vectors

# character

c("A", "B", "c")

class(c("A", "B", "c"))


## numeric

class(c(1, 2, 3.5))

class(c(1:3))

1:500


seq(1, 500, by = 10)

### logical

c(T, F, TRUE, FALSE, F)


### factors


### Dates and times

Sys.Date() - 0:10

Sys.time()

### Matrices


matrix(1:12, 3, 4)

### lists

kitchen_staff <- list( chef = "Alice", 
      sous = "Bob", 
      washer = "Michael")

kitchen_staff

### assignment
## <-

### indexing

kitchen_staff["chef"]

kitchen_staff$chef

### data frames
## simply a named list where each item/variable 
## has the same length

mtcars

head(mtcars)

mean(mtcars$qsec)

class(mtcars$qsec)

### "base R" plotting
plot(mtcars$hp, mtcars$qsec)

### install a new package

install.packages("ggplot2")
