if 0 | endif
set number
" set nowritebackup
" set nobackup
" set noswapfile
set noundofile
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set mouse=a

" clip board "
set clipboard+=unnamedplus

if &compatible
  set nocompatible
endif

if (has("termguicolors"))
  set termguicolors
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" :Kwbd でカレントウインドウのバッファを閉じる
:com! Kwbd let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn 



" for golang
if $GOROOT != ''
  set rtp +=$GOROOT/misc/vim
endif

" plugin dir
let s:dein_dir = expand('~/.cache/dein')
" dein.vim
let s:dein_repo_dir = s:dein_dir . 'repos/github.com/Shougo/dein.vim'

" clone dein.vim
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir = expand('~/.vim/rc')
  let s:toml = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  
  " cache toml
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  
  " 設定終了
  call dein#end()
  call dein#save_state()
endif


if dein#check_install()
  call dein#install()
endif

let g:python3_host_prog = '/usr/local/bin/python3'
"let g:python_host_prog = '/usr/bin/python'
if exists("$VIRTUAL_ENV")
  let g:python3_host_prog = substitute(system("which python"), '\n', '', 'g')
endif



filetype plugin on
filetype indent on


augroup python
  autocmd!
  "autocmd FileType python setl autoindent
  "autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python setlocal omnifunc=jedi#completions
  autocmd FileType python setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup END

augroup html
  autocmd!
  autocmd FileType html setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup END

autocmd FileType rust setl autoindent
autocmd FileType rust setl expandtab tabstop=4 shiftwidth=4 softtabstop=4

augroup js
  autocmd!
  autocmd FileType javascript setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType json setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType json setl conceallevel=0 concealcursor=
augroup END

augroup yaml
  autocmd!
  autocmd FileType yaml setl expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup END

augroup vue
  autocmd!
  autocmd FileType vue syntax sync fromstart
  autocmd FileType vue setl expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup END


set conceallevel=0
let g:vim_json_syntax_conceal=0

autocmd FileType vimfiler call unite#custom_default_action('directory', 'cd')


" rust
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif 
let g:rustfmt_autosave = 1
let g:rustfmt_command = expand('~/.cargo/bin/rustfmt')



""" unite.vim
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>



" Ctrl-Space で補完
" Windowsは <Nul>でなく <C-Space> とする
inoremap <Nul> <C-n>

" airline
" モードの表示名を定義(デフォルトだと長くて横幅を圧迫するので略称にしている)
set t_Co=256
let g:airline_mode_map = {
	\ 'n'  : 'N',
	\ 'i'  : 'I',
	\ 'R'  : 'R',
	\ 'c'  : 'C',
	\ 'v'  : 'Vi',
	\ 'V'  : 'VL',
	\ '⌃V' : 'VB',
	\ }

" パワーラインでかっこよく
let g:airline_powerline_fonts = 1
" カラーテーマ指定してかっこよく
let g:airline_theme = 'papercolor'
" タブバーをかっこよく
let g:airline#extensions#tabline#enabled = 1

" 選択行列の表示をカスタム(デフォルトだと長くて横幅を圧迫するので最小限に)
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])

" virtulenvを認識しているか確認用に、現在activateされているvirtualenvを表示(vim-virtualenvの拡張)
let g:airline#extensions#virtualenv#enabled = 1

" gitのHEADから変更した行の+-を非表示(vim-gitgutterの拡張)
let g:airline#extensions#hunks#enabled = 0

" Lintツールによるエラー、警告を表示(ALEの拡張)
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'


colorscheme tender

syntax on

