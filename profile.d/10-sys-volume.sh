volume() {
 test "`which tcc`" = "" && return 1;
 tcc -lole32 -run - "$1" << 'EOF'
#include <windows.h>
#include <stdlib.h>
 typedef struct IMMDeviceEnumerator IMMDeviceEnumerator;
 typedef struct IMMDevice IMMDevice;
 typedef struct IAudioEndpointVolume IAudioEndpointVolume;
 struct IMMDeviceEnumeratorVtbl {
  HRESULT (STDMETHODCALLTYPE *QueryInterface)(IMMDeviceEnumerator*, REFIID, void**);
  ULONG (STDMETHODCALLTYPE *AddRef)(IMMDeviceEnumerator*);
  ULONG (STDMETHODCALLTYPE *Release)(IMMDeviceEnumerator*);
  HRESULT (STDMETHODCALLTYPE *EnumAudioEndpoints)(IMMDeviceEnumerator*, int, DWORD, void**);
  HRESULT (STDMETHODCALLTYPE *GetDefaultAudioEndpoint)(IMMDeviceEnumerator*, int, int, IMMDevice**);
 };
 struct IMMDeviceEnumerator {
  struct IMMDeviceEnumeratorVtbl *lpVtbl;
 };
 struct IMMDeviceVtbl {
  HRESULT (STDMETHODCALLTYPE *QueryInterface)(IMMDevice*, REFIID, void**);
  ULONG (STDMETHODCALLTYPE *AddRef)(IMMDevice*);
  ULONG (STDMETHODCALLTYPE *Release)(IMMDevice*);
  HRESULT (STDMETHODCALLTYPE *Activate)(IMMDevice*, REFIID, DWORD, void**, void**);
 };
 struct IMMDevice {
  struct IMMDeviceVtbl *lpVtbl;
 };
 struct IAudioEndpointVolumeVtbl {
  HRESULT (STDMETHODCALLTYPE *QueryInterface)(IAudioEndpointVolume*, REFIID, void**);
  ULONG (STDMETHODCALLTYPE *AddRef)(IAudioEndpointVolume*);
  ULONG (STDMETHODCALLTYPE *Release)(IAudioEndpointVolume*);
  HRESULT (STDMETHODCALLTYPE *RegisterControlChangeNotify)(IAudioEndpointVolume*, void*);
  HRESULT (STDMETHODCALLTYPE *UnregisterControlChangeNotify)(IAudioEndpointVolume*, void*);
  HRESULT (STDMETHODCALLTYPE *GetChannelCount)(IAudioEndpointVolume*, UINT*);
  HRESULT (STDMETHODCALLTYPE *SetMasterVolumeLevel)(IAudioEndpointVolume*, float, LPCGUID);
  HRESULT (STDMETHODCALLTYPE *SetMasterVolumeLevelScalar)(IAudioEndpointVolume*, float, LPCGUID);
 };
 struct IAudioEndpointVolume {
  struct IAudioEndpointVolumeVtbl *lpVtbl;
 };
int main(int c, char *v[])
{
 if (c < 2) return 1;
 float vol = atoi(v[1]) / 100.0f;
 GUID clsid = {0xBCDE0395,0xE52F,0x467C,{0x8E,0x3D,0xC4,0x57,0x92,0x91,0x69,0x2E}};
 GUID iid_e = {0xA95664D2,0x9614,0x4F35,{0xA7,0x46,0xDE,0x8D,0xB6,0x36,0x17,0xE6}};
 GUID iid_v = {0x5CDF2C82,0x841E,0x4546,{0x97,0x22,0x0C,0xF7,0x40,0x78,0x22,0x9A}};

 CoInitialize(NULL);
 IMMDeviceEnumerator *e;
 if (CoCreateInstance(&clsid, NULL, CLSCTX_INPROC_SERVER, &iid_e, (void**)&e) == S_OK) {
  IMMDevice *d;
  if (e->lpVtbl->GetDefaultAudioEndpoint(e, 0, 0, &d) == S_OK) {
   IAudioEndpointVolume *ep;
   if (d->lpVtbl->Activate(d, &iid_v, CLSCTX_INPROC_SERVER, NULL, (void**)&ep) == S_OK) {
    ep->lpVtbl->SetMasterVolumeLevelScalar(ep, vol, NULL);
    ep->lpVtbl->Release(ep);
   }
   d->lpVtbl->Release(d);
  }
  e->lpVtbl->Release(e);
 }
 CoUninitialize();
 return 0;
}
EOF
}
  
