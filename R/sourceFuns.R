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
           xml = ,
           pdf = sourceFunsPDF(file, env),
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

getRCodeHTML =
function(file)
{    
    doc = htmlParse(file)
    p = getNodeSet(doc, "//pre[@class = 'r']")
    sapply(p, xmlValue)
}


sourceFunsHTML =
function(file, env = globalenv())    
{
    txt = getRCodeHTML(file)
    code = parse(text = paste(txt, collapse = "\n\n"))
    sourceFunsR(code, env)
}

sourceFunsPDF =
function(doc, env = globalenv())
{
    txt = getRCodePDF(doc)
    code = parse(text = paste(unlist(txt), collapse = "\n\n"))    
    sourceFunsR(code, env)
}


funs =
function(file)
{
    e = new.env()
    sourceFuns(file, e) 
    e
}
