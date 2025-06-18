library(ReadPDF)

getRCode = 
function(doc, fill.color = guessRFillColor(doc))
{
    if(is.character(doc))
        doc = readPDFXML(doc)

    recs = lapply(doc[], getBBoxRCode, fill.color, TRUE, color = TRUE)

    w = sapply(recs, nrow) > 0

    if(!any(w))
        return(list())

    codeByPage = mapply(getPageCode, doc[][w], recs)
    # need to merge or can we just combine across pages.
    codeByPage
    
}

# 63737,63737,63737
# 61931,62455,62980
getBBoxRCode =
function(page, fill.color, ...)
{
    xp = sprintf(".//rect[@fill.color = '%s']", fill.color)
    rects = getNodeSet(page, xp)
    getBBox(rects, ...)
}


getPageCode =
function(page, boxes = getBBoxRCode(page, guessRFillColor(page), TRUE, color = TRUE), bb = getBBox2(page, TRUE))
{
    #   apply(boxes, 1, getBoxCode, bb = bb)
    r = split(boxes, 1:nrow(boxes))
    lapply(r, getBoxCode, bb, page)
}

getBoxCode =
function(box, bb, page)
{
    w = bb$top <= box$y0 & bb$top + bb$height >= box$y1

    nodes = getNodeSet(page, ".//text")

    bb2 = bb[w, ]
    ll = nodesByLine(nodes[w], bbox = bb2)
    fixCode(unname(sapply(ll, mkLine)))
}

mkLine =
function(nodes, sep = " ")
{
    txt = sapply(nodes, xmlValue)
    txt = unname(txt)
    paste(txt, collapse = sep)
}

fixCode =
function(txt)
{
    txt = gsub("&quot;", '\\"', txt)
    txt = gsub("&gt;", '>', txt)
    txt = gsub("&lt;", '<', txt)
    txt = gsub("&amp;", '&', txt)

    txt = gsub("ˆ", "^", txt)

    
    # \\\\
    txt
}


getFillColors =
function(doc)
{
    if(is.character(doc))
        doc = readPDFXML(doc)    

    table(unlist(getNodeSet(doc, "//rect/@fill.color")))
}

guessRFillColor =
function(doc)
{
    fc = getFillColors(doc)
    w = fc == max(fc)
    if(sum(w) > 1)
        warning("multiple fill.color values with the same frequency")
    
    names(fc)[w][1]
}
