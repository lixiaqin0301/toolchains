import os
import ycm_core

flags = [
    '-Wno-error',
    '-std=gnu11',
    '-D_GNU_SOURCE',
    '-x',
    'c',
    '-I',
    '.',
    '-isystem',
    '/usr/lib/gcc/x86_64-redhat-linux/4.8.5/include',
    '-isystem',
    '/opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/include',
    '-isystem',
    '/usr/lib/gcc/x86_64-linux-gnu/11/include',
    '-isystem',
    '/usr/local/include',
    '-isystem',
    '/opt/rh/devtoolset-11/root/usr/include',
    '-isystem',
    '/usr/include/x86_64-linux-gnu',
    '-isystem',
    '/usr/include',
]

def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))

def Settings(**kwargs):
    return {
        'flags': flags,
        'include_paths_relative_to_dir': DirectoryOfThisScript()
    }
