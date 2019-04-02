/*
                                    __
                                   / _|
  __ _ _   _ _ __ ___  _ __ __ _  | |_ ___  ___ ___
 / _` | | | | '__/ _ \| '__/ _` | |  _/ _ \/ __/ __|
| (_| | |_| | | | (_) | | | (_| | | || (_) \__ \__ \
 \__,_|\__,_|_|  \___/|_|  \__,_| |_| \___/|___/___/

Copyright (C) 2018-2019 Aurora Free Open Source Software.

This file is part of the Aurora Free Open Source Software. This
organization promote free and open source software that you can
redistribute and/or modify under the terms of the GNU Lesser General
Public License Version 3 as published by the Free Software Foundation or
(at your option) any later version approved by the Aurora Free Open Source
Software Organization. The license is available in the package root path
as 'LICENSE' file. Please review the following information to ensure the
GNU Lesser General Public License version 3 requirements will be met:
https://www.gnu.org/licenses/lgpl.html .

Alternatively, this file may be used under the terms of the GNU General
Public License version 3 or later as published by the Free Software
Foundation. Please review the following information to ensure the GNU
General Public License requirements will be met:
http://www.gnu.org/licenses/gpl-3.0.html.

NOTE: All products, services or anything associated to trademarks and
service marks used or referenced on this file are the property of their
respective companies/owners or its subsidiaries. Other names and brands
may be claimed as the property of others.

For more info about intellectual property visit: aurorafoss.org or
directly send an email to: contact (at) aurorafoss.org .
*/

module riverd.xxf86vm.dynload;

public import riverd.loader;

public import riverd.xxf86vm.dynfun;

version(D_BetterC)
{
	void* dylib_load_xxf86vm() {
		void* handle = dylib_load("libXxf86vm.so");
		if(handle is null) handle = dylib_load("libXxf86vm.so.1");

		if(handle is null) return null;

		dylib_bindSymbol(handle, cast(void**)&XF86VidModeQueryExtension, "XF86VidModeQueryExtension");
		dylib_bindSymbol(handle, cast(void**)&XF86VidModeGetGammaRamp, "XF86VidModeGetGammaRamp");
		dylib_bindSymbol(handle, cast(void**)&XF86VidModeSetGammaRamp, "XF86VidModeSetGammaRamp");
		dylib_bindSymbol(handle, cast(void**)&XF86VidModeGetGammaRampSize, "XF86VidModeGetGammaRampSize");

		return handle;
	}
}
else
{
	private enum string[] _xxf86vm_libs = ["libXxf86vm.so", "libXxf86vm.so.1"];

	mixin(DylibLoaderBuilder!("Xxf86vm", _xxf86vm_libs, riverd.xxf86vm.dynfun));
}

unittest {
	void* xxf86vm_handle = dylib_load_xxf86vm();
	assert(dylib_is_loaded(xxf86vm_handle));

	dylib_unload(xxf86vm_handle);
}
