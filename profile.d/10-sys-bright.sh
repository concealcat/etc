bright() {
 test "`which tcc`" = "" && return 1;
 tcc -luser32 -run - "$1" << 'EOF'
#include <windows.h>
#include <stdlib.h>
int main(int argc, char *argv[])
{
 HDC h = GetDC(0);
 WORD g[768];
 int b;
 int i;
 void *f;

 if (argc < 2) return 1;
 b = atoi(argv[1]);
 if (b < 1) b = 1;
 if (b > 100) b = 100;

 for (i = 0; i < 256; ++i) {
  int v = i * (b + 128);
  if (v > 65535) v = 65535;
  g[i] = g[i + 256] = g[i + 512] = (WORD)v;
 }
 f = GetProcAddress(LoadLibrary("gdi32.dll"), "SetDeviceGammaRamp");
 if (f) ((BOOL(WINAPI*)(HDC, void*))f)(h, g);
 ReleaseDC(0, h);
 return 0;
}
EOF
}

