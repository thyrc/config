" https://github.com/vim-airline/vim-airline (app-vim/airline)
" https://github.com/tpope/vim-fugitive/ (app-vim/fugitive)
" https://github.com/vim-syntastic/syntastic/ (app-vim/syntastic)
" https://github.com/rust-lang/rust.vim.git
" https://github.com/prabirshrestha/asyncomplete.vim.git
" https://github.com/prabirshrestha/asyncomplete-lsp.vim.git
" https://github.com/prabirshrestha/vim-lsp.git
" https://github.com/lifepillar/vim-mucomplete.git

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

set background=dark
colorscheme solarized

:set viminfo='50,<8096,s256,h
set hidden

" disable generation of .netrwhist
let g:netrw_dirhistmax = 0
" tree style listing
let g:netrw_liststyle = 3

" split window
set splitright
set splitbelow

nmap <C-L> :nohl <bar> :syn clear Repeat<CR>

" highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=DarkBlue gui=NONE guifg=DarkGrey guibg=NONE

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

let g:mucomplete#enable_auto_at_startup = 0
let g:mucomplete#completion_delay = 1
let g:lsp_diagnostics_float_cursor = 1
set completeopt+=menuone
set completeopt+=noselect
set shortmess+=c

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
let g:airline#extensions#branch#enabled=1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0

" let g:bufferline_echo = 0
"   autocmd VimEnter *
"     \ let &statusline='%{bufferline#refresh_status()}'
"     \ .bufferline#get_status_string()

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

" spell check
set sps=best,10
let spelllangs = ["en", "de"]
hi SpellBad cterm=underline
noremap <silent><F7> :call SpellToggle()<CR>
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

" lsp
" inoremap <C-j> <C-x><C-o>
nmap <plug>() <Plug>(lsp-float-close)

if executable('rust-analyzer')
  au User lsp_setup call lsp#register_server({
        \   'name': 'Rust Language Server',
        \   'cmd': {server_info->['rust-analyzer']},
        \   'root_uri':{server_info->lsp#utils#path_to_uri(
        \       lsp#utils#find_nearest_parent_file_directory(
        \           lsp#utils#get_buffer_path(),
        \           ['Cargo.toml', '.git/']
        \       ))},
        \   'whitelist': ['rust'],
        \   'initialization_options': {
        \     'cargo': {
        \       'buildScripts': {
        \         'enable': v:true,
        \       },
        \     },
        \     'procMacro': {
        \       'enable': v:true,
        \     },
        \     'lens': {
        \       'enable': v:false,
        \     },
        \   },
        \ })
endif

if executable('clangd')
  au User lsp_setup call lsp#register_server({
        \   'name': 'clangd',
        \   'cmd': {server_info->['clangd']},
        \   'whitelist': ['c', 'cpp'],
        \   'initialization_options': {},
        \   })
  let g:lsp_diagnostics_virtual_text_enabled = 0
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

if filereadable(expand("~/.vim/vimrc.local"))
    source ~/.vim/vimrc.local
endif
