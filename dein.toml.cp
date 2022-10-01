[[plugins]]
repo = 'Shougo/dein.vim'

[[plugins]]
repo = 'leico/autodate.vim'

[[plugins]] # gccでコメント
repo = 'tomtom/tcomment_vim'

[[plugins]]
repo = 'Shougo/deoplete.nvim'
on_i = 1
hook_add = '''
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#enable_smart_case = 1
    " <TAB>: completion.
    imap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : deoplete#mappings#manual_complete()
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction
    " <S-TAB>: completion back.
    inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"
'''

[[plugins]]
repo = 'nathanaelkane/vim-indent-guides'
hook_add = '''
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_color_change_percent = 6
  let g:indent_guides_auto_colors=0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=236
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=237
  let g:indent_guides_guide_size=2
'''


[[plugins]] # tomlのsyntax
repo = 'cespare/vim-toml'

[[plugins]] # 行末の不要な半角スペースを可視化
repo = 'bronson/vim-trailing-whitespace'

[[plugins]]
repo = 'roxma/nvim-yarp'

[[plugins]]
repo = 'roxma/vim-hug-neovim-rpc'

[[plugins]]
repo = 'Shougo/neosnippet.vim'
hook_add = '''
  let g:neosnippet#snippets_directory = '~/.config/nvim/snippets'
  let g:neosnippet#enable_snipmate_compatibility = 1
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k> <Plug>(neosnippet_expand_target)
  if has('conceal')
      set conceallevel=2 concealcursor=niv
  endif
'''

[[plugins]]
repo = 'Shougo/neosnippet-snippets'

[[plugins]] # クオートや括弧の対を自動入力
repo = 'Townk/vim-autoclose'

[[plugins]]
repo = 'vim-syntastic/syntastic'
hook_add = '''
  set statusline+=%#warningmsg#
  set statusline+=%*
  let g:syntastic_always_populate_loc_list = 0
  let g:syntastic_auto_loc_list = 0
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_perl_interpreter = 1
  let g:syntastic_yaml_yamlxs_exec = 1
'''

[[plugins]]
repo = 'sheerun/vim-polyglot'

[[plugins]]
repo  = 'prettier/vim-prettier'
build = 'npm install'
on_ft = ['js','ts','typescriptreact','jsx','tsx','css','scss','json','yaml','toml','markdown']
hook_add = '''
  let g:prettier#autoformat = 0
  let g:prettier#quickfix_enabled = 0
  let g:prettier#config#config_precedence = 'file-override'
  let g:prettier#config#single_quote = 'true'
  let g:prettier#config#arrow_parens = 'avoid'
  let g:prettier#config#trailing_comma = 'all'
  let g:prettier#config#jsx_single_quote = 'true'
  let g:prettier#config#jsx_bracket_same_line = 'true'
  autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.yaml,*.yml,*.md,*.toml PrettierAsync
'''

[[plugins]]
repo = 'tpope/vim-fugitive'

[[plugins]]
repo = 'airblade/vim-gitgutter'

[[plugins]]
repo = 'editorconfig/editorconfig-vim'

[[plugins]]
repo = 'rust-lang/rust.vim'
on_ft = 'rust'
hook_add = '''
  let g:rustfmt_autosave = 1
'''

[[plugins]]
repo = 'prabirshrestha/async.vim'

[[plugins]]
repo = 'prabirshrestha/asyncomplete.vim'

[[plugins]]
repo = 'prabirshrestha/asyncomplete-lsp.vim'

[[plugins]]
repo = 'prabirshrestha/vim-lsp'
hook_add = '''
  if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
  endif

  if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx', 'javascript', 'javascript.jsx'],
        \ })
  endif

  if (executable('pyls'))
    augroup LspPython
      autocmd!
      autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': { server_info -> ['pyls'] },
          \ 'whitelist': ['python'],
          \})
    augroup END
  endif

  if executable('rls')
      au User lsp_setup call lsp#register_server({
          \ 'name': 'rls',
          \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
          \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
          \ 'whitelist': ['rust'],
          \ })
  endif

  if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
  endif

  nnoremap <silent> <C-[> :LspPeekDefinition <CR>
  nnoremap <silent> <C-]> :vsplit \| :LspDefinition <CR>
  nnoremap <silent> <C-j> :vsplit \| :LspImplementation <CR>
  nnoremap <silent> <C-h> :LspHover<CR>
  nnoremap <silent> <C-a> :LspRename<CR>
  nnoremap <silent> <C-n> :LspNextError<CR>
  let g:lsp_signs_error = {'text': '✗'}
  let g:lsp_signs_error = {'text': '!!'}
  let g:lsp_signs_enabled = 1
  let g:lsp_diagnostics_enabled = 1
  let g:lsp_virtual_text_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_highlight_references_enabled = 1
'''

[[plugins]]
repo = 'mattn/vim-lsp-icons'

[[plugins]]
repo = 'hrsh7th/vim-vsnip'

[[plugins]]
repo = 'hrsh7th/vim-vsnip-integ'

[[plugins]]
repo = 'mattn/vim-goimports'
hook_add = '''
  let g:goimports = 1
'''

[[plugins]]
repo = 'mattn/vim-sonictemplate'

[[plugins]]
repo = 'previm/previm'

[[plugins]]
repo = 'tyru/open-browser.vim'

[[plugins]]
repo = 'skanehira/preview-markdown.vim'
hook_add = '''
  let g:preview_markdown_vertical = 1
'''

[[plugins]]
repo = 'junegunn/fzf'
dir = '~/.fzf'
do = 'fzf#install()'
build = './install --all'

[[plugins]]
repo = 'junegunn/fzf.vim'
on_cmd = [
    'Files',
    'ProjectFiles',
    'Buffers',
    'BLines',
    'History',
    'Tags',
    'BTags',
    'GFiles',
    'Ag',
]
hook_add = '''
  nnoremap <silent> ,a :<C-u>Ag<CR>
  nnoremap <silent> ,f :<C-u>GFiles<CR>
  nnoremap <silent> ,b :<C-u>Buffers<CR>
  nnoremap <silent> ,m :<C-u>History<CR>
'''

[[plugins]]
repo = 'hashivim/vim-terraform'

[[plugins]]
repo = 'preservim/nerdtree'
on_event='NERDTreeToggle'
hook_add = '''
  let g:NERDTreeShowHidden=1
  autocmd VimEnter * execute 'NERDTree'
  nnoremap <silent><C-e> :NERDTreeToggle<CR>
'''

