sourceFuns =
function(file, env = globalenv())
{
    ex = tools::file_ext(file)
    switch(ex,
           html = sourceFunsHTML(file, env),
           txt =,
           r = ,
           R = sourceFunsR(file, env),
           Rmd = sourceFunsRmd(file, env),
           stop("unhandled extension ", ex))
}

sourceFunsR =
function(file, env = globalenv())    
{
    fns = CodeAnalysis::getFunctionDefs(file)
    lapply(names(fns), function(id) assign(id, fns[[id]], env))
    invisible(fns)    
}
    
sourceFunsRmd =
function(file, env = globalenv())    
{
    o = tempfile()
    knitr::purl(file, output = o, quiet = TRUE)
    sourceFunsR(o, env)
}


library(XML)
sourceFunsHTML =
function(file, env = globalenv())    
{
    doc = htmlParse(file)
    p = getNodeSet(doc, "//pre[@class = 'r']")
    txt = sapply(p, xmlValue)
    code = parse(text = paste(txt, collapse = "\n\n"))
    
    sourceFunsR(code, env)
}

sourceFunsPDF =
function(doc, env = globalenv())
{
    
}


funs =
function(file)
{
    e = new.env()
    sourceFuns(file, e) 
    e
}
