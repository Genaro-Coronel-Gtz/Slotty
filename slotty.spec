# -*- mode: python ; coding: utf-8 -*-

a = Analysis(
    ['app.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[
        'InquirerPy',
        'InquirerPy.base.control',
        'InquirerPy.resolver',
        'rich.console',
        'rich.logging'
    ],
    hookspath=[],
    hooksconfig=[],
    runtime_hooks=[],
    excludes=['tkinter', 'matplotlib', 'numpy'],
    noarchive=False,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],             # <-- IMPORTANTE: Vaciamos esto
    exclude_binaries=True, # <-- AGREGAMOS ESTO: Evita que meta todo en el .exe
    name='slotty',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None, 
)

# ESTE BLOQUE ES EL QUE CREA LA CARPETA CON LAS LIBRERÍAS AL LADO
coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='slotty' # Nombre de la carpeta final en dist/
)