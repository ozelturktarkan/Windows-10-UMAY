r"""Reversible SearchUI change in a prepared UMAY WIM, not the running OS.
Run on a disposable working copy after applying NTLite-UMAY.xml.
Example: python Finalize-Wim.py --wim X:\media\sources\install.wim --dll X:\NTLite\Tools\wimlib\x64\libwim-15.dll
"""
from pathlib import Path
import argparse,ctypes,json
p=argparse.ArgumentParser();p.add_argument('--wim',required=True);p.add_argument('--dll',required=True);p.add_argument('--check-only',action='store_true');a=p.parse_args()
path=Path(a.wim).resolve();assert path.suffix.lower()=='.wim' and path.is_file()
w=ctypes.CDLL(str(Path(a.dll).resolve()));ptr=ctypes.c_void_p()
w.wimlib_get_error_string.argtypes=[ctypes.c_int];w.wimlib_get_error_string.restype=ctypes.c_wchar_p
def check(code):
 if code:raise RuntimeError(str(code)+': '+str(w.wimlib_get_error_string(code)))
w.wimlib_global_init.argtypes=[ctypes.c_int];check(w.wimlib_global_init(2))
w.wimlib_open_wim.argtypes=[ctypes.c_wchar_p,ctypes.c_int,ctypes.POINTER(ctypes.c_void_p)]
w.wimlib_get_image_property.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_wchar_p];w.wimlib_get_image_property.restype=ctypes.c_wchar_p
w.wimlib_get_image_name.argtypes=[ctypes.c_void_p,ctypes.c_int];w.wimlib_get_image_name.restype=ctypes.c_wchar_p
w.wimlib_rename_path.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_wchar_p,ctypes.c_wchar_p]
w.wimlib_overwrite.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_uint];w.wimlib_free.argtypes=[ctypes.c_void_p]
try:
 check(w.wimlib_open_wim(str(path),0 if a.check_only else 4,ctypes.byref(ptr)))
 props={k:w.wimlib_get_image_property(ptr,1,k) for k in ['NAME','WINDOWS/EDITIONID','WINDOWS/ARCH','WINDOWS/VERSION/BUILD']}
 assert props['WINDOWS/EDITIONID']=='Core' and props['WINDOWS/ARCH']=='0' and props['WINDOWS/VERSION/BUILD']=='14393',props
 assert not w.wimlib_get_image_name(ptr,2),'Only one Home image is allowed'
 if not a.check_only:
  file='/Windows/SystemApps/Microsoft.Windows.Cortana_cw5n1h2txyewy/SearchUI.exe'
  check(w.wimlib_rename_path(ptr,1,file,file+'.UMAY-disabled'))
  check(w.wimlib_overwrite(ptr,0,1))
 print(json.dumps({'image':props,'single_image':True,'check_only':a.check_only}))
finally:
 if ptr:w.wimlib_free(ptr)
