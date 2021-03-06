
" notes for movements and usage : ------------------------------------------------- {{{
"" the general strategy is to choose invalid commands
"" (e.g. operation1+operation2 or operation1+non-movement)
"" and commands that don't doo anything (e.g. up+down)
"" E.g. cl is the same as s
"" 'escape keys are lame'
"" good combinations giving movements already in better combinations
"" are also registered. Ideally, any of such movements
"" should perform something or echo 'Non used combination'.
"" I should make <nowait> option work for this to be really useful.
"" and to try to keep navigation inside keyboard. E.g.:
"" sdfghjkl toolkit ****
" -->  H, L, <space>, <cr>, and <bs> do things that you almost never need
" --> show buffers of clipboard and search
" :echo @" . @/
"""" put in .bashrc:
" alias v='vim3 --servername mvimserver --remote-tab-silent'
" }}}

" make a mappint (with func) to toggle C-[ to C-[:up<CR> and back to normal
" }}}
" }}}

":Todo prv make random mask for vim commands {{{
" }}}

" Useful commands which I might need to recall:
" C-A, C-X to add and subtract from number
" check on usage of bracket commands in Python
" start using tags seriously (and find that video from Bram)
" i_C-R to paste register
" i_C-NP to next-previous word completion
" i_C-UTY
" C-W_orR
" Review the '`commands
" g#*<DIjks
" zgGwWv
" :h pi_getscript.txt pi_vimball.txt
" highlight SpellBad
" highlight Normal
" highlight SpellBad term=reverse ctermbg=9 gui=undercurl guisp=Red guifg=red guibg=darkBlue
" highlight Normal ctermfg=11 ctermbg=4 guifg=lightyellow guibg=Blue
" autocommand for saving and compiling tex file when exiting insert mode.
" au InsertLeave * :!pdflatex %<CR><CR>
" ensure the autocommands are loaded only once or removed before being added again.

" :runtime syntax/hitest.vim
" :so $VIMRUNTIME/syntax/hitest.vim 

" :exec getline('.')
" Y:@"


" Highlighting notes   ------------------   {{{
"
" :echo synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
" should give you the highlighting group you need to change
" to change the colors of the char in cursor position.
" hi <name_of_group><CR> 
" will output the settings, which can be changed by appending to the same command
" highlight, syntax and colorcheme
"
" 
" found in:
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '>
" trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}
"
" Spell bad and other groups are bot being shown
"
" Make a mapping for saving current highlighting settings. Just redir
"
" :redir @a
" :set all
" :redir END
" }}}


" https://en.wikipedia.org/wiki/Blood_red and http://rgb.to/color/2845/blood-red
"
""""""""""""""""""""""""""""
" End of vimrc, last commands
" se verbose=0
" let g:vimscript_vars = s:
" au BufEnter,BufRead,BufNewFile,BufFilePre,BufFilePost,BufWinEnter,BufNew,BufReadPost,BufReadCmd,Colorscheme * so ~/.vim/syntax/mysyntaxfileTTM.vim
" au BufEnter,BufRead,BufNewFile,BufFilePre,BufFilePost,BufWinEnter,BufNew,BufReadPost,BufReadCmd,Colorscheme * so ~/.vim/syntax/mysyntaxfileTTM.vim
" au! Syntax * so ~/.vim/syntax/mysyntaxfileTTM.vim
" gq gw
" recovering mappings from plugins...

" Solve the navigation issue. True C-HJKL in all?
" Problem: move i_<C-K> to another combination.
" Ok! make it available in all modes.
"
" What about next/previous tab? Any good C- command?
" Alfanumeric are used to type by insert, command and terminal job modes
"

" Navigate hjkl in insert/command and terminal job modes with <C-UIOP>?
"
" To make new commands:
" zp zq zu zy z(B I J K P Q S T U Y Z) z(any punctuation except: +-=.^, e.g.
" ,/;'[]\`)
" Z(any not Z or Q)
"
" g(2-7,9) g(A,B,C,G,K,L,M,O,S,X,Z,Y,W) g(b,c,l,y,w)
" not g(~,@,_,^,],?,;,<,,,,+,*,',`,$,#): g(.,/,:,",[,\,=)

" CTRL, i_(I,M,Q,S), puncts not ([,],\ CN CG,^,_)
" misterious i_(B,F,
" normal: (Q,S,M,N,P,I), puncts not (],^,)
" c_(H,I,J,K,M,O,Q,S), puncts not ([,],^,_,\ CN CG e
"
" (F is in lowecases, gm after gn, g<punctuations> are scattered)
" Is there a command to know the mappings being used by the Vim installation
" or one has to browser :h index  ?
"
" Best key combination for mappings: g and z. Ctrl
" Alt and <C-\> are not used and are thus secure to use
" (ahtough Alt often conflicts with system shortcurts).
" Commands which we find useless.
"
" use r? to ro13 enconde! No cypher needed, or install a cypher
"title caps	:s/\v<(.)(\w*)/\u\1\L\2/g

" about Bram video of effective text editing (2005)
" gf opens links
" [I shows all the matches of the keyword under cursor
" :cfile ??
" ctags, exuberant-ctags, cscope
"
" https://youtu.be/p6K4iIMlouI?t=1h51s Bram advocates terminal vim (although
" he used both in the presentation)
"
" ~50m: he calls for help in the todo list.
"
" send article to vim list, mentioning the recent revision and add of the
" results section.
"
" 1h integration of Vim to cloud resources, e.g. for google autocomplete
"
" license: handmade by Bram in the initial years of Vim,
" and is GPL compatible (Richard Stallman reviwed the license himself).
" https://youtu.be/p6K4iIMlouI?t=1h6m31s
"
" You, the author, can change the license whenever you want, so don't worry
" about sharing scripts. I usually put "Public Domain" somewhere in the
" repository, because it is fairily unambiguous and open.
" Sometimes I use GPL, LGPL, MIT and CC-variants for reasons usually very
" unimportant and shallow.
"
" Charityware rightfully received some emphasis, by Moolinaar, on the same video.
" Vim donations go to Uganda, to educate kids, mostly orphans, though a
" project which Mollinaar knows by going there.
"
" Bram does not use tabs. but understands its usefulness and advocates its use
" e.g. in gVim to avoid opening multiple gVim instances.
" But states that if 
"
" TODO: look for terminals in sessions, post on vim list.
"       add about '1-9 which are cross buffers, yes, but go to last 1-9
"       positions where you left Vim.
"
" cat /dev/urandom in Terminal-Job mode breaks Vim
" another drawback is that if the terminal history is too big,
" e.g. if you are compiling latex often for a day, or running many verbose
" Python code in ipython, it slows down all" of Vim.
"
" vim notetaking tips: https://www.youtube.com/watch?v=wh_WGWii7UE&t=934s
" change \L char
" get the vimgrep command to vimwiki at ~10m
" learn pandoc to convert vimwiki MD files to Latex.
" learn how to write articles there. Write the color scheme for SH
" article on vimwiki
"
" Vim 25 years video (2016)
" see :h viminfo
"
" Bram uses Vim script not VimL
" Blowfish encription, 
" persistend undo branches and advocation it
"
" my binary is 11M (without GUI, but huge and with Python2 and 3, termguicolors,
" terminal, in his presentation it is 2.4MB.
"
" :TODO add :options command to article
"
" jobs 50m
"
" 52m30 "look at the log while you are doing something else"
" (while talking about job and using (job_start)
"
" Channels (e.g. for daemons) uses json
" testing with assert_equal
" timers (timer_start)
" realcolors in a package not a plugin?
" is timers just jobs that are repeated from time to time?
" partials to bind dictionaries and arguments to functions
" lambda functions
" closure
" finishes by talking about these vim 8.0 release, and says 8.1 is next..
"
" TODO: mentions Bram's videos on documentation and historical note.
"       add about channels, jobs and timers in the terminal job mode
"       use of directives in Vim, e.g. " :vim aoidjasoidj aosjd
"           How to make a file with independent syntax highlighting with these
"           directives
"       see how Vimwiki hides link [[]] and _ _ to highlight
"       A Vim plugin is one script. If you have multiple scripts, you have a
"       pack
"       Add notes on version8.txt and last commits in vim/vim repo
"       Is the diff of pack and plugin/<dir> just :packadd?
"
"       change tokipona and realcolors to pack/ttm/start/(tokipona,
"       realcolors)
"           this way, syntax/tokipona.vim will be correctly inside
"           pack/ttm/start/tokipona/syntax/tokipona.vim
"           and the rest in:
"           pack/ttm/start/tokipona/syntax/tokipona.vim and 
"
"       Make realcolors initialized at startup and make :col0[rscheme] to
"       realcolors colors
"       Write help files for tokipona and realcolors
"           :h  add-local-help (usr_05)
"
"       add about plugin being only one file: :h plugin:
"         "A plugin is nothing more than a Vim script file that is loaded automatically when Vim starts."
"
"       use :load-plugins
"       read :h todo and h: develop
"       
"       put realcolors colorschemes in colors/xxx.vim.
"       
"       check notes on colors in :h todo

"       add about :mk and :mkv

"       check the :h trojan-horse for making the Vim evolutionary
"       inteligence and optimization algorithms

"       clear the pipeline: function -> command -> mapping.
"           when is command needed? when is it convenient for a mapping?

"       <SID> only for commands and and s: everywhere else. Why? check :h usr_41 
map Q gq

"       normal command reads all the followin chars as the sequence of keys.
"       execute command expects a string, e.g. starting by " and ending with "
"       e.g. :normal iYouBoy ;; :execute "normal iYouboy"
"       when does a command expect a string and when does it reads argument as string?

"       learn :h getscript   ??
"       
"       understand what happends when ftplugin and ftdetect are inside plugin/
"       as made with tokipona plugin

" :finish s
" use <unique> on the mappings

" maybe allow CRF in multi fyletype... e.g. setfiletype html.php ... :h filetype

" put instruction to copy the files into pack, clone into 

" add :helptags command to a plugin file in both realcolors and tokipona

" make note about after/ dir not being recursive (e.g. .vim/after/after is not add to runtimpath

" make correct differentiation between plugin, ftplugin, ftdetect, after, syntax, pack, pack/start, pack/opt, bundle?...

" state the uses for Cundle, Pathogen, Vimball and other means, GLP (GLV?)

" describe paths search for in each dir of &runtimepath, include e.g. ftdetect and others which are not in :h runtimepath

" mention the brief discussion in :h map-which-keys about which keys
" to map

" a thorough consideration of the possibilities for mappings would
" include statistics of the languages and text styles intended.

" open pdf of the tex file using a job, bash and evince

" use abbreviations for insert mode.. e.g. fj triggers function that
" allows for one normal command and goes back to insert mode

" <C-> mappings remove the hand from the middle of the keyboard.
" <A-> has the same problem.
" <Space> is ok for normal mode, but used a lot in command, terminal
" and insert modes.
" a mapping might suffice to use the same commands as in normal mode:
" FJ anf JF fj jf maybe...
" shift also removes hand from the middle of the keyboard.
" maybe <letter>u us uppercase, uu is u and uuu is U.
" enter also removes the hand from the middle of the
" keyboard, so maybe fh for enter

" or make a mapping to enable and disable the shortcuts with fj,
" j, space, abbrev or any other convenience.  

" space mmakes sense for normal mode, suggesting that each command 
" be thought as a word (in the editing language, ideally, in thought
" of editing thought language).

" make a plugin to tackle the subject, turning on and off
" the mappings to use keyboard with hands in the middle,
" respecting the desing of the keyboard for writting.
" (study typing techniques?)

" both statusline and tabsline are lines (not statusbar, but
" statusline)
"
" run :helptags and include the generated files in the distro, as un
" :h  repeat | g/command to generate the doc/tags file
" (in the context of :helptags and plug-and-play packages)
"
" vim parses the files before sourcing, so it is quite robust to
" dependencies, handling them without need for a sourcing order for the files
"
" sessao no artigo sobre debugging

