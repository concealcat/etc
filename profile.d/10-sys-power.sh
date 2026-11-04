power() {
 tcc -run - <<'EOF' 2>/dev/null
#include <stdio.h>
#include <windows.h>
int main() {
 SYSTEM_POWER_STATUS sps;
 if (GetSystemPowerStatus(&sps) && sps.BatteryLifePercent != 255) {
  printf("%d%%\n", sps.BatteryLifePercent);
  return 0;
 }
 return 1;
}
EOF
}

