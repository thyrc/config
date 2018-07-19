set incsearch
set hlsearch

"" enhanced command-line completion
set wildmenu
set wildmode=longest,list:longest,list:full

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

set cindent
set cinkeys-=0#
set indentkeys-=0#

set number
set mouse+=a

set backspace=indent,eol,start
set laststatus=2
set pastetoggle=<F12>

set nobackup
set swapfile

"" netrw
" disable generation of .netrwhist
let g:netrw_dirhistmax = 0
" tree style listing
let g:netrw_liststyle = 3

"" split window
set splitright
set splitbelow

nmap <C-L> :nohl <bar> :syn clear Repeat<CR>

set background=dark
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=DarkBlue gui=NONE guifg=DarkGrey guibg=NONE

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<C-End>"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_asm_checkers = ['nasm']
let g:syntastic_c_checkers = ['']
let g:syntastic_sh_checkers = ['sh']
let g:syntastic_rust_checkers = ['']

" syntastic checker toggle
noremap <silent><F5> :call SyntasticToggle()<CR>
imap    <silent><F5> <ESC><F5>a
function! SyntasticToggle()
    if &ft == 'perl'
        if exists('g:syntastic_enable_perl_checker') && g:syntastic_enable_perl_checker
            SyntasticReset
            let g:syntastic_enable_perl_checker = 0
            let g:syntastic_perl_checkers = ['']
        else
            let g:syntastic_enable_perl_checker = 1
            let g:syntastic_perl_checkers = ['perl']
            SyntasticCheck
        endif
    elseif &ft == 'rust'
        if g:syntastic_rust_checkers == ['']
            let g:syntastic_rust_checkers = ['rustc']
            SyntasticCheck
        else
            let g:syntastic_rust_checkers = ['']
            SyntasticReset
        endif
    elseif &ft == 'c'
        if g:syntastic_c_checkers == ['']
            let g:syntastic_c_checkers = ['clang_check']
            SyntasticCheck
        else
            let g:syntastic_c_checkers = ['']
            SyntasticReset
        endif
    elseif &ft == 'sh'
        if g:syntastic_sh_checkers == ['shellcheck']
            SyntasticReset
            let g:syntastic_sh_checkers = ['sh', 'shellcheck']
        else
            let g:syntastic_sh_checkers = ['shellcheck']
            let g:syntastic_sh_shellcheck_args = "-x"
            SyntasticCheck
        endif
    else
        SyntasticToggleMode
    endif
endfunction

let g:airline_powerline_fonts = 1

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

noremap <silent><F6> :HighlightRepeats<CR>
function! HighlightRepeats() range
    let lineCounts = {}
    let lineNum = a:firstline
    while lineNum <= a:lastline
        let lineText = getline(lineNum)
        if lineText != ""
            let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
        endif
        let lineNum = lineNum + 1
    endwhile
    exe 'syn clear Repeat'
    for lineText in keys(lineCounts)
        if lineCounts[lineText] >= 2
            exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
        endif
    endfor
endfunction

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()

"" spell
set sps=best,10
let spelllangs = ["en", "de"]
function! SpellToggle()
    if !exists('b:langidx') | let b:langidx = 0 | endif
    if b:langidx == len(g:spelllangs)
        setlocal nospell
        echo "nospell"
        let b:langidx = 0
    else
        let &l:spelllang=g:spelllangs[b:langidx]
        setlocal spell
        echo "spell: " . &spelllang
        let b:langidx = (b:langidx+1)
    endif
endfunction

if filereadable(expand("~/.vim/vimrc.local"))
    source ~/.vim/vimrc.local
endif
