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
    '/usr/lib/gcc/x86_64-redhat-linux/9/include',
    '-isystem',
    '/usr/lib/gcc/x86_64-redhat-linux/4.8.5/include',
    '-isystem',
    '/usr/lib/gcc/x86_64-redhat-linux/4.4.4/include',
    '-isystem',
    '/usr/lib/gcc/x86_64-redhat-linux/4.1.1/include',
    '-isystem',
    '/usr/lib/gcc/arm-linux-gnueabihf/6/include',
    '-isystem',
    '/usr/lib/gcc/arm-linux-gnueabihf/6/include-fixed',
    '-isystem',
    '/usr/include/arm-linux-gnueabihf',
    '-isystem',
    '/usr/local/include',
    '-isystem',
    '/usr/include',
]

compilation_database_folder = ''

if os.path.exists( compilation_database_folder ):
  database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
  database = None

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def IsHeaderFile( filename ):
  extension = os.path.splitext( filename )[ 1 ]
  return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


def FindCorrespondingSourceFile( filename ):
  if IsHeaderFile( filename ):
    basename = os.path.splitext( filename )[ 0 ]
    for extension in SOURCE_EXTENSIONS:
      replacement_file = basename + extension
      if os.path.exists( replacement_file ):
        return replacement_file
  return filename


def FlagsForFile( filename, **kwargs ):
  filename = FindCorrespondingSourceFile( filename )

  if not database:
    return {
      'flags': flags,
      'include_paths_relative_to_dir': DirectoryOfThisScript(),
      'override_filename': filename
    }

  compilation_info = database.GetCompilationInfoForFile( filename )
  if not compilation_info.compiler_flags_:
    return None

  final_flags = list( compilation_info.compiler_flags_ )

  return {
    'flags': final_flags,
    'include_paths_relative_to_dir': compilation_info.compiler_working_dir_,
    'override_filename': filename
  }
