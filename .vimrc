set incsearch
set hlsearch
set wildmode=longest,list

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

nmap <C-L> :nohl <bar> :syn clear Repeat<CR>

set background=dark
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=DarkBlue gui=NONE guifg=DarkGrey guibg=NONE

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()

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

if filereadable(expand("/usr/share/vim/vimfiles/autoload/pathogen.vim"))
    runtime /usr/share/vim/vimfiles/autoload/pathogen.vim
    execute pathogen#infect()
endif

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

if filereadable(expand("~/.vim/vimrc.local"))
    source ~/.vim/vimrc.local
endif

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
