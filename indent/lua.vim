" Vim indent file
" Language:	Lua

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" To make Vim call GetLuaIndent() when it finds '\s*end' or '\s*until'
" on the current line ('else' is default and includes 'elseif').
setlocal indentkeys+=0=end,0=until,*<Return>
setlocal indentexpr=GetLuaIndent()

" Only define the function once.
if exists("*GetLuaIndent")
  finish
endif

function! GetLuaIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)
  let ind = indent(lnum)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  " Add a 'shiftwidth' after lines that start a block:
  " 'function', 'if', 'for', 'while', 'repeat', 'else', 'elseif', '{', '('
  let prevline = getline(lnum)
  let midx = match(prevline, '^\s*\%(if\>\|for\>\|while\>\|repeat\>\|else\>\|elseif\>\|do\>\|then\>\)')
  if midx == -1
    let midx = match(prevline, '\({\|(\)\s*$')
    if midx == -1
      let midx = match(prevline, '\<function\>\s*\%(\k\|[.:]\)\{-}\s*(')
    endif
  endif

  if midx != -1
    " Add 'shiftwidth' if what we found previously is not in a comment and
    " an "end" or "until" is not present on the same line.
    if synIDattr(synID(lnum, midx + 1, 1), "name") != "luaComment" && prevline !~ '\<end\>\|\<until\>'
      let ind = ind + shiftwidth()
    endif
  endif

  " Subtract a 'shiftwidth' on end, else, elseif, until and '}'
  " This is the part that requires 'indentkeys'.
  let midx = match(getline(v:lnum), '^\s*\%(end\>\|else\>\|elseif\>\|until\>\|}\|)\)')
  if midx != -1 && synIDattr(synID(v:lnum, midx + 1, 1), "name") != "luaComment"
    let ind = ind - shiftwidth()
  endif

  return ind
endfunction
