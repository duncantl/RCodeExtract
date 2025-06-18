
# RCodeExtract


When working with student's code, e.g, grading, I often want to 
extract the code and 

+ analyze it
+ source only the functions into R (into a separate environment)


While I ask for a .R file, I often get the code as a

+ Rmarkdown
+ HTML
+ PDF

file.


While one can cut-and-paste code from HTML and PDF files, 
this of course is manual and error-prone.
For PDF files, the PDF viewer often (for me) 

+ discards line breaks
+ changes certain characters (e.g., `^` - important in regular expressions)
+ misses text in margins
+ doesn't necessarily select all contiguous text.

In other words, we have to deal with how an application extracts and copies text to 
the clipboard.


## Usage


### `sourceFuns()` & `funs()`


```r
sourceFuns(file)
```

This extracts the code from the specified file
and `source()`s only the functions into the global environment.

```r
e = new.env()
sourceFuns(file, e)
e$fun()
```
This version does the same but `source()`s the 
functions into the specified environment. 


`funs()` is a short-hand/convenience function that creates a new environment
calls `sourceFuns()` and returns the environment:

```r
e = funs(file)
e$fun()
```


###  `getRCodePDF()` & `getRCodeHTML()`

These extract the R code from an PDF and HTML document, respectively,
and return it as text (or lists of text for PDF).

These are intended to work with documents generated via Rmarkdown.

