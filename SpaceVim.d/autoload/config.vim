func! config#before() abort
    imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
    let g:copilot_no_tab_map = v:true
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_global_ycm_extra_conf = '/home/lixq/toolchains/SpaceVim.d/.ycm_extra_conf.py'
    let g:ycm_semantic_triggers = { 'c,cpp,python,sh': ['re!\w{3}'] }
endf

func! config#after() abort
    let g:python3_host_prog = '/home/lixq/toolchains/Miniforge3/bin/python3'
endf
