center() {
    test "`which tcc`" = "" && return 1;
    tcc -luser32 -run - << 'EOF'
#include <windows.h>
int main() {
    HWND hwnd = GetForegroundWindow();
    if (!hwnd) return 1;

    LONG_PTR style = GetWindowLongPtr(hwnd, GWL_STYLE);
    if ((style & WS_CHILD) || (style & WS_MAXIMIZE) || (style & WS_MINIMIZE)) return 0;

    HMONITOR hMonitor = MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
    MONITORINFO mi;
    mi.cbSize = sizeof(MONITORINFO);

    if (GetMonitorInfo(hMonitor, &mi)) {
        RECT rcWindow;
        GetWindowRect(hwnd, &rcWindow);
        
        int winWidth  = rcWindow.right - rcWindow.left;
        int winHeight = rcWindow.bottom - rcWindow.top;

        int workWidth  = mi.rcWork.right - mi.rcWork.left;
        int workHeight = mi.rcWork.bottom - mi.rcWork.top;

        int posX = mi.rcWork.left + (workWidth - winWidth) / 2;
        int posY = mi.rcWork.top + (workHeight - winHeight) / 2;

        SetWindowPos(hwnd, HWND_TOP, posX, posY, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }
    return 0;
}
EOF
}

