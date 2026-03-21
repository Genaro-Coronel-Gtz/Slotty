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
    hooksconfig={},
    runtime_hooks=[],
    excludes=['tkinter', 'matplotlib', 'numpy'], # Solo lo que realmente no usas
    noarchive=False,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='slotty',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,  # IMPORTANTE: No activar en Mac con Python 3.11
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None, 
)