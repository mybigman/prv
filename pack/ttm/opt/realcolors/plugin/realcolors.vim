" main file of the realcolors plugin for Vim {{{3
" Author: Renato Fabbri
" Date: 2018/May/12 (when I wrote this header)
" Copyright: Public domain
" Acknowledgments:
" vim_use email list (discussion forum)
" Dra. Cristina Ferreira de Oliveira (VICG/ICMC/USP),
" FAPESP (project 2017/05838-3)
" Dr. Ricardo Fabbri (IPRJ/UERJ)

" Load Once: {{{3
if exists("g:loaded_wikiplugin") && (exists("g:wiki_not_hacking") || exists("g:wiki_not_hacking_all"))
 finish
endif
let g:loaded_wikiplugin = "v0.01b"
let g:wiki_dir = expand("<sfile>:p:h:h") . '/'



hi SpellBad cterm=undercurl

let g:loaded_colorsPlugin = 'v01'
" GetLatestVimScripts: 5650 1 :AutoInstall: Realcolors

" MAPPINGS: {{{1
" -- g:realcolors_leader hack, part 1 of 1 {{{3
" for now: <C-\> is reserved, so it is safe to use it in all modes
" Initialization and overall status update
noremap <C-\>I :w<CR>:so %<CR>:call InitializeColors()<CR><CR>
noremap <C-\>I :w<CR>:runtime **/*.vim<CR>:call InitializeColors()<CR><CR>
noremap <C-\>i :w<CR>:so %<CR>:call InitializeColors()<CR><CR>
noremap <C-\>i :call InitializeColors()

" Utilities
noremap <C-\>c :call ChgColor()<CR>
noremap <C-\>s :echo SynStack()<CR>
" make windows with colors
noremap <C-\>W :call StandardColorsOrig()<CR>
noremap <C-\>w :call MakeColorsWindow(3)<CR>
noremap <C-\>ww :call MakeColorsWindow(3)<CR>
noremap <C-\>w0 :call MakeColorsWindow(0)<CR>
noremap <C-\>w1 :call MakeColorsWindow(1)<CR>
noremap <C-\>w2 :call MakeColorsWindow(2)<CR>
noremap <C-\>w3 :call MakeColorsWindow(3)<CR>
" debugger:
noremap <C-\>b :call MkBlack()<CR>

" Use to selectively update status
noremap <C-\>a :call GetAll()<CR>
noremap <C-\>g :call GetColors(0)<CR>
noremap <C-\>gg :call GetColors(0)<CR>
noremap <C-\>g0 :call GetColors(0)<CR>
noremap <C-\>g1 :call GetColors(1)<CR>
noremap <C-\>g2 :call GetColors(2)<CR>

" Recover
noremap <C-\>r :colo blue<CR>
noremap <C-\>R :colo gruvbox<CR>

" Luck
noremap <C-\>l :exec 'hi Normal guibg=#'.(system("echo $RANDOM$RANDOM")[:5])<CR>

" use <C-\ c> (press control and \, release, press c).
" to start the color mode.
" use <C-\ a> for audiovisual or aa, <C-\ m> for music
" Because it is C-\ it should work in any mode because it is reserved.
" checkout how to start a mode
" start mappings of functions to g, z and leader keys
" for normal and insert mode
" try also command mode

" Outline
" \c or so starts these mappings, that are removed
" easily

" r g b adds 16 to each color.
" R G B adds 1
" e f v substracts 16 from each color
" E F V subtracts 1

" w d c adds 16 to each of the other colors
" W D C adds 1
" q s x substracts 16 to each of the other colors
" W D C subtracts 1

" gfds might be replaced for fdsa, down one layer on the keyboard from rewq
let s:ckeys = { 'r': 'rewq', 'g': 'fdsa', 'b': 'vcxz', 'i': 'i', 'fb': 'f' }
" let s:ckeys['g'] = 'j'
" let s:ckeys['i'] = 'h'

PRVLeader d realcolors
" COMMANDS: {{{1
" -- MAIN: {{{3
" -- UTILS: {{{3
" FUNCTIONS: {{{1
" -- MAIN {{{2
" -- UTILS {{{2
fu! RealcolorsHex(r,g,b) " {{{3
  " Return RGB in Hex notation: #RRGGBB
  " expects a list [r, g, b] with values in [0, 255]
  if type(a:r) == 3
     retu printf("#%02x%02x%02x", a:r[0], a:r[1], a:r[2])
  el
     retu printf("#%02x%02x%02x", a:r, a:g, a:b)
  en
endf
fu! RealcolorsGrayScale(from,to,ncolors) " {{{3
  " nsteps = ncolors - 1
  let walk = a:to - a:from
  let colors = map(range(a:ncolors), "'#' . repeat(printf('%02x', a:from + v:val*walk/(a:ncolors - 1)), 3)")
  retu colors
endf
fu! HiFile() " {{{3
  " Does a bad job... But the idea is good, enhance it! TTM
  " run to hightlight the buffer with the highlight output
  " e.g. after :Split sy or :Split hi
    let i = 1
    wh i <= line("$")
        if strlen(getline(i)) > 0 && len(split(getline(i))) > 2
            let w = split(getline(i))[0]
            exe "syn match " . w . " /\\(" . w . "\\s\\+\\)\\@<=xxx/"
        en
        let i += 1
    endw
endf
fu! CheckColor(c) " {{{3
  let c = copy(a:c)
  for i in range(len(c))
    if c[i] > 255
      let c[i] = 255
    elseif c[i] < 0
      let c[i] = 0
    endif
  endfor
  return c
endfu
function! SynStack() " {{{3
  " Show syntax highlighting groups for word under cursor
  " last item should be the group last considered, i.e. the most relevant.
  " If it is linked to some other group, you might find it with 
  " synIDtrans
  if !exists("*synstack")
    return
  endif
  let a = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  " intermediaries
  let b = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  let c = []
  let i = 0
  while i < len(a)
    if a[i] != b[i]
      call add(c, [a[i], b[i]])
    else
      call add(c, a[i])
    endif
    let i += 1
  endwhile
  if len(c) == 0
    let c = ['Normal']
  endif
  return c
endfunc

function! MkBlack() " {{{3
  " starting syntax highlighting facilities
  " 1) change the color of the char under cursor to black
  " This mkBlack function and \z mapping is the main syntax highlighting debugger
  "
  " Debugger facility.
  " Only changes the color of the syntax group under cursor to black
  " and prints and creates useful variables
  " Reload color scheme to undo. E.g.: :colo blue

  let stack = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  let stack_ = synstack(line('.'), col('.'))
  let stack__ = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "fg")')
  echo stack
  if len(stack) == 0
    let name1 = 'Normal'
  else
    let name1 = stack[-1]
  endif

  let stack2 = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  let stack2_ = map(synstack(line('.'), col('.')), 'synIDtrans(v:val)')
  let stack2__ = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')
  echo stack2
  if len(stack2) == 0
    let name2 = 'Normal'
  else
    let name2 = stack[-1]
  endif

  execute 'hi' name2
  execute 'hi' name2 'guifg=black'
  echo 'hi' name2 'guibg=white'
  echo 'hi' name1 'guibg=white'
  colo
  let s:you = l:
endfunc

function! GetColors(which) " {{{3
  " Populates the s:colors dictionary with default (which=2), temp (1) and buffer (0) colors
  let sid = hlID('Normal')
  let sfg = synIDattr(synIDtrans(sid), "fg")
  let sbg = synIDattr(synIDtrans(sid), "bg")
  let name = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  if len(name) > 0
    let name = name[-1]
  else
    let name = 'Normal'
  endif
  let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')
  if fg == []
    let name = synIDattr(synIDtrans(sid), "name")
    let fg = sfg
    " let fg = "#FFFFFF"
  else
    let fg = fg[-1]
  endif
  if has_key(s:named_colors, tolower(fg))
    let fg_named = fg
    let fg = s:named_colors[tolower(fg)]['hex']
    ec fg_named
  endif
  if fg[0] != '#'
    let fg = "#" . fg
  endif
  echo 'fg:' fg
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')
  if bg == []
    let namebg = synIDattr(synIDtrans(sid), "name")
    let bg = sbg
    " let bg = "#FFFFFF"
  else
    let bg = bg[-1]
  endif
  if has_key(s:named_colors, tolower(bg))
    let bg_named = bg
    let bg = s:named_colors[tolower(bg)]['hex']
    echo bg_named
  endif
  if bg[0] != '#'
    let bg = "#" . bg
  endif
  echo 'bg:' bg
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')
  " simple dictionary
  let d = {'fg' : {'r': rgb_[0], 'g': rgb_[1], 'b': rgb_[2]}, 'bg' : {'r': rgbb_[0], 'g': rgbb_[1], 'b': rgbb_[2]}, 'rgb': {'fg': fg, 'bg': bg}}
  if a:which == 2  " default color, to be used when the color has no specification of fg or bg
    let s:colors['default'] = d
  elseif a:which == 1  " temporary
    let s:colors['temp'] = d
  else  " buffer, should be updated whenever a color is manipulated
    let s:colors['buffer'] = l:
  endif
endfunc

function! IncrementColor(c, g) " {{{3
  " c='r', g='f' : color and foreground
  GetColors()  " creates the dictionary in next line
  let s:colors[l:g][l:c] = (colors[l:g][l:c] + 16 ) % 256
  RefreshColors()  " should update the colors of the cursor position
endfunction

function! InitializeColors() " {{{3
  " Should initialize the whole coloring system.
  " If not only changing the color under cursor, should be used
  let s:ground = 'fg'
  cal StandardColors()
  " creates the dictionary with colors on foreground and background
  " default, temporary and buffer in s:dcoulorsd, s:tcolorsd and s:colors
  let s:colors = {}
  cal GetColors(0)
  ec '===> buffer color:' s:colors['buffer']
  cal GetColors(1)
  ec ':::> temp color:' s:colors['temp']
  cal GetColors(2)
  ec '---> default color:' s:colors['default']
  " initialize mappings
  " make named_colors0 and named_colors with the name of the colors:
  " 0: from documentation :h gui-colors
  " : from $VIMRUNTIME/rgb.txt

  let s:cs = {'standard': g:colors_name}
  let s:timers = []
  let s:counters = range(10)
  let s:ncounters = 0
  let s:patterns = {}
  let s:mpatterns = {'wave': 'call WavePattern()', 'std': 'call StandardPattern()', 'wobble': 'call Wobble()', 'silence': 'call BypassPattern'}
  " get all variables to the g:colors_all (new)
  " and g:colors_all_ (new) global variables
  cal GetAll()
  cal StandardColorSchemes()
  ec "type \\x to change color under cursor"
  ec " should be integrated to the mode <C-\ c>"
endfu 

function! GetAll() " {{{3
  let g:colors_all = s:
  let g:colors_all_ = []
  for vkey in keys(s:)
    call add(g:colors_all_ , vkey)
  endfor
endfunction

function! SwitchGround() " {{{3
  " To keep a record in our color server
  if s:ground == 'fg'
    s:ground = 'bg'
  else
    s:ground = 'fg'
  endif
endfunction

function! RefreshColors() " {{{3
  " to do what???
  " apply c to current colorscheme
  let c = s:colors
  let g = s:ground
  let fg_ = Hex(c[g],0,0)
endfunction

fu! IncRGB(co, ch) " {{{3
  let co = a:co
  let c = a:ch

  if c == '1' " 0
    let [co[0], co[1]] = [co[1], co[0]]
  elseif c == '2'
    let [co[1], co[2]] = [co[2], co[1]]
  elseif c == '3'
    let [co[0], co[2]] = [co[2], co[0]]
  elseif c == '4'
    let co = [co[2], co[0], co[1]]
  elseif c == '5'
    let co = [co[1], co[2], co[0]]
  elseif c == 't'
    let co[0] = 255 - co[0]
    let co[1] = 255 - co[1]
    let co[2] = 255 - co[2]
  elseif c == 'r' " 1
    let co[0] = (16 + co[0]) % 256
  elseif c == 'g'
    let co[1] = (16 + co[1]) % 256
  elseif c == 'b'
    let co[2] = (16 + co[2]) % 256
  elseif c == 'R'
    let co[0] = (240 + co[0]) % 256
  elseif c == 'G'
    let co[1] = (240 + co[1]) % 256
  elseif c == 'B'
    let co[2] = (240 + co[2]) % 256
  elseif c == 'w' " 2
    let co[0] = (1 + co[0]) % 256
  elseif c == 'd'
    let co[1] = (1 + co[1]) % 256
  elseif c == 'c'
    let co[2] = (1 + co[2]) % 256
  elseif c == 'W'
    let co[0] = (255 + co[0]) % 256
  elseif c == 'D'
    let co[1] = (255 + co[1]) % 256
  elseif c == 'C'
    let co[2] = (255 + co[2]) % 256
  elseif c == 'e' " 3
    let co[1] = (16 + co[1]) % 256
    let co[2] = (16 + co[2]) % 256
  elseif c == 'f'
    let co[0] = (16 + co[0]) % 256
    let co[2] = (16 + co[2]) % 256
  elseif c == 'v'
    let co[0] = (16 + co[0]) % 256
    let co[1] = (16 + co[1]) % 256
  elseif c == 'E'
    let co[1] = (240 + co[1]) % 256
    let co[2] = (240 + co[2]) % 256
  elseif c == 'F'
    let co[0] = (240 + co[0]) % 256
    let co[2] = (240 + co[2]) % 256
  elseif c == 'V'
    let co[0] = (240 + co[0]) % 256
    let co[1] = (240 + co[1]) % 256
  elseif c == 'q' " 4
    let co[1] = (1 + co[1]) % 256
    let co[2] = (1 + co[2]) % 256
  elseif c == 's'
    let co[0] = (1 + co[0]) % 256
    let co[2] = (1 + co[2]) % 256
  elseif c == 'x'
    let co[0] = (1 + co[0]) % 256
    let co[1] = (1 + co[1]) % 256
  elseif c == 'Q'
    let co[1] = (255 + co[1]) % 256
    let co[2] = (255 + co[2]) % 256
  elseif c == 'S'
    let co[0] = (255 + co[0]) % 256
    let co[2] = (255 + co[2]) % 256
  elseif c == 'X'
    let co[0] = (255 + co[0]) % 256
    let co[1] = (255 + co[1]) % 256
  endif
  return co
endfu

function! ChgColor() " {{{3
  " should integrate bold italics and underline (strikeout?) TTM
  let sid = hlID('Normal')
  let sfg = synIDattr(synIDtrans(sid), "fg")
  let sbg = synIDattr(synIDtrans(sid), "bg")
  let name = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  if len(name) > 0
    let name = name[-1]
    let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')[-1]
    if fg == ''
      let fg = sfg
    en
    let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')[-1]
    if bg == ''
      let bg = sbg
    endif
  else
    let name = 'Normal'
    let fg = sfg
    let bg = sbg
  endif
  if has_key(s:named_colors, tolower(fg))
    let fg_named = fg
    let fg = s:named_colors[tolower(fg)]['hex']
  endif
  if fg[0] != '#'
    let fg = "#" . fg
  endif
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  if has_key(s:named_colors, tolower(bg))
    let bg_named = bg
    let bg = s:named_colors[tolower(bg)]['hex']
  endif
  if bg[0] != '#'
    let bg = "#" . bg
  endif
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')

  let [fg_, bg_] = [fg, bg]
  echo [fg_, bg_]
  let c = 'foo'
  let who = 'fg'
  echo 'initial colors are fg, bs:' fg bg
  call getchar(1)
  let emphn = 0
  let emph = ['bold', 'underline', 'bold,underline', 'NONE']
  while c != 'n'
      let mex = 1
			let c = nr2char(getchar())
      if c == 'j'
        if who == 'fg'
          let who = 'bg'
          let mcmd = 'echo "on the background color"'
        else
          let who = 'fg'
          let mcmd = 'echo "on the background color"'
        endif
      elseif c == 'h'
        let [rgb_, rgbb_] = [rgbb_, rgb_]
        let mcmd = 'echo "colors inverted"'
        let fg_ = Hex(rgb_[0], rgb_[1], rgb_[2])
        execute 'hi' name 'guifg=' . fg_
        let bg_ = Hex(rgbb_[0], rgbb_[1], rgbb_[2])
        execute 'hi' name 'guibg=' . bg_
      elseif c == 'p' " power, preeminence, prominance
        let emphn  = ( emphn + 1 ) % len(emph)
        execute 'hi' name 'cterm=' . emph[emphn]
        let mcmd = ''
      elseif c == 'P' " power, preeminence, prominance
        let emphn  = ( emphn + 3 ) % len(emph)
        execute 'hi' name 'cterm=' . emph[emphn]
        let mcmd = ''
      elseif who == 'fg'
        let rgb_ = IncRGB(rgb_, c)
        let fg_ = Hex(rgb_,0,0)
        let mcmd = printf('hi %s guifg=%s', name, fg_)
      elseif who == 'bg'
        let rgbb_ = IncRGB(rgbb_, c)
        let bg_ = Hex(rgbb_,0,0)
        let mcmd = printf('hi %s guibg=%s', name, bg_)
      else
        let mex = 0
      endif
      if mex
        execute mcmd
        redraw
        echo fg_ bg_ '(rewqgfdsbvcxhjp to change, n to quit)'
      endif
      " echo 'hi' name 'guifg=' . fg_
  endwhile
  let s:me = l:
endfunc

function! StandardColorsOrig() " {{{3
  "  Shows the named colors available as fg and bg against default fg and bg    
  " Restore normal highlighting by typing ":call clearmatches()"

  " - Read file $VIMRUNTIME/rgb.txt
  " - Delete lines where color name is not a single word (duplicates).
  " - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
  " Add matches so each color name is highlighted in its color.
  call clearmatches()
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
  silent execute 'v/'.find_color.'/d'
  " silent g/grey/d
  let namedcolors=[]
  1
  while search(find_color, 'W') > 0
      let w = expand('<cword>')
      call add(namedcolors, w)
  endwhile

  for w in namedcolors
      execute 'hi col_'.w.' guifg=NONE guibg='.w
      execute 'hi col_'.w.'_fg guifg='.w.' guibg=NONE'
      execute '%s/\<'.w.'\>/'.printf("%-36s%s", w, w).'/g'

      call matchadd('col_'.w, '\<'.w.'\>', -1)
      " determine second string by that with large # of spaces before it
      call matchadd('col_'.w.'_fg', ' \{10,}\<'.w.'\>', -1)
  endfor
  1
  nohlsearch
endfunction

function! MakeColorsWindow(colors) " {{{3
  " colors=0,1,2,3 for 
  " only the most basic colors against default, against default and B&W
  " All named colors against default, against default and B&W
  if a:colors < 2
    let nc = s:named_colors0
  else
    let nc = keys(s:named_colors_)
  endif

  call clearmatches()
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  " silent g/grey/d
  1
  for w_ in l:nc
     if w_ == ''
       continue
     endif
      " default bg against color in fg,
      " default fg against color in bg
      " black fg against color in bg
      " white fg against color in bg
      " black bg against color in fg,
      " white bg against color in fg
      let w = substitute(w_, " ", "__", "g")
      let w__ = copy(w_)
      if w_ =~ ' '
        let w_ = "'" . w_ . "'"
      endif
      " echo 'hi col_' . w . '_fg guifg=' . w_ . ' guibg=NONE'
      " echo 'hi col_' . w . '_bg guifg=NONE guibg=' . w_
      " echo w w_ w__
      execute 'hi col_' . w . '_fg guifg=' . w_ . ' guibg=NONE'
      execute 'hi col_' . w . '_bg guifg=NONE guibg=' . w_
      if a:colors % 2 == 1
        " echo 'aaaaaaaaaaaaa ' w
        execute 'hi col_' . w . '_bfg guifg=black guibg=' . w_
        execute 'hi col_' . w . '_wfg guifg=white guibg=' . w_
        execute 'hi col_' . w . '_bbg guifg=' . w_ . ' guibg=black'
        execute 'hi col_' . w . '_wbg guifg=' . w_ . ' guibg=white'
        execute '%s/\s\s' . w__ . '$/' . printf("  %s Foreground, %s Background, %s Black FG, %s White FG, %s Black BG, %s White BG", w__, w__, w__, w__, w__, w__) . '/g'
        call matchadd('col_' . w . '_bfg', '\<' . w__ . ' Black FG\>', -1)
        call matchadd('col_' . w . '_wfg', '\<' . w__ . ' White FG\>', -1)
        call matchadd('col_' . w . '_bbg', '\<' . w__ . ' Black BG\>', -1)
        call matchadd('col_' . w . '_wbg', '\<' . w__ . ' White BG\>', -1)
      else
        execute '%s/\s\s' . tolower(w__) . '$/'.printf("%s Foreground, %s Background", w, w).'/g'
      endif
      call matchadd('col_' . w . '_fg',  '\<' . w__ . ' Foreground\>', -1)
      call matchadd('col_' . w . '_bg',  '\<' . w__ . ' Background\>', -1)

      " determine second string by that with large # of spaces before it
  endfor
  1
  nohlsearch
  let g:banana = l:
endfun

function! ColorsNotFound() " {{{3
  let cnotf = []
  let cc = keys(s:named_colors)
  for c in s:named_colors0
    if index(cc, tolower(c)) >= 0
      " color found, pass
    else
      call add(cnotf, c)
    endif
  endfor
  let s:cnotf = cnotf
  let s:named_colors['lightred']  = '#ff8b8b'
  let s:named_colors_['LightRed'] = '#ff8b8b'
  let s:named_colors['lightmagenta']  = '#ff8bff'
  let s:named_colors_['LightMagenta'] = '#ff8bff'
  let s:named_colors['darkyellow']  = '#8b8b00'
  let s:named_colors_['DarkYellow'] = '#8b8b00'
endfu

function! StandardColors() " {{{3
  " This function gets all the names of the all the colors on the system
  " See MakeColorsWindow(3) to display all named colors
  " as foreground and background against
  " black, white and default colors in a window

  " these names are from from :h gui-colors in Jan/05/2018
  let s:named_colors0 = ['Red', 'LightRed', 'DarkRed', 'Green', 'LightGreen', 'DarkGreen', 'SeaGreen', 'Blue', 'LightBlue', 'DarkBlue', 'SlateBlue', 'Cyan', 'LightCyan', 'DarkCyan', 'Magenta', 'LightMagenta', 'DarkMagenta', 'Yellow', 'LightYellow', 'Brown', 'DarkYellow', 'Gray', 'LightGray', 'DarkGray', 'Black', 'White', 'Orange', 'Purple', 'Violet']
  call clearmatches()
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  " - Delete lines where color name is not a single word (duplicates).
  " - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
  "   TTM ??
  let tline = 1
  let mline = line('$')
  let named_colors = {}
  let named_colors_ = {}
  while tline <=  mline
    exec tline
    normal yy
    if @" == ''
      let tline += 1
      continue
    endif
    let [r, g, b, name] = [str2nr(@"[0:2]), str2nr(@"[4:6]), str2nr(@"[8:10]), @"[13:-2]]
    let mhex = Hex(r,g,b)
    " if name =~ 'gray'
    "   echo r g b mhex name
    " endif
    " echo r g b mhex name
    let tempdict = {'r'   :   r,
                  \ 'g'   :   g,
                  \ 'b'   :   b,
                  \ 'hex' :   mhex}
    let named_colors[tolower(name)] = tempdict
    let named_colors_[name] = tempdict
    let tline += 1
  endwhile
  let g:chicrute=55
  unlet named_colors['']  " find out why I am getting this 000 '' color...
  let s:named_colors = named_colors
  let s:named_colors_ = named_colors_
  call ColorsNotFound()
  call SpecialColors()
  q
endfunc

function! SpecialColors() " {{{3
  " blood reds, blues, etcsss
  let snamed_colors = {}
  " from https://en.wikipedia.org/wiki/Blood_red
  let snamed_colors['blood'] = ['#660000', '#aa0000', '#af111c', '#830303', '#7e3517']
  let most10 = ['#3f5d7d', '#279b61', '#008ab8', '#993333', '#a3e496', '#95cae4', '#cc3333', '#ffcc33', '#ffff7a', '#cc6699']
endfu
" -- AUX {{{2
fu! ParseOrixas() " {{{
  let f = readfile(expand('%:p:h') . '/data/orixas1.txt')
  let os = []
  let infos = {}
  for o in f[1:]
    if o =~ '.*:'
      let name = tolower(substitute(o, ':.*', '', ''))
      let info = substitute(o, '.*:', '', '')
      let info_ = substitute(info, '\s\{2,\}', ' ', 'g')
      call add(os, name)
      if !has_key(infos, name)
        let infos[name] = []
      endif
      call add(infos[name], info_)
    endif
  endfor
  let g:f = f
  let os_ = filter(copy(os), 'index(os, v:val, v:key+1)==-1')
  let g:os = sort(os_)
  let g:infos = infos
  return os
endfu " }}}
fu! AfricanCS() " {{{
  " https://www.pinterest.com/pin/456974693425216689/
  let synon = {'osanha': 'ossain', 'xapanã': 'xapana',
        \ 'oxaguiã': 'oxaguia', 'omulu': 'umulu',
        \ 'yansa': 'iansa'}
  " let allnames = ParseOrixas()
  let allnames = ['cosme', 'exu', 'ibeji', 'obaluaie', 'ogum', 'oxala', 'oxum', 'oxossi', 'pomba gira', 'preto velho', 'xango', 'xapana', 'yansa', 'yemanja', 'yori', 'yorima']
  let morenames = ['umulu', 'nana', 'olorum', 'ossain', 'oxaguia', 'oxumare', 'oba', 'ewa', 'logun ede', 'iroko']
  let palletes = {}
  let palletes.exu = ['redblood', 'black', 'yellow']
  let palletes.exu_ = MkPallte12(palletes.exu)
  let cs = {}
  let cs.exu = MkCS(palletes.exu_)
  " call ApplyCS(cs.exu
endfu " }}}
fu! MkPallte12(pallete) " {{{
  " return a 12 colors pallete from what comes
  " assuming pallete is a sequence of lists with three
  " values in [0,255] for rgb.
  let nder = 12.0/len(a:pallete)
  let colors = []
  for color in a:pallete
    let sum = 0
    for c in color
      let sum += c
    endfor
    let sum = sum/3
    let c_ = [color]
    let nder_ = 1
    if sum > 128 " closer to white
      while nder_ < nder
        let color = GetShade(color, 0.5)
        call add(c_, color)
        let nder_ += 1
      endwhile
    else
      while nder_ < nder
        let color = GetTint(color, 0.5)
        call add(c_, color)
        let nder_ += 1
      endwhile
    endif
    call extend(colors, c_)
  endfor
  " while len(colors) < 12
  "   let acolor = MaxDiff(colors)
  "   call add(colors, acolor)
  " endwhile
  return colors
endfu " }}}
fu! MaxDiff(colors) " {{{
  " Return a color that is maximally different from all the colors given
endfu " }}}
fu! MkCS(pallete) " {{{
  " Return a CS relating each basic group to a color
endfu " }}}
fu! ApplyCS(cs_pallete, method) " {{{
  " Apply a CS which should relate colors to groups
  " if a:method == 'commands'
    " let coms = a:cs_pallete.commands
  if a:method =~ "^c.*"
    let coms = a:cs_pallete
    if type(a:cs_pallete) == 0
      let coms = ['colo blue', 'hi Normal  guifg=#0fffe0 guibg=#03800b']
    endif
    for c in coms
      exec c
    endfor
  endif
endfu " }}}
fu! CommandColorSchemes() " {{{
  let cs = {}
  let cs.green1 = ['colo blue', 'hi Normal  guifg=#0fffe0 guibg=#03800b']
  let cs.green2 = ['colo torte', 'highlight Normal guifg=white  guibg=darkGreen',
        \'hi Folded guifg=darkgreen']
  
  let cs.yellow1 = ['colo morning', 'hi Normal guibg=#ffff00',
        \ 'hi Constant cterm=bold guifg=#a0a010 guibg=NONE',
        \ 'hi Search guibg=lightblue']

  let cs.red1 = ['colo koehler', 'hi Normal guibg=#800000']
  let cs.red1c = ['colo koehler', 'hi Normal guibg=#800000', 'hi Folded guifg=cyan guibg=#bb0000']
  let cs.red1b = ['colo koehler', 'hi Normal guibg=#900000']
  let cs.red2 = ['colo koehler', 'hi Normal guibg=#ff0000']
  let cs.red3 = ['colo koehler', 'hi Normal guibg=#ff8833']
  let cs.red4 = ['colo koehler', 
        \ 'highlight Normal guifg=black guibg=red', 
        \ 'highlight Comment guifg=black guibg=red gui=bold']
  let cs.red4 = ['colo koehler', 
        \ 'highlight Normal guifg=black guibg=red', 
        \ 'highlight Comment guifg=black guibg=red gui=bold',
        \ 'hi Constant guifg=#004444 cterm=NONE',
        \ 'hi Constant cterm=bold guifg=#900000',
        \ 'hi Comment cterm=bold guifg=#606000',
        \ 'hi Type guifg=#600060']
  let cs.red5 = ['colo torte',
        \ 'hi Folded guibg=#702020 guifg=#000000 cterm=bold',
        \ 'hi Comment ctermfg=12 guifg=#d0808f',
        \ 'hi Constant guifg=#ff0000',
        \ 'hi Identifier cterm=bold guifg=#e00f4f',
        \ 'hi Normal guifg=#ac3c3c guibg=Black',
        \ 'hi vimIsCommand cterm=bold guifg=#9c3c00',
        \ 'hi vimFunction guifg=#bcbc0c',
        \ 'hi vimOperParen cterm=bold guifg=#fc2c2c']
  let cs.redblackl = ['colo koehler', 'hi Normal guibg=#800000']
  let cs.passivepink1 = ['colo koehler', 'hi Normal guibg=#ff91af',
        \'hi Comment guifg=#888888', 'hi Identifier guifg=#bb7777', 'hi Constant guifg=#ffcccc',
        \'hi PreProc guifg=#888088', 'hi Special guifg=#8f3580', 'hi Type guifg=#508f60']
  
  
  let cs.exu1 = cs.red4

  " Holy spirit: (many colors, each with a specific simbolism, look for them)

  let cs.blue1 = ['colo blue', 'hi Normal guibg=#0000ff']
  let cs.blue2 = ['colo blue', 'hi Normal guibg=#444488']

  let cs.blue2 = ['colo blue', 'hi Normal guibg=#444488']
  
  let cs._notes = {}
  let cs._notes.red1_4 = '~mythologically related to exu through yellow and red'
  let g:ccs = cs
endfu " }}}
fu! StandardColorSchemes() " {{{
  let s:scs = {'desc': 'dictionary for all color schemes'}
  let s:scs['Monochromatic'] = {'desc': 'one color shades'}
  let s:scs['Analogous'] = {'desc': 'one color shades'}
  let s:scs['LGray'] = {'desc': 'linear grayscale colorschemes'}
  " print(["%x" % ((i*255)//(N-1),) for i in range(N)])
  let s:scs['LGray']['2bit'] = ['#000000', '#ffffff', '#555555', '#aaaaaa']
  let vals4b = ['0', '24', '48', '6d', '91', 'b6', 'da', 'ff']
  let s:scs['LGray']['4bit'] = map(vals4b, '"#" . v:val . v:val  . v:val')
  let s:scs['LRGB'] = {'desc': 'linear maximum distance RGB colorschemes'}
  let s:scs['ERGB'] = {'desc': 'exponential maximum distance RGB colorschemes'}
  let s:scs['ERGB'] = {'desc2': 'Weber-Fechner laws'}
  let s:scs['PRGB'] = {'desc': 'power-law maximum distance RGB colorschemes'}
  let s:scs['PRGB'] = {'desc2': "Steven's laws"}
  let s:scs['PRGB'] = {'desc2': "Steven's laws"}
  " Linear distance maximization
  cal MakeLRGBD()
  " LF, EF, EF Frequency-related colorschemes (translate with wlrgb)
  " using harmonic series
  " how is rgb related to final frequency of the light?
  " RRGB randomic coloschemes
  " EERGB PPRGB Double Web-Fech and Stev laws
  " Arbitrary series or rgb or final frequency
endfu " }}}
fu! AppyCS2(cs) " {{{
  " Most basic: 1 bg + 8fg + 3fg = 12 colors
  " Basic grouping of them?
  " Basic partitioning of them?
  " As in :h 
  let c = a:cs
  exec "hi Normal     guibg=" . Hex(c[0]) . " guifg=" . Hex(c[1])
  exec "hi Comment    guifg=" . Hex(c[2])
  exec "hi Constant   guifg=" . Hex(c[3])
  exec "hi Identifier guifg=" . Hex(c[4])
  exec "hi Statement  guifg=" . Hex(c[5])
  exec "hi PreProc    guifg=" . Hex(c[6])
  exec "hi Type       guifg=" . Hex(c[7])
  exec "hi Special    guifg=" . Hex(c[8])

  hi Underlined gui=underline
  hi Error gui=reverse
  hi Todo guifg=black guibg=white
endfu " }}}
fu! MakeLRGBD() " {{{
  let mean_colors = [[255, 128, 0],
                   \ [0, 255, 128],
                   \ [128, 0, 255],
                   \ [0, 128, 255],
                   \ [255, 0, 128],
                   \ [128, 255, 0]]
  let l = []
  let bwg = [[0,0,0],[255,255,255],[128,128,128]]
  for c in mean_colors
    let cs_ = MkRotationFlipCS(c) + bwg
    call add(l, cs_)
  endfor
  let g:colors_all['cs']['lmean_doc'] = 'has bw and colors in between. should have precedence given by the bg'
  let g:colors_all['cs']['lmean'] = l
endfu " }}}
fu! Warp(where, distortion) " {{{
  " Make cs more white or black or gray or tend
  " to a specific color
endfu " }}}
fu! MkRotationFlipCS(color) " {{{
  let c = a:color
  let f = [255 - c[0], 255 - c[1], 255 - c[2]]
  let cs =   [c,
           \ [c[2], c[0], c[1]],
           \ [c[1], c[2], c[0]],
           \  f,
           \ [f[2], f[0], f[1]],
           \ [f[1], f[2], f[0]]
           \ ]
  return cs
endfu " }}}
fu! GetShade(color, factor) " {{{
  " new intensity = current intensity * (1 – shade factor)
  " factor = 1 => black
  let f = 1 - a:factor
  let c = map(a:color, "v:val*f")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}
fu! GetTint(color, factor) " {{{
  " new intensity = current intensity + (255 – current intensity) * tint factor
  " factor = 1 => white
  let c = map(a:color, "v:val + (255 - v:val) * a:factor")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}
fu! GetTone(color, factor) " {{{
  " Algorithm made as whished... TODO: find out the canonic routine
  " factor = 1 => gray
  let value = (a:color[0] + a:color[1] + a:color[2])/3
  let c = map(a:color, "v:val + (value - v:val) * a:factor")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}
" Anti-Shade Tint and Tone: away from black, white or gray
" Anti-shade is a tint? an anti-tint is a shade?
" An anti-tone is a what?
" -- EXP {{{2
function! InitializeDynamics() " {{{3
  " to keep track of the tickers___:
  cal timer_stopall()
  let s:tickerids = []
endf
function! TickColor(timer) " {{{3
  let s:anum = 0
  let s:tick = 1
  " default:
  " change some of the colors (of text and bg)
  " at the window in some patterns
  while s:tick == 1
    echo "banana =" s:anum
    let s:anum += 1
  endwhile
endfunc
function! StartTick() " {{{3
  s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )
endfunction
""""""""""""""""""" {{{3 Minimal Patterner
func! MyHandler(timer)
  echo 'Handler called' s:i
  let s:i += 1
endfunc
func! MyTimer(repeat, period)
  let s:i = 0
  let timer = timer_start(a:period, 'MyHandler',
        \ {'repeat': a:repeat})
  call add(s:timers, timer)
endfu
"""""""""""" Don't Know {{{3
" make a rhythm on numbers by updating a variable with list
" of numbers or patterns
"
" one calls the other to repeat n times.
" displacement/offset might be performed with repeat=1, period=silence)
" pattern(offset=2000, repeat=4, period=500)
func! MyHandler2(offset, timer, makeoffset)
  echo 'Handler called' s:counters
  if a:makeoffset == 1
    call MyHandler2(a:offset, 1, )
  let s:counters[i] += 1
endfunc

func! MyTimer2(offset, repeat, period)
  let timer = timer_start(a:period, 'MyHandler2',
        \ {'repeat': a:repeat, 'offset': a:offset, 'makeOffset': 1})
  call add(s:timers, timer)
endfu
" let s:pattern = s:MyTimer2
""""""""""""""""""" {{{3 Z-Patterner
fu! StandardPattern()
  let s:counters[s:ncounters] += s:ncounters
  let s:ncounters = (s:ncounters + 1) % len(s:counters)
endf

fu! BypassPattern()
  " for silence
  let foo = 'bar'
endf

fu! Pattern1(value)
  let s:counters[a:value] += a:value
endf

fu! WavePattern()
  call Voice(100, 20, 'std')
  call Voice(1, 1000, 'silence')
  call Voice(100, 20, 'std')
endf

function! Wobble(nlines)
  " Make curent line and next ones wobble
  let i = 0
  let mstart = system("echo $RANDOM")
  while i < nlines
    exec line('.')+i . 'center' 30+(i*1+mstart)%80
    let i += 1
  endwhile
endfunc

fu! PWobble()
  " let timer = timer_start(500, 'Wobble')
  " let timer = timer_start(500, 'Wobble',
  "      			\ {'repeat': a:repeat})
  call Voice(3, 200, 'Wobble(5)')
endf

fu! OverallPattern()
  call Voice(-1, 2000, 'PWobble')
endf


fu! MyHandler3(timerID)
  " a:timer is the number of repeats.
  " the duration is set by MyTimer3(timer=a:timer, duration=XXX)
  let foo = copy(s:counters)
  if !has_key(s:patterns, a:timerID)
    " call StandardPattern()
    cal BypassPattern()
  el
    exe s:patterns[a:timerID]
  en
  " let rand = system("echo $RANDOM")%len(s:counters)
  " echo [rand, len(s:counters)]
  " let s:counters[rand] += rand
  let bar = [s:ncounters, len(s:counters)]
  " echo bar 'Handler called' foo
  "     \ '\nHandler finished' s:counters ' ' a:timer
  ec bar 'Handler called' foo
      \ '\nHandler finished' s:counters ' ' a:timerID
endf

func! MyTimer3(repeats, duration, value)
  " timer is number of subsequent timer onsets
  " duration is period in ms
  " value is simpy not being used
  let timerID_ = timer_start(a:duration, 'MyHandler3',
        \ {'repeat': a:repeats})
  echo timerID_
  let s:patterns[timerID_] = "call Pattern1(". a:value .")"
  call add(s:timers, timerID_)
endfu
" let s:pattern = s:MyTimer3
"
"
" }}}
""""""""""""""""""" {{{3 Z-Patterner2
fu! SporkVoice(timerID)
  " a:timer is the number of repeats.
  " the duration is set by MyTimer3(timer=a:timer, duration=XXX)
  let foo = copy(s:counters)
  if !has_key(s:patterns, a:timerID)
    " call StandardPattern()
    cal BypassPattern()
  el
    exe s:patterns[a:timerID]
  en
  " let rand = system("echo $RANDOM")%len(s:counters)
  " echo [rand, len(s:counters)]
  " let s:counters[rand] += rand
  let bar = [s:ncounters, len(s:counters)]
  " echo bar 'Handler called' foo
  "     \ '\nHandler finished' s:counters ' ' a:timer
  ec bar 'Handler called' foo
      \ '\nHandler finished' s:counters ' ' a:timerID
endf

fu! Voice(repeats, duration, patternID)
  " timer is number of subsequent timer onsets
  " duration is period in ms
  " value is simpy not being used
  let timerID_ = timer_start(a:duration, 'SporkVoice',
        \ {'repeat': a:repeats})
  echo timerID_
  if type(a:patternID) == 0
    let s:patterns[timerID_] = "call Pattern1(". a:value .")"
  elsei has_key(s:mpatterns, a:patternID)
    let s:patterns[timerID_] = s:mpatterns[a:patternID]
  else
    let s:patterns[timerID_] = 'call' a:patternID
  en
  call add(s:timers, timerID_)
endfu
" let s:pattern = s:MyTimer3
" -- NOTE {{{2
" -------- notes {{{3
"  TODO:
"  - use CIELab and CIELuv
" pallete: choice of colors
" scheme: association of colors with syntax groups
" :sy creates groups and associates them to textual elements
" :hi associates them to display parameters: colors + (bold + italics + underline + reverse)
" underline + strikeout)

" tgc was only for gVim, you don't get the gui=undercurl there.
"
" Script minimal documentation {{{
" most advanced run: 
" basic run: \z to create color variables based on the cursor position
" and \x to change color under cursor.
" MakeColorsWindow dont match colors in the window made by running colors.vim
"
" All commands are in <C-\> namespace and are valid for all modes.
" Start the system with <C-\>I (reloads all files from all plugins)
" or <C-\>i (reloads current file) 
" Look at the global variables g:colors_all and g:colors_all_ after
" starting.
" Check mappings in realcolor/mappings.vim to grasp overall functionality
" }}}

" -Structure: Auto loaded by vim's plugin system {{{
" ### so realcolors/cs.vim
"
" ### so realcolors/tools.vim
" InitializeColors() - calls functions markied with ***
" GetColors(default)  ***
" StandardColors() ***
" StandardColorSchemes() ***
" GetAll() ***
" ChgColor() - Masterpiece. TODO: enhance key mappings
" SynStack()                
" MkBlack()                
" MakeColorsWindow(colors)  - Masterpiece. Shows named colors agains b&w and Normal fg/bg. TODO: make it work for all 0 1 2 3
" StandardColorsOrig() - Masterpiece. Shows the named colors available as fg
" and bg against default fg abd bg
"
" Undeveloped, maybe remove:
" IncrementColor(c, g) -  changes s:colors and uses RefreshColors() TODO
" SwitchGround() - global variable ground
" RefreshColors() TODO
"
" ### so realcolors/mappings.vim
" <C-\> standard routines
"
" ### so realcolors/dynamic.vim
" Wobble(nlines)           
" TickColor(timer)         
" StartTick()              
"
" ### ascii art ??
" }}}

" References {{{
" /usr/local/share/vim/vim80/doc/syntax.txt
" * For the preferred and minor groups
" }}}

" TODO {{{
" * Account for coloring that does not appear with <c-\> s as is: search
" highligh when typing and afterwards, spellbad, other spell classes?
" Lines number bar. statusbar and tabs bar colors. Colors of the command-line
" * Relation of all basic syn groups and their colors
" * tradutor de verbose de syntax highlighting para colorscheme
" * Integrate Python & vim to convert freq to RGB
" make exercises with each of the vim's python-related functions
" * Write to list or report bug to Vim git: spellbad is lost in colorscheme blue (and other standard colorschemes) when set termguicolors in terminal because no cterm=undercurl or gui(fg/bg).
"   - Show my solution let mysyntaxfile = '~/.vim/syntax/mysyntaxfileTTM.vim'
" * A function that analyses the current file and outputs
" a window with each of the colors used and their hi group and
" specifications.
" It should also allow then that the user toggles the original file
" between normal text view and another with each char substituted with
" the corresponding FG colors and their numbers and another
" with the BG colors and their numbers.
"
" * Commands to add new syntax group, match words and patterns,
" associate with other colors.
" Grab words and patterns under cursor, e.g. to add or remove
" words to a group, or use the same color settings
"
" * Think about making a mode to ease the syntax highlighting
" modifications

" * hlsearch and spellbad should one be bold and underline to avoid
" collision with programming language colors.
" * hlsearch and spellbad should use two of the cues: color, bold, underline.
" (italics?)

" * syntime report to get the syntax highlighting scheme being used
" }}}

" Further notes: {{{
" Color many of the substitute patterns.
" Color the @" and @. registers.

" Make colorscheme with X11 colors:
" :echo filter(copy(colors_all['named1']), 'v:val[0:2]=="X11"')
"
" syntax change undo
" increment/decrement rgb
" in the char under cursor

" start a function that receives
" the modifications throug the
" keys RGB and before it (rewq, gfds, bvcx).
" for backgound, press j and use the same keys.
" uppercase is used for more resolution.

" q quits.

" Another functionality:
" Makes a color pallete from the special colors
" or other palletes that are special or
" that are derived from a color or set of colors.

" Another functionality:
" swap two colors grabed from cursor.
" rotate all the colors maintaining the background
" or not.

" find make tests with synID trans false and true
" We have the syngroups givem by synstack
" and the effectively used one, given
" by synIDtrans

" their name might be found with
" synIDattr

" If set hi group from synstack,
" the link used beforehand is lost.
" e.g.  :hi vimHiGuiFgBg guifg=#000000
" Makes you loose the link to gruvboxYellow
" }}}

" Function to the the SID as a last resort {{{
" function s:MYSID()
"   return matchstr(expand('<sfile>'),  '<SNR>\zs\d\+\ze_SID$')
" endfun
" let s:mysid = s:SID()
" }}}
" csnotes {{{3
" COLOR PRINCIPLES OF MAN STATES OF MATTER
" 
" Violet Chaya, or Etheric Double Ether
" 
" Indigo Higher Manas, or Spiritual Intelligence, Critical State called Air
" 
" Blue Auric Envelope,  Steam or Vapor
" 
" Green Lower Manas, or Animal Soul, Critical State
" 
" Yellow Buddhi, or Spiritual Soul, Water
" 
" Orange,  Prana, or Life Principle, Critical State
" 
" Red Kama Rupa, or Seat of Animal Life, Ice
" 
" ==
" the patternwork of color in the Bible, namely that red refers to
" flesh; yellow--trial; blue--the Word or healing power of Almighty
" God; green--immortality; purple--royalty or priesthood
" 
" ==
" " Secret Doctrine of the Rosicrucians 
" PART XII
" THE AURA AND AURIC COLORS
" http://www.sacred-texts.com/sro/sdr/sdr13.htm
" 
" ==
" https://www.psychologytoday.com/blog/people-places-and-things/201504/the-surprising-effect-color-your-mind-and-mood
" 
" ==
" masculine: bold colors, shades
" feminine: soft colors, tints
" 
" ==
" http://www.mythsdreamssymbols.com/ddcolors.html
" 
" https://www.scienceofpeople.com/10-ways-color-affects-your-mood/
" 
" Maker miler pink (passive pink
" 
" color psychology:
" http://www.arttherapyblog.com/online/color-psychology-psychologica-effects-of-colors/#.Wl87LnWnHQo
" 
" make color schemes for each day of the week,
" for liturgical 
" white, the symbol of light, typifies innocence and purity, joy and
" glory; red, the language of fire and blood, indicates burning charity
" and the martyrs' generous sacrifice; green, the hue of plants and
" trees, bespeaks the hope of life eternal; violet, the gloomy cast of
" the mortified, denotes affliction and melancholy; while black, the
" universal emblem of mourning, signifies the sorrow of death and the
" sombreness of the tomb.
" http://www.newadvent.org/cathen/04134a.htm
" 
" http://www.crivoice.org/symbols/colorsmeaning.html
" -- FINAL {{{2
" -- final commands and file settings {{{3
if !ColorsIsInitialized()
  cal InitializeColors()
en
" vim:foldlevel=2:
