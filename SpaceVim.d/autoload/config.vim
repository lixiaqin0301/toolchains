func! config#before() abort
endf

func! config#after() abort
    let g:ycm_global_ycm_extra_conf = '~/.SpaceVim.d/.ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_semantic_triggers = { 'c,cpp,python,sh': ['re!\w{3}'] }
    "let g:ycm_filetype_whitelist = { c":1, cpp":1, python":1, sh":1 }
endf
