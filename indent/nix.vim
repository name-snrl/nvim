" Vim indent file
" Language:	Nix

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" To make Vim call GetLuaIndent() when it finds '\s*end' or '\s*until'
" on the current line ('else' is default and includes 'elseif').
setlocal indentkeys+=;,0=then,0=inherit,0=in,*<Return>
setlocal indentexpr=GetNixIndent()

" Only define the function once.
if exists("*GetNixIndent")
  finish
endif

function! GetNixIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)
  let ind = indent(lnum)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  " Add a 'shiftwidth' after lines that start a block:
  " 'if', 'then', 'else', 'in', 'let', 'inherit', '{', '[', '', ':'
  let prevline = getline(lnum)
  let midx = match(prevline, '^\s*\%(if\>\|then\>\|else\>\|let\>\|inherit\>\)')
  if midx == -1
    let midx = match(prevline, '\({\|=\|''''\|:\|[\)\s*$')
  endif

  if midx != -1
    " Add 'shiftwidth' if what we found previously is not in a comment and
    " an "end" or "until" is not present on the same line.
    if synIDattr(synID(lnum, midx + 1, 1), "name") != "nixComment" && prevline !~ '\<end\>\|\<until\>'
      let ind = ind + shiftwidth()
    endif
  endif

  " Subtract a 'shiftwidth' on end, else, elseif, until and '}'
  " This is the part that requires 'indentkeys'.
  let midx = match(getline(v:lnum), '^\s*\%(else\>\|in\>\|''''\|]\|}\)')
  if midx != -1 && synIDattr(synID(v:lnum, midx + 1, 1), "name") != "nixComment"
    let ind = ind - shiftwidth()
  endif

  return ind
endfunction
