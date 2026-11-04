if [ "`which tcc`" != "" ]; then
 export PS1='$(printf "void* GetForegroundWindow();int GetClientRect(void*,void*);int ClientToScreen(void*,void*);int SetCursorPos(int,int);int main(){void* w=GetForegroundWindow();long r[4],p[2];if(w&&GetClientRect(w,r)){p[0]=r[2];p[1]=r[3];if(ClientToScreen(w,p))SetCursorPos(/*p[0]+30,p[1]-(r[3]/2)*/p[0]-15,p[1]-r[3]/20);}return 0;}" | tcc -run -luser32 -)$(eliminate_viminfo)\W\$ ' 
else
 export PS1='\W\$ '
fi
eliminate_viminfo

