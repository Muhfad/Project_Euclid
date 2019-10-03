

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy


setup(
name = "Something2",
# Not the name of the module
cmdclass = {"build_ext":build_ext},
# magic
ext_modules = [ Extension("mymodule2",
# The name of the module
["ceucdist.pyx"],
libraries=["eucdist"], include_dirs=[numpy.get_include()]) ]
)

# gcc -c eucdist.c -o eucdist.o
# ar cr libeucdist.a eucdist.o
# CFLAGS="-I." LDFLAGS="-L." python3 setup.py build_ext -i
