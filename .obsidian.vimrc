unmap <Space>

noremap ; :

exmap command_palette obcommand command-palette:open
nnoremap <Space><Space> :command_palette<CR>


" File navigation.

exmap new_file obcommand file-explorer:new-file
nnoremap <Space>fn :new_file<CR>

exmap switcher obcommand switcher:open
nnoremap <Space>ff :switcher<CR>

exmap global_search global-search:open
nnoremap <Space>fs :global_search<CR>

exmap go_back obcommand app:go-back
nnoremap [[ :go_back<CR>
exmap go_forward obcommand app:go-forward
nnoremap ]] :go_forward<CR>


" Window navigation.

exmap wq obcommand workspace:close
exmap q obcommand workspace:close

exmap focus_right obcommand editor:focus-right
nmap <C-w>l :focus_right<CR>

exmap focus_left obcommand editor:focus-left
nmap <C-w>h :focus_left<CR>

exmap focus_top obcommand editor:focus-top
nmap <C-w>k :focus_top<CR>

exmap focus_bottom obcommand editor:focus-bottom
nmap <C-w>j :focus_bottom<CR>

exmap split_vertical obcommand workspace:split-vertical
nmap <C-w>v :split_vertical<CR>

exmap split_horizontal obcommand workspace:split-horizontal
nmap <C-w>s :split_horizontal<CR>


" Tab navigation.

exmap new_tab obcommand workspace:new-tab
nnoremap <Space>tn :new_tab<CR>

exmap close_tab obcommand workspace:close
nnoremap <Space>td :close_tab<CR>


" Text navigation.

nnoremap j gj
nnoremap k gk

noremap <C-h> b
inoremap <C-h> <C-o>b
noremap <C-l> w
inoremap <C-l> <C-o>w

noremap <C-j> 5gj
noremap <C-k> 5gk

noremap H g^
noremap L g$

noremap J G
noremap K gg


" Text editing.

nnoremap U <C-r>
