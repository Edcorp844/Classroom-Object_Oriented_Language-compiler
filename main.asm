format ELF64
section '.text' executable

;
;
; Ref.init_
;
; Initializes a Ref object with the address to the data of the object
;
;   INPUT: rax contains self
;   STACK:
;      - value: Object
;   OUTPUT: rax contains self
;
Ref.init_:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- *arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     qword [rbp - loc_0], rax

    ; self.val <- t0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Ref.null
;
; Creates a null Ref object
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax points to the Ref object
;
Ref.null:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; self.val <- 0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, 0
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret
;
;
; Ref.addr
;
; Returns the value of the pointer stored in the Ref object
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax points to the new Int object containing the address
;
Ref.addr:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t0.val <- t1
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_1]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Ref.deref_
;
; Dereferences a Ref object
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax points to the object
;
Ref.deref_:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- self.val - slot_0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    sub     rax, [slot_0]
    mov     qword [rbp - loc_0], rax

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; SockAddr.init_
;
; Initialize a SockAddr object from a string of bytes (16)
;
;   INPUT: rax contains self
;   STACK:
;      - value: String
;   OUTPUT: rax contains self
;
SockAddr.init_:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- arg0.s(0)
    mov     rax, qword [rbp + arg_0]
    add     rax, [slot_1]
    mov     rax, [rax]
    mov     qword [rbp - loc_0], rax

    ; self.val(0) <- t0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; t0 <- arg0.s(1)
    mov     rax, qword [rbp + arg_0]
    add     rax, [slot_2]
    mov     rax, [rax]
    mov     qword [rbp - loc_0], rax

    ; self.val(1) <- t0
    mov     rax, rbx
    add     rax, [slot_1]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; read syscall
;
;   INPUT: rax contains self
;   STACK:
;      - file descriptor: Int
;      - buf: Ref (String)
;      - count: Int
;   OUTPUT: rax points to the int object containing the number of bytes read
;
Linux.read:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 56                    ; allocate 7 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg2.val
    mov     rax, [rbp + arg_2]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- allocate_string(t1)
    mov     rdi, qword [rbp - loc_1]
    call    allocate_string
    mov     qword [rbp - loc_2], rax

    ; t3 <- *t2.s
    mov     rax, qword [rbp - loc_2]
    add     rax, [slot_1]
    mov     qword [rbp - loc_3], rax

    ; t4 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_4], rax

    ; t5 <- syscall read(t4, t3, t1)
    mov     rdi, qword [rbp - loc_4]
    mov     rsi, qword [rbp - loc_3]
    mov     rdx, qword [rbp - loc_1]
    mov     rax, 0
    syscall
    mov     qword [rbp - loc_5], rax

    ; t0.val <- t5
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_5]
    mov     [rax], rdi

    ; t2.l <- t0
    mov     rax, qword [rbp - loc_2]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     qword [rax], rdi

    ; arg1.val <- t2 + slot_0
    mov     rax, [rbp + arg_1]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_2]
    add     rdi, [slot_0]
    mov     [rax], rdi

    ; return t5
    mov     rax, qword [rbp - loc_5]

    pop     rbx                        ; restore register
    add     rsp, 56                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; write syscall
;
;   INPUT: rax contains self
;   STACK:
;      - file descriptor: Int
;      - buf: String
;      - count: Int
;   OUTPUT: rax points to the int object containing the number of bytes written
;
Linux.write:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 56                    ; allocate 7 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg1.s
    mov     rax, [rbp + arg_1]
    add     rax, [slot_1]
    mov     qword [rbp - loc_2], rax

    ; t3 <- arg2.val
    mov     rax, [rbp + arg_2]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_3], rax

    ; t4 <- syscall write(t1, t2, t3)
    mov     rdi, qword [rbp - loc_1]
    mov     rsi, qword [rbp - loc_2]
    mov     rdx, qword [rbp - loc_3]
    mov     rax, 1
    syscall
    mov     qword [rbp - loc_4], rax

    ; t0.val <- t4
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_4]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 56                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; close syscall
;
;   INPUT: rax contains self
;   STACK:
;      - file descriptor: Int
;   OUTPUT: rax points to the int object containing the return value
;
Linux.close:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- syscall close(t1)
    mov     rdi, qword [rbp - loc_1]
    mov     rax, 3
    syscall
    mov     qword [rbp - loc_2], rax

    ; t0.val <- t2
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_2]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; socket syscall
;
;   INPUT: rax contains self
;   STACK:
;      - domain: Int
;      - type: Int
;      - protocol: Int
;   OUTPUT: rax points to the Int object containing the file descriptor
;
Linux.socket:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg1.val
    mov     rax, [rbp + arg_1]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- arg2.val
    mov     rax, [rbp + arg_2]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_3], rax

    ; t4 <- syscall socket(t1, t2, t3)
    mov     rdi, qword [rbp - loc_1]
    mov     rsi, qword [rbp - loc_2]
    mov     rdx, qword [rbp - loc_3]
    mov     rax, 41
    syscall
    mov     qword [rbp - loc_4], rax

    ; t0.val <- t4
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_4]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; connect syscall
;
;   INPUT: rax contains self
;   STACK:
;      - sockfd: Int
;      - addr: Ref (SockAddr)
;      - addrlen: Ref
;   OUTPUT: rax points to the Int object containing the return value
;
Linux.connect:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg1.val
    mov     rax, [rbp + arg_1]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- arg2.val
    mov     rax, [rbp + arg_2]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_3], rax

    ; t4 <- syscall connect(t1, t2, t3)
    mov     rdi, qword [rbp - loc_1]
    mov     rsi, qword [rbp - loc_2]
    mov     rdx, qword [rbp - loc_3]
    mov     rax, 42
    syscall
    mov     qword [rbp - loc_4], rax

    ; t0.val <- t4
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_4]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; accept syscall
;
;   INPUT: rax contains self
;   STACK:
;      - sockfd: Int
;      - addr: Ref (SockAddr)
;      - addrlen: Ref (Int)
;   OUTPUT: rax points to the Int object containing the file descriptor
;
Linux.accept:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg1.val
    mov     rax, [rbp + arg_1]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- arg2.val
    mov     rax, [rbp + arg_2]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_3], rax

    ; t4 <- syscall accept(t1, t2, t3)
    mov     rdi, qword [rbp - loc_1]
    mov     rsi, qword [rbp - loc_2]
    mov     rdx, qword [rbp - loc_3]
    mov     rax, 43
    syscall
    mov     qword [rbp - loc_4], rax

    ; t0.val <- t4
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_4]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; bind syscall
;
;   INPUT: rax contains self
;   STACK:
;      - sockfd: Int
;      - addr: Ref (SockAddr)
;      - addrlen: Int
;   OUTPUT: rax points to the Int object containing the return value
;
Linux.bind:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg1.val
    mov     rax, [rbp + arg_1]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- arg2.val
    mov     rax, [rbp + arg_2]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_3], rax

    ; t4 <- syscall bind(t1, t2, t3)
    mov     rdi, qword [rbp - loc_1]
    mov     rsi, qword [rbp - loc_2]
    mov     rdx, qword [rbp - loc_3]
    mov     rax, 49
    syscall
    mov     qword [rbp - loc_4], rax

    ; t0.val <- t4
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_4]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; listen syscall
;
;   INPUT: rax contains self
;   STACK:
;      - sockfd: Int
;      - backlog: Int
;   OUTPUT: rax points to the Int object containing the return value
;
Linux.listen:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg1.val
    mov     rax, [rbp + arg_1]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- syscall listen(t1, t2)
    mov     rdi, qword [rbp - loc_1]
    mov     rsi, qword [rbp - loc_2]
    mov     rax, 50
    syscall
    mov     qword [rbp - loc_3], rax

    ; t0.val <- t3
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
; exit syscall
;
;   INPUT: rax contains self
;   STACK:
;      - status: Int
;   OUTPUT: never returns
;
Linux.exit:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables

    mov     rdi, [rbp + arg_0]
    add     rdi, [slot_0]
    mov     rdi, [rdi]

    mov     rax, 60
    syscall
; self in rax
; arguments on the stack
; return value in rax

section '.data'
; Define some constants
obj_tag dq 0
obj_size dq 8
disp_tab dq 16
slot_0 dq 24
slot_1 dq 32
slot_2 dq 40

loc_0 = 8
loc_1 = 16
loc_2 = 24
loc_3 = 32
loc_4 = 40
loc_5 = 48
loc_6 = 56
loc_7 = 64

arg_0 = 16
arg_1 = 24
arg_2 = 32
arg_3 = 40
arg_4 = 48
arg_5 = 56
arg_6 = 64
arg_7 = 72

; Define entry point
section '.text' executable
public _start
_start:
    ; Initialize the heap
    call    allocator_init
    ; Call the main method
    mov     rax, Main_protObj
    call    Object.copy
    call    Main_init
    call    Main.main
    ; Exit the program
    mov     rax, 60
    xor     rdi, rdi
    syscall

;
;
; Copy method
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax points to the newly created copy.
;
Object.copy:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t1 <- sizeof(self)
    mov     rax, rbx
    add     rax, [obj_size]            ; get *self.size
    mov     rax, [rax]                 ; get self.size
    shl     rax, 3                     ; size = size * 8
    mov     qword [rbp - loc_1], rax

    ; t0 <- allocate(t1)
    mov     rdi, qword [rbp - loc_1]
    call    allocate
    mov     qword [rbp - loc_0], rax

    ; memcpy(t0, self, t1)
    mov     rdi, qword [rbp - loc_0]
    mov     rsi, rbx
    mov     rdx, qword [rbp - loc_1]
    call    memcpy

    ; t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Object.type_name
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax reference to class name string object
;
Object.type_name:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- class_nameTab
    mov    rax, class_nameTab
    mov    qword [rbp - loc_0], rax

    ; t1 <- obj_tag(self)
    mov    rax, rbx
    add    rax, [obj_tag]
    mov    rax, [rax]
    mov    qword [rbp - loc_1], rax

    ; t2 <- t1 * 8
    mov    rax, qword [rbp - loc_1]
    shl    rax, 3
    mov    qword [rbp - loc_2], rax

    ; t3 <- t0 + t2
    mov    rax, qword [rbp - loc_0]
    add    rax, qword [rbp - loc_2]
    mov    qword [rbp - loc_3], rax

    ; deref t3
    mov    rax, qword [rbp - loc_3]
    mov    rax, [rax]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Object.equals
;
;   Compares two objects for equality.
;   This represents the default implementation of the equals method.
;
;   INPUT: rax contains self
;   STACK:
;        x object
;   OUTPUT: rax contains a boolean object
Object.equals:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Bool
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init
    mov     qword [rbp - loc_0], rax

    ; cmp address of self == address of x
    mov     rdi, rbx
    mov     rsi, [rbp + arg_0]
    cmp     rdi, rsi
    setz    al
    movzx   rax, al
    mov     qword [rbp - loc_1], rax

    ; t0.val <- t1
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_1]
    mov     [rax], rdi

    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Byte.to_string
;
;   Converts a byte to a single character string (assume ASCII).
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax contains a string object
Byte.to_string:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t3 <- 1
    mov     qword [rbp - loc_3], 1

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- allocate_string(t3)
    mov     rdi, qword [rbp - loc_3]
    call    allocate_string
    mov     qword [rbp - loc_1], rax

    ; t2 <- t1.s
    mov     rax, qword [rbp - loc_1]
    add     rax, [slot_1]
    mov     qword [rbp - loc_2], rax

    ; t4 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_4], rax

    ; t1.s <- t4
    mov     rax, qword [rbp - loc_1]
    add     rax, [slot_1]
    mov     rdi, qword [rbp - loc_4]
    mov     byte [rax], dil

    ; t0.val <- t3
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; t1.l <- t0
    mov     rax, qword [rbp - loc_1]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     qword [rax], rdi

    ; return t1
    mov     rax, qword [rbp - loc_1]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Byte.from_string
;
;   Converts a single character string to a byte (assume ASCII).
;
;   INPUT: rax contains self
;   STACK: contains a string object
;   OUTPUT: rax contains a byte object
Byte.from_string:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- arg0.s
    mov     rax, [rbp + arg_0]
    add     rax, [slot_1]
    movzx   rax, byte [rax]
    mov     qword [rbp - loc_0], rax

    ; self.val <- t0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Byte.from_int
;
;   Converts an integer to a byte.
;
;   INPUT: rax contains self
;   STACK: contains an int object
;   OUTPUT: rax contains a byte object
;
Byte.from_int:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    movzx   rax, byte [rax]
    mov     qword [rbp - loc_0], rax

    ; self.val <- t0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Byte.to_int
;
;   Converts a byte to an integer.
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax contains an int object
;
Byte.to_int:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t0.val <- t1
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_1]
    mov     qword [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret
;
;
; Word.from_int
;
;   Converts an integer to a word.
;
;   INPUT: rax contains self
;   STACK: contains an int object
;   OUTPUT: rax contains a Word object
;
Word.from_int:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    movzx   rax, word [rax]
    mov     qword [rbp - loc_0], rax

    ; self.val <- t0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Word.to_int
;
;   Converts a word to an integer.
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax contains an int object
;
Word.to_int:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t0.val <- t1
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_1]
    mov     qword [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret
;
;
; DoubleWord.from_int
;
;   Converts an integer to a double word.
;
;   INPUT: rax contains self
;   STACK: contains an int object
;   OUTPUT: rax contains a DoubleWord object
;
DoubleWord.from_int:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     eax, dword [rax]
    mov     qword [rbp - loc_0], rax

    ; self.val <- t0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; DoubleWord.to_int
;
;   Converts a double word to an integer.
;
;   INPUT: rax contains self
;   STACK: empty
;   OUTPUT: rax contains an int object
;
DoubleWord.to_int:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t0.val <- t1
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_1]
    mov     qword [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.from_int
;
;  Converts an integer to a float.
;
;  INPUT: rax contains self
;  STACK: contains an int object
;  OUTPUT: rax contains a float object
;
Float.from_int:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 8                     ; allocate 1 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_0], rax

    ; float t0
    cvtsi2ss xmm0, dword [rbp - loc_0]
    movss   dword [rbp - loc_0], xmm0

    ; self.val <- t0
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 8                     ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.from_fraction
;
; Converts a fraction to a float.
;
; INPUT: rax contains self
; STACK:
;      - numerator: Int
;      - denominator: Int
; OUTPUT: rax contains a float object
;
Float.from_fraction:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg1.val
    mov     rax, [rbp + arg_1]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- t1 / t2
    cvtsi2ss xmm0, dword [rbp - loc_1]
    cvtsi2ss xmm1, dword [rbp - loc_2]
    divss   xmm0, xmm1
    movss   dword [rbp - loc_3], xmm0

    ; self.val <- t3
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.to_int
;
;  Converts a float to an integer.
;
;  INPUT: rax contains self
;  STACK: empty
;  OUTPUT: rax contains an int object
;
Float.to_int:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; int t1
    xor      rax, rax
    cvttss2si eax, dword [rbp - loc_1]
    movsxd   rax, eax
    mov      qword [rbp - loc_1], rax

    ; t0.val <- t1
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_1]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.mul
;
;  Multiplies two floats.
;
;  INPUT: rax contains self
;  STACK: other: Float
;  OUTPUT: rax contains a float object
;
Float.mul:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Float
    mov     rax, Float_protObj
    call    Object.copy
    call    Float_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- t1 * t2
    movss   xmm0, dword [rbp - loc_1]
    movss   xmm1, dword [rbp - loc_2]
    mulss   xmm0, xmm1
    movss   dword [rbp - loc_3], xmm0

    ; self.val <- t3
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.div
;
;  Divides two floats.
;
;  INPUT: rax contains self
;  STACK: other: Float
;  OUTPUT: rax contains a float object
;
Float.div:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Float
    mov     rax, Float_protObj
    call    Object.copy
    call    Float_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- t1 / t2
    movss   xmm0, dword [rbp - loc_1]
    movss   xmm1, dword [rbp - loc_2]
    divss   xmm0, xmm1
    movss   dword [rbp - loc_3], xmm0

    ; self.val <- t3
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.add
;
;  Adds two floats.
;
;  INPUT: rax contains self
;  STACK: other: Float
;  OUTPUT: rax contains a float object
;
Float.add:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Float
    mov     rax, Float_protObj
    call    Object.copy
    call    Float_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- t1 + t2
    movss   xmm0, dword [rbp - loc_1]
    movss   xmm1, dword [rbp - loc_2]
    addss   xmm0, xmm1
    movss   dword [rbp - loc_3], xmm0

    ; self.val <- t3
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.sub
;
;  Subtracts two floats.
;
;  INPUT: rax contains self
;  STACK: other: Float
;  OUTPUT: rax contains a float object
;
Float.sub:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Float
    mov     rax, Float_protObj
    call    Object.copy
    call    Float_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- t1 + t2
    movss   xmm0, dword [rbp - loc_1]
    movss   xmm1, dword [rbp - loc_2]
    subss   xmm0, xmm1
    movss   dword [rbp - loc_3], xmm0

    ; self.val <- t3
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.neg
;
;  Negates a float.
;
;  INPUT: rax contains self
;  STACK: empty
;  OUTPUT: rax contains a float object
;
Float.neg:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Float
    mov     rax, Float_protObj
    call    Object.copy
    call    Float_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- -t1
    movss   xmm0, dword [rbp - loc_1]
    pxor    xmm1, xmm1
    subss   xmm1, xmm0
    movss   dword [rbp - loc_2], xmm1

    ; self.val <- t2
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_2]
    mov     [rax], rdi

    ; return self
    mov     rax, rbx

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; Float.equals
;
;  Compares two floats for equality.
;
;  INPUT: rax contains self
;  STACK: other: Float
;  OUTPUT: rax contains a boolean object
;
Float.equals:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 24                    ; allocate 3 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Bool
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init
    mov     qword [rbp - loc_0], rax

    ; t1 <- self.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- t1 == t2
    movss   xmm0, dword [rbp - loc_1]
    movss   xmm1, dword [rbp - loc_2]
    ucomiss xmm0, xmm1
    sete    al
    movzx   rax, al
    mov     qword [rbp - loc_3], rax

    ; t0.val <- t3
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; return t0
    mov     rax, qword [rbp - loc_0]

    pop     rbx                        ; restore register
    add     rsp, 24                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; String.concat
;
;   Returns a the concatenation of self and arg1
;
;   INPUT: rax contains self
;   STACK:
;        s string object
;   OUTPUT: rax the string object which is the concatenation of self and arg1
;
String.concat:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t2 <- self.l.val
    mov     rax, rbx
    add     rax, [slot_0]
    mov     rax, [rax]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; t3 <- arg1.l.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_3], rax

    ; t4 <- t2 + t3
    mov     rax, qword [rbp - loc_2]
    add     rax, qword [rbp - loc_3]
    mov     qword [rbp - loc_4], rax

    ; t1 <- allocate_string(t4)
    mov     rdi, qword [rbp - loc_4]
    call    allocate_string
    mov     qword [rbp - loc_1], rax

    ; rdi = t1.s, rsi = self.s, rdx = t2
    mov     rdi, qword [rbp - loc_1]
    add     rdi, [slot_1]
    mov     rsi, rbx
    add     rsi, [slot_1]
    mov     rdx, qword [rbp - loc_2]
    call    memcpy

    ; rdi = t1.s + t2, rsi = arg1.s, rdx = t3
    mov     rdi, qword [rbp - loc_1]
    add     rdi, [slot_1]
    add     rdi, qword [rbp - loc_2]
    mov     rsi, [rbp + arg_0]
    add     rsi, [slot_1]
    mov     rdx, qword [rbp - loc_3]
    call    memcpy

    ; t0.val <- t4
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_4]
    mov     [rax], rdi

    ; t1.l <- t0
    mov     rax, qword [rbp - loc_1]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return t1
    mov     rax, qword [rbp - loc_1]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; String.substr(i,l)
;		Returns the sub string of self from i with length l
;		Offset starts at 0.
;
;	INPUT: rax contains self
;	STACK:
;		i int object
;		l int object
;	OUTPUT:	rax contains the string object which is the sub string of self
;
String.substr:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 40                    ; allocate 5 local variables
    push    rbx                        ; save register
    mov     rbx, rax                   ; save self

    ; t0 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init
    mov     qword [rbp - loc_0], rax

    ; t3 <- arg1.val
    mov     rax, [rbp + arg_1]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_3], rax

    ; t1 <- allocate_string(t3)
    mov     rdi, qword [rbp - loc_3]
    call    allocate_string
    mov     qword [rbp - loc_1], rax

    ; t2 <- arg0.val
    mov     rax, [rbp + arg_0]
    add     rax, [slot_0]
    mov     rax, [rax]
    mov     qword [rbp - loc_2], rax

    ; rdi = t1.s, rsi = self.s + t2, rdx = t3
    mov     rdi, qword [rbp - loc_1]
    add     rdi, [slot_1]
    mov     rsi, rbx
    add     rsi, [slot_1]
    add     rsi, qword [rbp - loc_2]
    mov     rdx, qword [rbp - loc_3]
    call    memcpy

    ; t0.val <- t3
    mov     rax, qword [rbp - loc_0]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_3]
    mov     [rax], rdi

    ; t1.l <- t0
    mov     rax, qword [rbp - loc_1]
    add     rax, [slot_0]
    mov     rdi, qword [rbp - loc_0]
    mov     [rax], rdi

    ; return t1
    mov     rax, qword [rbp - loc_1]

    pop     rbx                        ; restore register
    add     rsp, 40                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; allocate_string
;
;   INPUT: rdi contains the size in bytes
;   STACK: empty
;   OUTPUT: rax points to the newly allocated string object
;
allocate_string:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 32                    ; allocate 4 local variables

    ; t1 <- (rdi + 7) >> 3
    mov     rax, rdi
    add     rax, 7
    shr     rax, 3
    mov     qword [rbp - loc_1], rax

    ; t0 <- new String
    mov     rax, String_protObj
    call    Object.copy
    call    String_init
    mov     qword [rbp - loc_0], rax

    ; t2 <- size(t0) + t1
    mov     rax, qword [rbp - loc_0]
    add     rax, [obj_size]
    mov     rax, [rax]
    add     rax, qword [rbp - loc_1]
    mov     qword [rbp - loc_2], rax

    ; size(t0) <- t2
    mov     rax, qword [rbp - loc_0]
    add     rax, [obj_size]
    mov     rdi, qword [rbp - loc_2]
    mov     [rax], rdi

    ; t3 <- t0.copy()
    mov     rax, qword [rbp - loc_0]
    call    Object.copy
    call    String_init
    mov     qword [rbp - loc_3], rax

    ; should we free t0?

    ; return t3
    mov     rax, qword [rbp - loc_3]

    add     rsp, 32                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret

;
;
; memcpy
;   INPUT:
;       rdi points to destination
;       rsi points to source
;       rdx contains the number of bytes to copy
;   STACK: empty
;   OUTPUT: nothing
;
memcpy:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame

.next_byte:
    cmp     rdx, 0                     ; check if done
    jle     .done

    mov     al, byte [rsi]             ; get byte from self
    mov     byte [rdi], al             ; copy byte to new object

    inc     rdi                        ; increment destination
    inc     rsi                        ; increment source
    dec     rdx                        ; decrement count

    jmp .next_byte
.done:

    pop     rbp                        ; restore return address
    ret
section '.data' writeable

; memory layout
heap_pos dq 0
heap_end dq 0

section '.text' executable

;
;
; allocator_init
;
;   INPUT: nothing
;   STACK: empty
;   OUTPUT: nothing
allocator_init:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame

    mov     rax, 12                    ; brk
    mov     rdi, 0                     ; increment = 0
    syscall
    mov     [heap_pos], rax            ; save the current position of the heap
    mov     [heap_end], rax            ; save the end of the heap

    pop     rbp                        ; restore return address
    ret

;
;
; allocate
;
;   INPUT: rdi contains the size in bytes
;   STACK: empty
;   OUTPUT: rax points to the newly allocated memory
;
allocate:
    push    rbp                        ; save return address
    mov     rbp, rsp                   ; set up stack frame
    sub     rsp, 16                    ; allocate 2 local variables

    ; t0 <- heap_pos
    mov     rax, qword [heap_pos]
    mov     qword [rbp - loc_0], rax

    ; t1 <- t0 + rdi
    mov     rax, qword [rbp - loc_0]
    add     rax, rdi
    mov     qword [rbp - loc_1], rax

    ; cmp t1 <= heap_end
    mov     rax, qword [rbp - loc_1]
    cmp     rax, qword [heap_end]
    jle     .alloc_ok

    mov     rax, 12                    ; brk
    mov     rdi, 0x10000               ; 64K bytes (larger obj. will fail)
    add     rdi, [heap_end]            ; new end of the heap
    syscall

    mov     [heap_end], rax            ; save the new end of the heap

.alloc_ok:

    ; heap_pos <- t1
    mov     rax, qword [rbp - loc_1]
    mov     qword [heap_pos], rax

    ; return t0
    mov     rax, qword [rbp - loc_0]

    add     rsp, 16                    ; deallocate local variables
    pop     rbp                        ; restore return address
    ret
section '.data'
class_nameTab:
    dq str_const1                       ; pointer to class name Object
    dq str_const3                       ; pointer to class name Main
    dq str_const5                       ; pointer to class name Float
    dq str_const7                       ; pointer to class name Int
    dq str_const9                       ; pointer to class name DoubleWord
    dq str_const10                      ; pointer to class name Word
    dq str_const11                      ; pointer to class name Byte
    dq str_const12                      ; pointer to class name Bool
    dq str_const13                      ; pointer to class name String
    dq str_const14                      ; pointer to class name Tuple
    dq str_const16                      ; pointer to class name IO
    dq str_const17                      ; pointer to class name InAddr
    dq str_const19                      ; pointer to class name SockAddr
    dq str_const20                      ; pointer to class name SockAddrIn
    dq str_const21                      ; pointer to class name SocketType
    dq str_const23                      ; pointer to class name SocketDomain
    dq str_const24                      ; pointer to class name InetHelper
    dq str_const26                      ; pointer to class name HostToNetwork
    dq str_const27                      ; pointer to class name Ref
    dq str_const28                      ; pointer to class name Linux
section '.data'
Object_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
Main_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq Main.main
Float_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Float.equals
    dq Object.abort
    dq Object.to_string
    dq Float.from_fraction
    dq Float.from_int
    dq Float.to_int
    dq Float.mul
    dq Float.div
    dq Float.add
    dq Float.sub
    dq Float.neg
Int_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Int.equals
    dq Object.abort
    dq Int.to_string
    dq Int.abs
    dq Int.mod
    dq Int.from_string
DoubleWord_dispTab:
    dq Object.type_name
    dq Object.copy
    dq DoubleWord.equals
    dq Object.abort
    dq Object.to_string
    dq DoubleWord.from_int
    dq DoubleWord.to_int
Word_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Word.equals
    dq Object.abort
    dq Object.to_string
    dq Word.from_int
    dq Word.to_int
Byte_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Byte.equals
    dq Object.abort
    dq Byte.to_string
    dq Byte.from_string
    dq Byte.from_int
    dq Byte.to_int
    dq Byte.isspace
    dq Byte.islower
    dq Byte.isupper
    dq Byte.isdigit
    dq Byte.isalnum
    dq Byte.iscool
Bool_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Bool.equals
    dq Object.abort
    dq Bool.to_string
    dq Bool.and
    dq Bool.or
    dq Bool.xor
    dq Bool.from_int
    dq Bool.to_int
    dq Bool.from_string
String_dispTab:
    dq Object.type_name
    dq Object.copy
    dq String.equals
    dq Object.abort
    dq Object.to_string
    dq String.concat
    dq String.substr
    dq String.length
    dq String.at
    dq String.split
    dq String.trim_right
    dq String.repeat
Tuple_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Tuple.equals
    dq Object.abort
    dq Object.to_string
    dq Tuple.init
    dq Tuple.fst
    dq Tuple.snd
IO_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq IO.out_string
    dq IO.out_int
    dq IO.in_string
    dq IO.in_int
InAddr_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq InAddr.inaddr_any
SockAddr_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq SockAddr.init_
    dq SockAddr.len
SockAddrIn_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq SockAddr.init_
    dq SockAddr.len
    dq SockAddrIn.init
SocketType_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq SocketType.sock_stream
SocketDomain_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq SocketDomain.af_inet
InetHelper_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq InetHelper.af_inet_pton
HostToNetwork_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq HostToNetwork.htons
    dq HostToNetwork.htonl
Ref_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq Ref.init_
    dq Ref.null
    dq Ref.addr
    dq Ref.deref_
    dq Ref.init
    dq Ref.deref
Linux_dispTab:
    dq Object.type_name
    dq Object.copy
    dq Object.equals
    dq Object.abort
    dq Object.to_string
    dq Linux.read
    dq Linux.write
    dq Linux.close
    dq Linux.socket
    dq Linux.connect
    dq Linux.accept
    dq Linux.bind
    dq Linux.listen
    dq Linux.exit
    dq Linux.read1
section '.data'
Object_protObj:
    dq 0                                ; object tag
    dq 3                                ; object size
    dq Object_dispTab
section '.data'
Main_protObj:
    dq 1                                ; object tag
    dq 3                                ; object size
    dq Main_dispTab
section '.data'
Float_protObj:
    dq 2                                ; object tag
    dq 4                                ; object size
    dq Float_dispTab
    dq 0                                ; attribute val
section '.data'
Int_protObj:
    dq 3                                ; object tag
    dq 4                                ; object size
    dq Int_dispTab
    dq 0                                ; attribute val
section '.data'
DoubleWord_protObj:
    dq 4                                ; object tag
    dq 4                                ; object size
    dq DoubleWord_dispTab
    dq 0                                ; attribute val
section '.data'
Word_protObj:
    dq 5                                ; object tag
    dq 4                                ; object size
    dq Word_dispTab
    dq 0                                ; attribute val
section '.data'
Byte_protObj:
    dq 6                                ; object tag
    dq 4                                ; object size
    dq Byte_dispTab
    dq 0                                ; attribute val
section '.data'
Bool_protObj:
    dq 7                                ; object tag
    dq 4                                ; object size
    dq Bool_dispTab
    dq 0                                ; attribute val
section '.data'
String_protObj:
    dq 8                                ; object tag
    dq 5                                ; object size
    dq String_dispTab
    dq 0                                ; attribute l
    dq ""                               ; attribute str
section '.data'
Tuple_protObj:
    dq 9                                ; object tag
    dq 5                                ; object size
    dq Tuple_dispTab
    dq 0                                ; attribute fst
    dq 0                                ; attribute snd
section '.data'
IO_protObj:
    dq 10                               ; object tag
    dq 4                                ; object size
    dq IO_dispTab
    dq 0                                ; attribute linux
section '.data'
InAddr_protObj:
    dq 11                               ; object tag
    dq 3                                ; object size
    dq InAddr_dispTab
section '.data'
SockAddr_protObj:
    dq 12                               ; object tag
    dq 5                                ; object size
    dq SockAddr_dispTab
    dq 0                                ; attribute q1
    dq 0                                ; attribute q2
section '.data'
SockAddrIn_protObj:
    dq 13                               ; object tag
    dq 5                                ; object size
    dq SockAddrIn_dispTab
    dq 0                                ; attribute q1
    dq 0                                ; attribute q2
section '.data'
SocketType_protObj:
    dq 14                               ; object tag
    dq 3                                ; object size
    dq SocketType_dispTab
section '.data'
SocketDomain_protObj:
    dq 15                               ; object tag
    dq 3                                ; object size
    dq SocketDomain_dispTab
section '.data'
InetHelper_protObj:
    dq 16                               ; object tag
    dq 3                                ; object size
    dq InetHelper_dispTab
section '.data'
HostToNetwork_protObj:
    dq 17                               ; object tag
    dq 3                                ; object size
    dq HostToNetwork_dispTab
section '.data'
Ref_protObj:
    dq 18                               ; object tag
    dq 4                                ; object size
    dq Ref_dispTab
    dq 0                                ; attribute addr
section '.data'
Linux_protObj:
    dq 19                               ; object tag
    dq 3                                ; object size
    dq Linux_dispTab
section '.text' executable
Object_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Main_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Float_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Int_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
DoubleWord_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Word_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Byte_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Bool_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
String_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- default Int
    mov     rax, int_const29            ; default Int
    mov     qword [rbp-8], rax          ; store $t0
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 24
    pop     rbp
    mov     qword [rbx+24], rax         ; store l
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Tuple_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- default Object
    mov     rax, 0
    mov     qword [rbp-8], rax          ; store $t0
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 24
    pop     rbp
    mov     qword [rbx+24], rax         ; store fst
    mov     rax, rbx
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- default Object
    mov     rax, 0
    mov     qword [rbp-8], rax          ; store $t0
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 24
    pop     rbp
    mov     qword [rbx+32], rax         ; store snd
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
IO_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- new Linux
    mov     rax, Linux_protObj
    call    Object.copy
    call    Linux_init                  ; new Linux
    mov     qword [rbp-8], rax          ; store $t0
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 24
    pop     rbp
    mov     qword [rbx+24], rax         ; store linux
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
InAddr_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
SockAddr_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
SockAddrIn_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    SockAddr_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
SocketType_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
SocketDomain_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
InetHelper_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
HostToNetwork_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Ref_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
Linux_init:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rax
    call    Object_init
    mov     rax, rbx                    ; restore self
    pop     rbx
    pop     rbp
    ret
section '.text' executable
Object.abort:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 88                     ; allocate 11 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- string 10
    mov     rax, str_const31
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (SELF_TYPE)self.type_name()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+0]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 0                      ; free 0 args
    ; $t2 <- string 65,98,111,114,116,32,99,97,108,108,101,100,32,102,114,111,109,32,99,108,97,115,115,32
    mov     rax, str_const33
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- new IO
    mov     rax, IO_protObj
    call    Object.copy
    call    IO_init                     ; new IO
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- (IO)$t3.out_string($t2)
    push    0
    mov     rax, qword [rbp-24]         ; load $t2
    push    rax                         ; arg0: $t2
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t5 <- (IO)$t4.out_string($t1)
    push    0
    mov     rax, qword [rbp-16]         ; load $t1
    push    rax                         ; arg0: $t1
    mov     rax, qword [rbp-40]         ; load $t4
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t6 <- (IO)$t5.out_string($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-48]         ; load $t5
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-56], rax         ; store $t6
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t7 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- new Linux
    mov     rax, Linux_protObj
    call    Object.copy
    call    Linux_init                  ; new Linux
    mov     qword [rbp-72], rax         ; store $t8
    ; $t9 <- (Linux)$t8.exit($t7)
    push    0
    mov     rax, qword [rbp-64]         ; load $t7
    push    rax                         ; arg0: $t7
    mov     rax, qword [rbp-72]         ; load $t8
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+104]
    call    rdi
    mov     qword [rbp-80], rax         ; store $t9
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t9
    mov     rax, qword [rbp-80]         ; load $t9
    pop     rbx
    add     rsp, 88
    pop     rbp
    ret
Object.to_string:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40                     ; allocate 5 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- string 32,111,98,106,101,99,116
    mov     rax, str_const35
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (SELF_TYPE)self.type_name()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+0]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 0                      ; free 0 args
    ; $t2 <- (String)$t1.concat($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-16]         ; load $t1
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t2
    mov     rax, qword [rbp-24]         ; load $t2
    pop     rbx
    add     rsp, 40
    pop     rbp
    ret
Main.main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40                     ; allocate 5 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- string 72,101,108,108,111,44,32,87,111,114,108,100,33,10
    mov     rax, str_const37
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- new IO
    mov     rax, IO_protObj
    call    Object.copy
    call    IO_init                     ; new IO
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- (IO)$t1.out_string($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-16]         ; load $t1
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t2
    mov     rax, qword [rbp-24]         ; load $t2
    pop     rbx
    add     rsp, 40
    pop     rbp
    ret
Int.equals:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 104                    ; allocate 13 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Int
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 3
    setge   al
    movzx   rsi, al
    cmp     rdi, 3
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Int
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; $t0 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t3 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-32], rax         ; store $t3
    ; $t5 <- x instanceof Int
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-48], rax         ; store $t5
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(x)
    mov     rdi, rax
    cmp     rdi, 3
    setge   al
    movzx   rsi, al
    cmp     rdi, 3
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-48]         ; load $t5
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t5.val
    ; bt $t5 L3
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    test    rax, rax
    jnz     .L3
.L3:
    ; $t6 <- x as Int
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-56], rax         ; store $t6
    ; $t4 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-40], rax         ; store $t4
    jmp     .L2
.L2:
    ; $t7 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- $t7 <= $t3
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-72], rax         ; store $t8
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    mov     rdi, rax
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t7.val < $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp-72]         ; load $t8
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t8.val
    ; $t9 <- $t3 <= $t7
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-80], rax         ; store $t9
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t3.val < $t7.val
    mov     rdi, rax
    mov     rax, qword [rbp-80]         ; load $t9
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t9.val
    ; $t10 <- (Bool)$t9.and($t8)
    push    0
    mov     rax, qword [rbp-72]         ; load $t8
    push    rax                         ; arg0: $t8
    mov     rax, qword [rbp-80]         ; load $t9
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-88], rax         ; store $t10
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t10
    mov     rax, qword [rbp-88]         ; load $t10
    pop     rbx
    add     rsp, 104
    pop     rbp
    ret
Int.to_string:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 296                    ; allocate 37 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Int
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 3
    setge   al
    movzx   rsi, al
    cmp     rdi, 3
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Int
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; $t0 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t3 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- string 
    mov     rax, str_const38
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- (Int)$t3.abs()
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-56], rax         ; store $t6
    add     rsp, 0                      ; free 0 args
    ; $t7 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- string 48
    mov     rax, str_const39
    mov     qword [rbp-72], rax         ; store $t8
    ; $t9 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-80], rax         ; store $t9
    ; $t10 <- (Byte)$t9.from_string($t8)
    push    0
    mov     rax, qword [rbp-72]         ; load $t8
    push    rax                         ; arg0: $t8
    mov     rax, qword [rbp-80]         ; load $t9
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-88], rax         ; store $t10
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t11 <- (Byte)$t10.to_int()
    mov     rax, qword [rbp-88]         ; load $t10
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-96], rax         ; store $t11
    add     rsp, 0                      ; free 0 args
    ; $t12 <- $t11
    mov     rax, qword [rbp-96]         ; load $t11
    mov     qword [rbp-104], rax        ; store $t12
.L2:
    ; $t14 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-120], rax        ; store $t14
    ; $t15 <- $t7 = $t14
    push    0
    mov     rax, qword [rbp-120]        ; load $t14
    push    rax                         ; arg0: $t14
    mov     rax, qword [rbp-64]         ; load $t7
    call    Int.equals
    mov     qword [rbp-128], rax        ; store $t15
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t16 <- not $t15
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-136], rax        ; store $t16
    mov     rax, qword [rbp-128]        ; load $t15
    add     rax, 24
    mov     rax, qword [rax]            ; get $t15.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-136]        ; load $t16
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t16.val
    ; $t17 <- not $t16
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-144], rax        ; store $t17
    mov     rax, qword [rbp-136]        ; load $t16
    add     rax, 24
    mov     rax, qword [rax]            ; get $t16.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-144]        ; load $t17
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t17.val
    ; bt $t17 L3
    mov     rax, qword [rbp-144]        ; load $t17
    add     rax, 24
    mov     rax, qword [rax]            ; get $t17.val
    test    rax, rax
    jnz     .L3
    ; $t18 <- int 10
    mov     rax, int_const8             ; load 10
    mov     qword [rbp-152], rax        ; store $t18
    ; $t19 <- (Int)$t7.mod($t18)
    push    0
    mov     rax, qword [rbp-152]        ; load $t18
    push    rax                         ; arg0: $t18
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-160], rax        ; store $t19
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t20 <- $t19 + $t12
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-168], rax        ; store $t20
    mov     rax, qword [rbp-160]        ; load $t19
    add     rax, 24
    mov     rax, qword [rax]            ; get $t19.val
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    add     rax, 24
    mov     rax, qword [rax]            ; get $t12.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-168]        ; load $t20
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t20.val
    ; $t21 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-176], rax        ; store $t21
    ; $t22 <- (Byte)$t21.from_int($t20)
    push    0
    mov     rax, qword [rbp-168]        ; load $t20
    push    rax                         ; arg0: $t20
    mov     rax, qword [rbp-176]        ; load $t21
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-184], rax        ; store $t22
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t23 <- (Byte)$t22.to_string()
    mov     rax, qword [rbp-184]        ; load $t22
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-192], rax        ; store $t23
    add     rsp, 0                      ; free 0 args
    ; $t24 <- (String)$t23.concat($t5)
    push    0
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg0: $t5
    mov     rax, qword [rbp-192]        ; load $t23
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-200], rax        ; store $t24
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t5 <- $t24
    mov     rax, qword [rbp-200]        ; load $t24
    mov     qword [rbp-48], rax         ; store $t5
    ; $t25 <- int 10
    mov     rax, int_const8             ; load 10
    mov     qword [rbp-208], rax        ; store $t25
    ; $t26 <- $t7 / $t25
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-216], rax        ; store $t26
    mov     rax, qword [rbp-208]        ; load $t25
    add     rax, 24
    mov     rax, qword [rax]            ; get $t25.val
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-216]        ; load $t26
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t26.val
    ; $t7 <- $t26
    mov     rax, qword [rbp-216]        ; load $t26
    mov     qword [rbp-64], rax         ; store $t7
    ; $t13 <- $t7
    mov     rax, qword [rbp-64]         ; load $t7
    mov     qword [rbp-112], rax        ; store $t13
    jmp     .L2
.L3:
    ; $t28 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-232], rax        ; store $t28
    ; $t29 <- $t3 = $t28
    push    0
    mov     rax, qword [rbp-232]        ; load $t28
    push    rax                         ; arg0: $t28
    mov     rax, qword [rbp-32]         ; load $t3
    call    Int.equals
    mov     qword [rbp-240], rax        ; store $t29
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; bt $t29 L4
    mov     rax, qword [rbp-240]        ; load $t29
    add     rax, 24
    mov     rax, qword [rax]            ; get $t29.val
    test    rax, rax
    jnz     .L4
    ; $t31 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-256], rax        ; store $t31
    ; $t32 <- $t3 < $t31
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-264], rax        ; store $t32
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp-256]        ; load $t31
    add     rax, 24
    mov     rax, qword [rax]            ; get $t31.val
    cmp     rdi, rax
    setl    al
    and     al, 1
    movzx   rax, al                     ; $t3.val < $t31.val
    mov     rdi, rax
    mov     rax, qword [rbp-264]        ; load $t32
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t32.val
    ; bt $t32 L6
    mov     rax, qword [rbp-264]        ; load $t32
    add     rax, 24
    mov     rax, qword [rax]            ; get $t32.val
    test    rax, rax
    jnz     .L6
    ; $t30 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-248], rax        ; store $t30
    jmp     .L7
.L6:
    ; $t33 <- string 126
    mov     rax, str_const40
    mov     qword [rbp-272], rax        ; store $t33
    ; $t34 <- (String)$t33.concat($t5)
    push    0
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg0: $t5
    mov     rax, qword [rbp-272]        ; load $t33
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-280], rax        ; store $t34
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t30 <- $t34
    mov     rax, qword [rbp-280]        ; load $t34
    mov     qword [rbp-248], rax        ; store $t30
.L7:
    ; $t27 <- $t30
    mov     rax, qword [rbp-248]        ; load $t30
    mov     qword [rbp-224], rax        ; store $t27
    jmp     .L5
.L4:
    ; $t35 <- string 48
    mov     rax, str_const39
    mov     qword [rbp-288], rax        ; store $t35
    ; $t27 <- $t35
    mov     rax, qword [rbp-288]        ; load $t35
    mov     qword [rbp-224], rax        ; store $t27
.L5:
    ; $t27
    mov     rax, qword [rbp-224]        ; load $t27
    pop     rbx
    add     rsp, 296
    pop     rbp
    ret
Int.abs:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 72                     ; allocate 9 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Int
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 3
    setge   al
    movzx   rsi, al
    cmp     rdi, 3
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Int
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; $t4 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- $t2 < $t4
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-48], rax         ; store $t5
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    mov     rdi, rax
    mov     rax, qword [rbp-40]         ; load $t4
    add     rax, 24
    mov     rax, qword [rax]            ; get $t4.val
    cmp     rdi, rax
    setl    al
    and     al, 1
    movzx   rax, al                     ; $t2.val < $t4.val
    mov     rdi, rax
    mov     rax, qword [rbp-48]         ; load $t5
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t5.val
    ; bt $t5 L2
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    test    rax, rax
    jnz     .L2
    ; $t3 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-32], rax         ; store $t3
    jmp     .L3
.L2:
    ; $t6 <- ~ $t2
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-56], rax         ; store $t6
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    neg     rax
    mov     rdi, rax
    mov     rax, qword [rbp-56]         ; load $t6
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t6.val
    ; $t3 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-32], rax         ; store $t3
.L3:
    ; $t0 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 72
    pop     rbp
    ret
Int.mod:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 104                    ; allocate 13 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Int
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 3
    setge   al
    movzx   rsi, al
    cmp     rdi, 3
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Int
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- $t2 / x
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-32], rax         ; store $t3
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 24
    mov     rax, qword [rax]            ; get x.val
    mov     rdi, rax
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-32]         ; load $t3
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t3.val
    ; $t4 <- $t3 * x
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-40], rax         ; store $t4
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 24
    mov     rax, qword [rax]            ; get x.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-40]         ; load $t4
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t4.val
    ; $t5 <- $t2 - $t4
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-48], rax         ; store $t5
    mov     rax, qword [rbp-40]         ; load $t4
    add     rax, 24
    mov     rax, qword [rax]            ; get $t4.val
    mov     rdi, rax
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    sub     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-48]         ; load $t5
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t5.val
    ; $t6 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-56], rax         ; store $t6
    ; $t8 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-72], rax         ; store $t8
    ; $t9 <- $t2 < $t8
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-80], rax         ; store $t9
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    mov     rdi, rax
    mov     rax, qword [rbp-72]         ; load $t8
    add     rax, 24
    mov     rax, qword [rax]            ; get $t8.val
    cmp     rdi, rax
    setl    al
    and     al, 1
    movzx   rax, al                     ; $t2.val < $t8.val
    mov     rdi, rax
    mov     rax, qword [rbp-80]         ; load $t9
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t9.val
    ; bt $t9 L2
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    test    rax, rax
    jnz     .L2
    ; $t7 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-64], rax         ; store $t7
    jmp     .L3
.L2:
    ; $t10 <- x + $t6
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-88], rax         ; store $t10
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 24
    mov     rax, qword [rax]            ; get x.val
    mov     rdi, rax
    mov     rax, qword [rbp-56]         ; load $t6
    add     rax, 24
    mov     rax, qword [rax]            ; get $t6.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-88]         ; load $t10
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t10.val
    ; $t7 <- $t10
    mov     rax, qword [rbp-88]         ; load $t10
    mov     qword [rbp-64], rax         ; store $t7
.L3:
    ; $t0 <- $t7
    mov     rax, qword [rbp-64]         ; load $t7
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 104
    pop     rbp
    ret
Int.from_string:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 216                    ; allocate 27 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- (String)s.length()
    mov     rax, qword [rbp+16]         ; load s
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-8], rax          ; store $t0
    add     rsp, 0                      ; free 0 args
    ; $t1 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- string 48
    mov     rax, str_const39
    mov     qword [rbp-56], rax         ; store $t6
    ; $t7 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- (Byte)$t7.from_string($t6)
    push    0
    mov     rax, qword [rbp-56]         ; load $t6
    push    rax                         ; arg0: $t6
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-72], rax         ; store $t8
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t9 <- (Byte)$t8.to_int()
    mov     rax, qword [rbp-72]         ; load $t8
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-80], rax         ; store $t9
    add     rsp, 0                      ; free 0 args
    ; $t10 <- $t9
    mov     rax, qword [rbp-80]         ; load $t9
    mov     qword [rbp-88], rax         ; store $t10
.L0:
    ; $t12 <- $t3 < $t1
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-104], rax        ; store $t12
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    cmp     rdi, rax
    setl    al
    and     al, 1
    movzx   rax, al                     ; $t3.val < $t1.val
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t12.val
    ; $t13 <- not $t12
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-112], rax        ; store $t13
    mov     rax, qword [rbp-104]        ; load $t12
    add     rax, 24
    mov     rax, qword [rax]            ; get $t12.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-112]        ; load $t13
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t13.val
    ; bt $t13 L1
    mov     rax, qword [rbp-112]        ; load $t13
    add     rax, 24
    mov     rax, qword [rax]            ; get $t13.val
    test    rax, rax
    jnz     .L1
    ; $t14 <- int 10
    mov     rax, int_const8             ; load 10
    mov     qword [rbp-120], rax        ; store $t14
    ; $t15 <- $t5 * $t14
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-128], rax        ; store $t15
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp-120]        ; load $t14
    add     rax, 24
    mov     rax, qword [rax]            ; get $t14.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-128]        ; load $t15
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t15.val
    ; $t16 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-136], rax        ; store $t16
    ; $t17 <- (String)s.substr($t3,$t16)
    mov     rax, qword [rbp-136]        ; load $t16
    push    rax                         ; arg0: $t16
    mov     rax, qword [rbp-32]         ; load $t3
    push    rax                         ; arg1: $t3
    mov     rax, qword [rbp+16]         ; load s
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-144], rax        ; store $t17
    add     rsp, 16                     ; free 2 args
    ; $t18 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-152], rax        ; store $t18
    ; $t19 <- (Byte)$t18.from_string($t17)
    push    0
    mov     rax, qword [rbp-144]        ; load $t17
    push    rax                         ; arg0: $t17
    mov     rax, qword [rbp-152]        ; load $t18
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-160], rax        ; store $t19
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t20 <- (Byte)$t19.to_int()
    mov     rax, qword [rbp-160]        ; load $t19
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-168], rax        ; store $t20
    add     rsp, 0                      ; free 0 args
    ; $t21 <- $t15 + $t20
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-176], rax        ; store $t21
    mov     rax, qword [rbp-128]        ; load $t15
    add     rax, 24
    mov     rax, qword [rax]            ; get $t15.val
    mov     rdi, rax
    mov     rax, qword [rbp-168]        ; load $t20
    add     rax, 24
    mov     rax, qword [rax]            ; get $t20.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-176]        ; load $t21
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t21.val
    ; $t22 <- $t21 - $t10
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-184], rax        ; store $t22
    mov     rax, qword [rbp-88]         ; load $t10
    add     rax, 24
    mov     rax, qword [rax]            ; get $t10.val
    mov     rdi, rax
    mov     rax, qword [rbp-176]        ; load $t21
    add     rax, 24
    mov     rax, qword [rax]            ; get $t21.val
    sub     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-184]        ; load $t22
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t22.val
    ; $t5 <- $t22
    mov     rax, qword [rbp-184]        ; load $t22
    mov     qword [rbp-48], rax         ; store $t5
    ; $t23 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-192], rax        ; store $t23
    ; $t24 <- $t3 + $t23
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-200], rax        ; store $t24
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp-192]        ; load $t23
    add     rax, 24
    mov     rax, qword [rax]            ; get $t23.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-200]        ; load $t24
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t24.val
    ; $t3 <- $t24
    mov     rax, qword [rbp-200]        ; load $t24
    mov     qword [rbp-32], rax         ; store $t3
    ; $t11 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-96], rax         ; store $t11
    jmp     .L0
.L1:
    ; $t5
    mov     rax, qword [rbp-48]         ; load $t5
    pop     rbx
    add     rsp, 216
    pop     rbp
    ret
DoubleWord.equals:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- x instanceof DoubleWord
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(x)
    mov     rdi, rax
    cmp     rdi, 4
    setge   al
    movzx   rsi, al
    cmp     rdi, 4
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- x as DoubleWord
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- (DoubleWord)$t2.to_int()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 0                      ; free 0 args
    ; $t4 <- (SELF_TYPE)self.to_int()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t5 <- $t3 = $t4
    push    0
    mov     rax, qword [rbp-40]         ; load $t4
    push    rax                         ; arg0: $t4
    mov     rax, qword [rbp-32]         ; load $t3
    call    Int.equals
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t0 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Word.equals:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- x instanceof Word
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(x)
    mov     rdi, rax
    cmp     rdi, 5
    setge   al
    movzx   rsi, al
    cmp     rdi, 5
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- x as Word
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- (Word)$t2.to_int()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 0                      ; free 0 args
    ; $t4 <- (SELF_TYPE)self.to_int()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t5 <- $t3 = $t4
    push    0
    mov     rax, qword [rbp-40]         ; load $t4
    push    rax                         ; arg0: $t4
    mov     rax, qword [rbp-32]         ; load $t3
    call    Int.equals
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t0 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Byte.equals:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- x instanceof Byte
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(x)
    mov     rdi, rax
    cmp     rdi, 6
    setge   al
    movzx   rsi, al
    cmp     rdi, 6
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- x as Byte
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- (Byte)$t2.to_int()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 0                      ; free 0 args
    ; $t4 <- (SELF_TYPE)self.to_int()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t5 <- $t3 = $t4
    push    0
    mov     rax, qword [rbp-40]         ; load $t4
    push    rax                         ; arg0: $t4
    mov     rax, qword [rbp-32]         ; load $t3
    call    Int.equals
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t0 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Byte.isspace:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 104                    ; allocate 13 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- (SELF_TYPE)self.to_string()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-8], rax          ; store $t0
    add     rsp, 0                      ; free 0 args
    ; $t1 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- int 13
    mov     rax, int_const25            ; load 13
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- (Byte)$t3.from_int($t2)
    push    0
    mov     rax, qword [rbp-24]         ; load $t2
    push    rax                         ; arg0: $t2
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t5 <- (SELF_TYPE)self.equals($t4)
    push    0
    mov     rax, qword [rbp-40]         ; load $t4
    push    rax                         ; arg0: $t4
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+16]
    call    rdi
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t6 <- string 10
    mov     rax, str_const31
    mov     qword [rbp-56], rax         ; store $t6
    ; $t7 <- $t1 = $t6
    push    0
    mov     rax, qword [rbp-56]         ; load $t6
    push    rax                         ; arg0: $t6
    mov     rax, qword [rbp-16]         ; load $t1
    call    String.equals
    mov     qword [rbp-64], rax         ; store $t7
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t8 <- string 32
    mov     rax, str_const41
    mov     qword [rbp-72], rax         ; store $t8
    ; $t9 <- $t1 = $t8
    push    0
    mov     rax, qword [rbp-72]         ; load $t8
    push    rax                         ; arg0: $t8
    mov     rax, qword [rbp-16]         ; load $t1
    call    String.equals
    mov     qword [rbp-80], rax         ; store $t9
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t10 <- (Bool)$t9.or($t7)
    push    0
    mov     rax, qword [rbp-64]         ; load $t7
    push    rax                         ; arg0: $t7
    mov     rax, qword [rbp-80]         ; load $t9
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-88], rax         ; store $t10
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t11 <- (Bool)$t10.or($t5)
    push    0
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg0: $t5
    mov     rax, qword [rbp-88]         ; load $t10
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-96], rax         ; store $t11
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t11
    mov     rax, qword [rbp-96]         ; load $t11
    pop     rbx
    add     rsp, 104
    pop     rbp
    ret
Byte.islower:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 136                    ; allocate 17 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- string 97
    mov     rax, str_const42
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- (Byte)$t1.from_string($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-16]         ; load $t1
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t3 <- (Byte)$t2.to_int()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 0                      ; free 0 args
    ; $t4 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- string 122
    mov     rax, str_const43
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-56], rax         ; store $t6
    ; $t7 <- (Byte)$t6.from_string($t5)
    push    0
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg0: $t5
    mov     rax, qword [rbp-56]         ; load $t6
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-64], rax         ; store $t7
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t8 <- (Byte)$t7.to_int()
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-72], rax         ; store $t8
    add     rsp, 0                      ; free 0 args
    ; $t9 <- $t8
    mov     rax, qword [rbp-72]         ; load $t8
    mov     qword [rbp-80], rax         ; store $t9
    ; $t10 <- (SELF_TYPE)self.to_int()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-88], rax         ; store $t10
    add     rsp, 0                      ; free 0 args
    ; $t11 <- $t10
    mov     rax, qword [rbp-88]         ; load $t10
    mov     qword [rbp-96], rax         ; store $t11
    ; $t12 <- $t11 <= $t9
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-104], rax        ; store $t12
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t11.val < $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t12.val
    ; $t13 <- $t4 <= $t11
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-112], rax        ; store $t13
    mov     rax, qword [rbp-40]         ; load $t4
    add     rax, 24
    mov     rax, qword [rax]            ; get $t4.val
    mov     rdi, rax
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t4.val < $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp-112]        ; load $t13
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t13.val
    ; $t14 <- (Bool)$t13.and($t12)
    push    0
    mov     rax, qword [rbp-104]        ; load $t12
    push    rax                         ; arg0: $t12
    mov     rax, qword [rbp-112]        ; load $t13
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-120], rax        ; store $t14
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t14
    mov     rax, qword [rbp-120]        ; load $t14
    pop     rbx
    add     rsp, 136
    pop     rbp
    ret
Byte.isupper:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 136                    ; allocate 17 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- string 65
    mov     rax, str_const44
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- (Byte)$t1.from_string($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-16]         ; load $t1
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t3 <- (Byte)$t2.to_int()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 0                      ; free 0 args
    ; $t4 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- string 90
    mov     rax, str_const45
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-56], rax         ; store $t6
    ; $t7 <- (Byte)$t6.from_string($t5)
    push    0
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg0: $t5
    mov     rax, qword [rbp-56]         ; load $t6
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-64], rax         ; store $t7
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t8 <- (Byte)$t7.to_int()
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-72], rax         ; store $t8
    add     rsp, 0                      ; free 0 args
    ; $t9 <- $t8
    mov     rax, qword [rbp-72]         ; load $t8
    mov     qword [rbp-80], rax         ; store $t9
    ; $t10 <- (SELF_TYPE)self.to_int()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-88], rax         ; store $t10
    add     rsp, 0                      ; free 0 args
    ; $t11 <- $t10
    mov     rax, qword [rbp-88]         ; load $t10
    mov     qword [rbp-96], rax         ; store $t11
    ; $t12 <- $t11 <= $t9
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-104], rax        ; store $t12
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t11.val < $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t12.val
    ; $t13 <- $t4 <= $t11
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-112], rax        ; store $t13
    mov     rax, qword [rbp-40]         ; load $t4
    add     rax, 24
    mov     rax, qword [rax]            ; get $t4.val
    mov     rdi, rax
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t4.val < $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp-112]        ; load $t13
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t13.val
    ; $t14 <- (Bool)$t13.and($t12)
    push    0
    mov     rax, qword [rbp-104]        ; load $t12
    push    rax                         ; arg0: $t12
    mov     rax, qword [rbp-112]        ; load $t13
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-120], rax        ; store $t14
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t14
    mov     rax, qword [rbp-120]        ; load $t14
    pop     rbx
    add     rsp, 136
    pop     rbp
    ret
Byte.isdigit:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 136                    ; allocate 17 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- string 48
    mov     rax, str_const39
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- (Byte)$t1.from_string($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-16]         ; load $t1
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t3 <- (Byte)$t2.to_int()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 0                      ; free 0 args
    ; $t4 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- string 57
    mov     rax, str_const46
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-56], rax         ; store $t6
    ; $t7 <- (Byte)$t6.from_string($t5)
    push    0
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg0: $t5
    mov     rax, qword [rbp-56]         ; load $t6
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-64], rax         ; store $t7
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t8 <- (Byte)$t7.to_int()
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-72], rax         ; store $t8
    add     rsp, 0                      ; free 0 args
    ; $t9 <- $t8
    mov     rax, qword [rbp-72]         ; load $t8
    mov     qword [rbp-80], rax         ; store $t9
    ; $t10 <- (SELF_TYPE)self.to_int()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-88], rax         ; store $t10
    add     rsp, 0                      ; free 0 args
    ; $t11 <- $t10
    mov     rax, qword [rbp-88]         ; load $t10
    mov     qword [rbp-96], rax         ; store $t11
    ; $t12 <- $t11 <= $t9
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-104], rax        ; store $t12
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t11.val < $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t12.val
    ; $t13 <- $t4 <= $t11
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-112], rax        ; store $t13
    mov     rax, qword [rbp-40]         ; load $t4
    add     rax, 24
    mov     rax, qword [rax]            ; get $t4.val
    mov     rdi, rax
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t4.val < $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp-112]        ; load $t13
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t13.val
    ; $t14 <- (Bool)$t13.and($t12)
    push    0
    mov     rax, qword [rbp-104]        ; load $t12
    push    rax                         ; arg0: $t12
    mov     rax, qword [rbp-112]        ; load $t13
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-120], rax        ; store $t14
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t14
    mov     rax, qword [rbp-120]        ; load $t14
    pop     rbx
    add     rsp, 136
    pop     rbp
    ret
Byte.isalnum:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- (SELF_TYPE)self.isdigit()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+88]
    call    rdi
    mov     qword [rbp-8], rax          ; store $t0
    add     rsp, 0                      ; free 0 args
    ; $t1 <- (SELF_TYPE)self.isupper()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+80]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 0                      ; free 0 args
    ; $t2 <- (SELF_TYPE)self.islower()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+72]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 0                      ; free 0 args
    ; $t3 <- (Bool)$t2.or($t1)
    push    0
    mov     rax, qword [rbp-16]         ; load $t1
    push    rax                         ; arg0: $t1
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t4 <- (Bool)$t3.or($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t4
    mov     rax, qword [rbp-40]         ; load $t4
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Byte.iscool:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- string 95
    mov     rax, str_const47
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- (Byte)$t1.from_string($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-16]         ; load $t1
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t3 <- (SELF_TYPE)self.equals($t2)
    push    0
    mov     rax, qword [rbp-24]         ; load $t2
    push    rax                         ; arg0: $t2
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+16]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t4 <- (SELF_TYPE)self.isalnum()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+96]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t5 <- (Bool)$t4.or($t3)
    push    0
    mov     rax, qword [rbp-32]         ; load $t3
    push    rax                         ; arg0: $t3
    mov     rax, qword [rbp-40]         ; load $t4
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t5
    mov     rax, qword [rbp-48]         ; load $t5
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Bool.equals:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- x instanceof Bool
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(x)
    mov     rdi, rax
    cmp     rdi, 7
    setge   al
    movzx   rsi, al
    cmp     rdi, 7
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- x as Bool
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- (Bool)$t2.to_int()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+72]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 0                      ; free 0 args
    ; $t4 <- (SELF_TYPE)self.to_int()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+72]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t5 <- $t3 = $t4
    push    0
    mov     rax, qword [rbp-40]         ; load $t4
    push    rax                         ; arg0: $t4
    mov     rax, qword [rbp-32]         ; load $t3
    call    Int.equals
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t0 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Bool.to_string:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Bool
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 7
    setge   al
    movzx   rsi, al
    cmp     rdi, 7
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Bool
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; bt $t2 L2
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    test    rax, rax
    jnz     .L2
    ; $t4 <- string 102,97,108,115,101
    mov     rax, str_const48
    mov     qword [rbp-40], rax         ; store $t4
    ; $t3 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-32], rax         ; store $t3
    jmp     .L3
.L2:
    ; $t5 <- string 116,114,117,101
    mov     rax, str_const49
    mov     qword [rbp-48], rax         ; store $t5
    ; $t3 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-32], rax         ; store $t3
.L3:
    ; $t0 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Bool.and:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Bool
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 7
    setge   al
    movzx   rsi, al
    cmp     rdi, 7
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Bool
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; bt $t2 L2
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    test    rax, rax
    jnz     .L2
    ; $t4 <- bool false
    mov     rax, bool_const50
    mov     qword [rbp-40], rax         ; store $t4
    ; $t3 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-32], rax         ; store $t3
    jmp     .L3
.L2:
    ; $t3 <- x
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-32], rax         ; store $t3
.L3:
    ; $t0 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Bool.or:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Bool
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 7
    setge   al
    movzx   rsi, al
    cmp     rdi, 7
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Bool
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; bt $t2 L2
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    test    rax, rax
    jnz     .L2
    ; $t3 <- x
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-32], rax         ; store $t3
    jmp     .L3
.L2:
    ; $t4 <- bool true
    mov     rax, bool_const51
    mov     qword [rbp-40], rax         ; store $t4
    ; $t3 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-32], rax         ; store $t3
.L3:
    ; $t0 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Bool.xor:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Bool
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 7
    setge   al
    movzx   rsi, al
    cmp     rdi, 7
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Bool
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; bt $t2 L2
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    test    rax, rax
    jnz     .L2
    ; $t3 <- x
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-32], rax         ; store $t3
    jmp     .L3
.L2:
    ; $t4 <- not x
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-40], rax         ; store $t4
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 24
    mov     rax, qword [rax]            ; get x.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-40]         ; load $t4
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t4.val
    ; $t3 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-32], rax         ; store $t3
.L3:
    ; $t0 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Bool.from_int:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40                     ; allocate 5 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- x = $t0
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp+16]         ; load x
    call    Int.equals
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t2 <- not $t1
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-24], rax         ; store $t2
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-24]         ; load $t2
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t2.val
    ; $t2
    mov     rax, qword [rbp-24]         ; load $t2
    pop     rbx
    add     rsp, 40
    pop     rbp
    ret
Bool.to_int:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof Bool
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 7
    setge   al
    movzx   rsi, al
    cmp     rdi, 7
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as Bool
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; bt $t2 L2
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    test    rax, rax
    jnz     .L2
    ; $t4 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-40], rax         ; store $t4
    ; $t3 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-32], rax         ; store $t3
    jmp     .L3
.L2:
    ; $t5 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-48], rax         ; store $t5
    ; $t3 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-32], rax         ; store $t3
.L3:
    ; $t0 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Bool.from_string:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- string 116,114,117,101
    mov     rax, str_const49
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- s = $t1
    push    0
    mov     rax, qword [rbp-16]         ; load $t1
    push    rax                         ; arg0: $t1
    mov     rax, qword [rbp+16]         ; load s
    call    String.equals
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; bt $t2 L0
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    test    rax, rax
    jnz     .L0
    ; $t3 <- bool false
    mov     rax, bool_const50
    mov     qword [rbp-32], rax         ; store $t3
    ; $t0 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L1
.L0:
    ; $t4 <- bool true
    mov     rax, bool_const51
    mov     qword [rbp-40], rax         ; store $t4
    ; $t0 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-8], rax          ; store $t0
.L1:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
String.equals:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 312                    ; allocate 39 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as String
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; $t0 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t3 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-32], rax         ; store $t3
    ; $t5 <- x instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-48], rax         ; store $t5
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(x)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-48]         ; load $t5
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t5.val
    ; bt $t5 L3
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    test    rax, rax
    jnz     .L3
.L3:
    ; $t6 <- x as String
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-56], rax         ; store $t6
    ; $t4 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-40], rax         ; store $t4
    jmp     .L2
.L2:
    ; $t7 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-72], rax         ; store $t8
    ; $t9 <- $t8
    mov     rax, qword [rbp-72]         ; load $t8
    mov     qword [rbp-80], rax         ; store $t9
    ; $t10 <- (String)$t3.length()
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-88], rax         ; store $t10
    add     rsp, 0                      ; free 0 args
    ; $t11 <- $t10
    mov     rax, qword [rbp-88]         ; load $t10
    mov     qword [rbp-96], rax         ; store $t11
    ; $t12 <- (String)$t7.length()
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-104], rax        ; store $t12
    add     rsp, 0                      ; free 0 args
    ; $t13 <- $t12
    mov     rax, qword [rbp-104]        ; load $t12
    mov     qword [rbp-112], rax        ; store $t13
    ; $t14 <- bool true
    mov     rax, bool_const51
    mov     qword [rbp-120], rax        ; store $t14
    ; $t15 <- $t14
    mov     rax, qword [rbp-120]        ; load $t14
    mov     qword [rbp-128], rax        ; store $t15
.L4:
    ; $t17 <- $t9 < $t13
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-144], rax        ; store $t17
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp-112]        ; load $t13
    add     rax, 24
    mov     rax, qword [rax]            ; get $t13.val
    cmp     rdi, rax
    setl    al
    and     al, 1
    movzx   rax, al                     ; $t9.val < $t13.val
    mov     rdi, rax
    mov     rax, qword [rbp-144]        ; load $t17
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t17.val
    ; $t18 <- $t9 < $t11
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-152], rax        ; store $t18
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    cmp     rdi, rax
    setl    al
    and     al, 1
    movzx   rax, al                     ; $t9.val < $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp-152]        ; load $t18
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t18.val
    ; $t19 <- (Bool)$t18.and($t17)
    push    0
    mov     rax, qword [rbp-144]        ; load $t17
    push    rax                         ; arg0: $t17
    mov     rax, qword [rbp-152]        ; load $t18
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-160], rax        ; store $t19
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t20 <- not $t19
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-168], rax        ; store $t20
    mov     rax, qword [rbp-160]        ; load $t19
    add     rax, 24
    mov     rax, qword [rax]            ; get $t19.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-168]        ; load $t20
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t20.val
    ; bt $t20 L5
    mov     rax, qword [rbp-168]        ; load $t20
    add     rax, 24
    mov     rax, qword [rax]            ; get $t20.val
    test    rax, rax
    jnz     .L5
    ; $t21 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-176], rax        ; store $t21
    ; $t22 <- (String)$t3.substr($t9,$t21)
    mov     rax, qword [rbp-176]        ; load $t21
    push    rax                         ; arg0: $t21
    mov     rax, qword [rbp-80]         ; load $t9
    push    rax                         ; arg1: $t9
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-184], rax        ; store $t22
    add     rsp, 16                     ; free 2 args
    ; $t23 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-192], rax        ; store $t23
    ; $t24 <- (Byte)$t23.from_string($t22)
    push    0
    mov     rax, qword [rbp-184]        ; load $t22
    push    rax                         ; arg0: $t22
    mov     rax, qword [rbp-192]        ; load $t23
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-200], rax        ; store $t24
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t25 <- $t24
    mov     rax, qword [rbp-200]        ; load $t24
    mov     qword [rbp-208], rax        ; store $t25
    ; $t26 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-216], rax        ; store $t26
    ; $t27 <- (String)$t7.substr($t9,$t26)
    mov     rax, qword [rbp-216]        ; load $t26
    push    rax                         ; arg0: $t26
    mov     rax, qword [rbp-80]         ; load $t9
    push    rax                         ; arg1: $t9
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-224], rax        ; store $t27
    add     rsp, 16                     ; free 2 args
    ; $t28 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-232], rax        ; store $t28
    ; $t29 <- (Byte)$t28.from_string($t27)
    push    0
    mov     rax, qword [rbp-224]        ; load $t27
    push    rax                         ; arg0: $t27
    mov     rax, qword [rbp-232]        ; load $t28
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-240], rax        ; store $t29
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t30 <- $t29
    mov     rax, qword [rbp-240]        ; load $t29
    mov     qword [rbp-248], rax        ; store $t30
    ; $t31 <- $t25 = $t30
    push    0
    mov     rax, qword [rbp-248]        ; load $t30
    push    rax                         ; arg0: $t30
    mov     rax, qword [rbp-208]        ; load $t25
    call    Byte.equals
    mov     qword [rbp-256], rax        ; store $t31
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t32 <- (Bool)$t15.and($t31)
    push    0
    mov     rax, qword [rbp-256]        ; load $t31
    push    rax                         ; arg0: $t31
    mov     rax, qword [rbp-128]        ; load $t15
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-264], rax        ; store $t32
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t15 <- $t32
    mov     rax, qword [rbp-264]        ; load $t32
    mov     qword [rbp-128], rax        ; store $t15
    ; $t33 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-272], rax        ; store $t33
    ; $t34 <- $t9 + $t33
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-280], rax        ; store $t34
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp-272]        ; load $t33
    add     rax, 24
    mov     rax, qword [rax]            ; get $t33.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-280]        ; load $t34
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t34.val
    ; $t9 <- $t34
    mov     rax, qword [rbp-280]        ; load $t34
    mov     qword [rbp-80], rax         ; store $t9
    ; $t16 <- $t9
    mov     rax, qword [rbp-80]         ; load $t9
    mov     qword [rbp-136], rax        ; store $t16
    jmp     .L4
.L5:
    ; $t36 <- $t11 = $t13
    push    0
    mov     rax, qword [rbp-112]        ; load $t13
    push    rax                         ; arg0: $t13
    mov     rax, qword [rbp-96]         ; load $t11
    call    Int.equals
    mov     qword [rbp-296], rax        ; store $t36
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; bt $t36 L6
    mov     rax, qword [rbp-296]        ; load $t36
    add     rax, 24
    mov     rax, qword [rax]            ; get $t36.val
    test    rax, rax
    jnz     .L6
    ; $t37 <- bool false
    mov     rax, bool_const50
    mov     qword [rbp-304], rax        ; store $t37
    ; $t35 <- $t37
    mov     rax, qword [rbp-304]        ; load $t37
    mov     qword [rbp-288], rax        ; store $t35
    jmp     .L7
.L6:
    ; $t35 <- $t15
    mov     rax, qword [rbp-128]        ; load $t15
    mov     qword [rbp-288], rax        ; store $t35
.L7:
    ; $t35
    mov     rax, qword [rbp-288]        ; load $t35
    pop     rbx
    add     rsp, 312
    pop     rbp
    ret
String.length:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 8                      ; allocate 1 locals
    push    rbx
    mov     rbx, rax
    ; l
    mov     rax, qword [rbx+24]         ; load l
    pop     rbx
    add     rsp, 8
    pop     rbp
    ret
String.at:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40                     ; allocate 5 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (SELF_TYPE)self.substr(i,$t0)
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp+16]         ; load i
    push    rax                         ; arg1: i
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 16                     ; free 2 args
    ; $t2 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- (Byte)$t2.from_string($t1)
    push    0
    mov     rax, qword [rbp-16]         ; load $t1
    push    rax                         ; arg0: $t1
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t3
    mov     rax, qword [rbp-32]         ; load $t3
    pop     rbx
    add     rsp, 40
    pop     rbp
    ret
String.split:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 312                    ; allocate 39 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as String
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; $t0 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t3 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- (String)$t3.length()
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-56], rax         ; store $t6
    add     rsp, 0                      ; free 0 args
    ; $t7 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- (String)delim.length()
    mov     rax, qword [rbp+16]         ; load delim
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-72], rax         ; store $t8
    add     rsp, 0                      ; free 0 args
    ; $t9 <- $t8
    mov     rax, qword [rbp-72]         ; load $t8
    mov     qword [rbp-80], rax         ; store $t9
    ; $t10 <- bool false
    mov     rax, bool_const50
    mov     qword [rbp-88], rax         ; store $t10
    ; $t11 <- $t10
    mov     rax, qword [rbp-88]         ; load $t10
    mov     qword [rbp-96], rax         ; store $t11
    ; $t12 <- default Tuple
    mov     rax, 0
    mov     qword [rbp-104], rax        ; store $t12
    ; $t13 <- $t12
    mov     rax, qword [rbp-104]        ; load $t12
    mov     qword [rbp-112], rax        ; store $t13
.L2:
    ; $t15 <- not $t11
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-128], rax        ; store $t15
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-128]        ; load $t15
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t15.val
    ; $t16 <- $t5 < $t7
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-136], rax        ; store $t16
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    cmp     rdi, rax
    setl    al
    and     al, 1
    movzx   rax, al                     ; $t5.val < $t7.val
    mov     rdi, rax
    mov     rax, qword [rbp-136]        ; load $t16
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t16.val
    ; $t17 <- (Bool)$t16.and($t15)
    push    0
    mov     rax, qword [rbp-128]        ; load $t15
    push    rax                         ; arg0: $t15
    mov     rax, qword [rbp-136]        ; load $t16
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-144], rax        ; store $t17
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t18 <- not $t17
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-152], rax        ; store $t18
    mov     rax, qword [rbp-144]        ; load $t17
    add     rax, 24
    mov     rax, qword [rax]            ; get $t17.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-152]        ; load $t18
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t18.val
    ; bt $t18 L3
    mov     rax, qword [rbp-152]        ; load $t18
    add     rax, 24
    mov     rax, qword [rax]            ; get $t18.val
    test    rax, rax
    jnz     .L3
    ; $t20 <- (String)$t3.substr($t5,$t9)
    mov     rax, qword [rbp-80]         ; load $t9
    push    rax                         ; arg0: $t9
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg1: $t5
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-168], rax        ; store $t20
    add     rsp, 16                     ; free 2 args
    ; $t21 <- $t20 = delim
    push    0
    mov     rax, qword [rbp+16]         ; load delim
    push    rax                         ; arg0: delim
    mov     rax, qword [rbp-168]        ; load $t20
    call    String.equals
    mov     qword [rbp-176], rax        ; store $t21
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; bt $t21 L4
    mov     rax, qword [rbp-176]        ; load $t21
    add     rax, 24
    mov     rax, qword [rax]            ; get $t21.val
    test    rax, rax
    jnz     .L4
    ; $t22 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-184], rax        ; store $t22
    ; $t23 <- $t5 + $t22
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-192], rax        ; store $t23
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp-184]        ; load $t22
    add     rax, 24
    mov     rax, qword [rax]            ; get $t22.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-192]        ; load $t23
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t23.val
    ; $t5 <- $t23
    mov     rax, qword [rbp-192]        ; load $t23
    mov     qword [rbp-48], rax         ; store $t5
    ; $t19 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-160], rax        ; store $t19
    jmp     .L5
.L4:
    ; $t24 <- bool true
    mov     rax, bool_const51
    mov     qword [rbp-200], rax        ; store $t24
    ; $t11 <- $t24
    mov     rax, qword [rbp-200]        ; load $t24
    mov     qword [rbp-96], rax         ; store $t11
    ; $t19 <- $t11
    mov     rax, qword [rbp-96]         ; load $t11
    mov     qword [rbp-160], rax        ; store $t19
.L5:
    ; $t14 <- $t19
    mov     rax, qword [rbp-160]        ; load $t19
    mov     qword [rbp-120], rax        ; store $t14
    jmp     .L2
.L3:
    ; bt $t11 L6
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    test    rax, rax
    jnz     .L6
    ; $t26 <- string 
    mov     rax, str_const38
    mov     qword [rbp-216], rax        ; store $t26
    ; $t27 <- new Tuple
    mov     rax, Tuple_protObj
    call    Object.copy
    call    Tuple_init                  ; new Tuple
    mov     qword [rbp-224], rax        ; store $t27
    ; $t28 <- (Tuple)$t27.init($t3,$t26)
    mov     rax, qword [rbp-216]        ; load $t26
    push    rax                         ; arg0: $t26
    mov     rax, qword [rbp-32]         ; load $t3
    push    rax                         ; arg1: $t3
    mov     rax, qword [rbp-224]        ; load $t27
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-232], rax        ; store $t28
    add     rsp, 16                     ; free 2 args
    ; $t25 <- $t28
    mov     rax, qword [rbp-232]        ; load $t28
    mov     qword [rbp-208], rax        ; store $t25
    jmp     .L7
.L6:
    ; $t29 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-240], rax        ; store $t29
    ; $t30 <- (String)$t3.substr($t29,$t5)
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg0: $t5
    mov     rax, qword [rbp-240]        ; load $t29
    push    rax                         ; arg1: $t29
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-248], rax        ; store $t30
    add     rsp, 16                     ; free 2 args
    ; $t31 <- $t5 + $t9
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-256], rax        ; store $t31
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-256]        ; load $t31
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t31.val
    ; $t32 <- $t7 - $t5
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-264], rax        ; store $t32
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    sub     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-264]        ; load $t32
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t32.val
    ; $t33 <- $t32 - $t9
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-272], rax        ; store $t33
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp-264]        ; load $t32
    add     rax, 24
    mov     rax, qword [rax]            ; get $t32.val
    sub     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-272]        ; load $t33
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t33.val
    ; $t34 <- (String)$t3.substr($t31,$t33)
    mov     rax, qword [rbp-272]        ; load $t33
    push    rax                         ; arg0: $t33
    mov     rax, qword [rbp-256]        ; load $t31
    push    rax                         ; arg1: $t31
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-280], rax        ; store $t34
    add     rsp, 16                     ; free 2 args
    ; $t35 <- new Tuple
    mov     rax, Tuple_protObj
    call    Object.copy
    call    Tuple_init                  ; new Tuple
    mov     qword [rbp-288], rax        ; store $t35
    ; $t36 <- (Tuple)$t35.init($t30,$t34)
    mov     rax, qword [rbp-280]        ; load $t34
    push    rax                         ; arg0: $t34
    mov     rax, qword [rbp-248]        ; load $t30
    push    rax                         ; arg1: $t30
    mov     rax, qword [rbp-288]        ; load $t35
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-296], rax        ; store $t36
    add     rsp, 16                     ; free 2 args
    ; $t25 <- $t36
    mov     rax, qword [rbp-296]        ; load $t36
    mov     qword [rbp-208], rax        ; store $t25
.L7:
    ; $t13 <- $t25
    mov     rax, qword [rbp-208]        ; load $t25
    mov     qword [rbp-112], rax        ; store $t13
    ; $t13
    mov     rax, qword [rbp-112]        ; load $t13
    pop     rbx
    add     rsp, 312
    pop     rbp
    ret
String.trim_right:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 248                    ; allocate 31 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as String
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; $t0 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t3 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- (String)$t3.length()
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t5 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- $t4 - $t5
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-56], rax         ; store $t6
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp-40]         ; load $t4
    add     rax, 24
    mov     rax, qword [rax]            ; get $t4.val
    sub     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-56]         ; load $t6
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t6.val
    ; $t7 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-72], rax         ; store $t8
    ; $t9 <- (String)$t3.substr($t7,$t8)
    mov     rax, qword [rbp-72]         ; load $t8
    push    rax                         ; arg0: $t8
    mov     rax, qword [rbp-64]         ; load $t7
    push    rax                         ; arg1: $t7
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-80], rax         ; store $t9
    add     rsp, 16                     ; free 2 args
    ; $t10 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-88], rax         ; store $t10
    ; $t11 <- (Byte)$t10.from_string($t9)
    push    0
    mov     rax, qword [rbp-80]         ; load $t9
    push    rax                         ; arg0: $t9
    mov     rax, qword [rbp-88]         ; load $t10
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-96], rax         ; store $t11
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t12 <- $t11
    mov     rax, qword [rbp-96]         ; load $t11
    mov     qword [rbp-104], rax        ; store $t12
.L2:
    ; $t14 <- $t12 = b
    push    0
    mov     rax, qword [rbp+16]         ; load b
    push    rax                         ; arg0: b
    mov     rax, qword [rbp-104]        ; load $t12
    call    Byte.equals
    mov     qword [rbp-120], rax        ; store $t14
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t15 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-128], rax        ; store $t15
    ; $t16 <- $t15 <= $t7
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-136], rax        ; store $t16
    mov     rax, qword [rbp-128]        ; load $t15
    add     rax, 24
    mov     rax, qword [rax]            ; get $t15.val
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t15.val < $t7.val
    mov     rdi, rax
    mov     rax, qword [rbp-136]        ; load $t16
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t16.val
    ; $t17 <- (Bool)$t16.and($t14)
    push    0
    mov     rax, qword [rbp-120]        ; load $t14
    push    rax                         ; arg0: $t14
    mov     rax, qword [rbp-136]        ; load $t16
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-144], rax        ; store $t17
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t18 <- not $t17
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-152], rax        ; store $t18
    mov     rax, qword [rbp-144]        ; load $t17
    add     rax, 24
    mov     rax, qword [rax]            ; get $t17.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-152]        ; load $t18
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t18.val
    ; bt $t18 L3
    mov     rax, qword [rbp-152]        ; load $t18
    add     rax, 24
    mov     rax, qword [rax]            ; get $t18.val
    test    rax, rax
    jnz     .L3
    ; $t19 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-160], rax        ; store $t19
    ; $t20 <- $t7 - $t19
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-168], rax        ; store $t20
    mov     rax, qword [rbp-160]        ; load $t19
    add     rax, 24
    mov     rax, qword [rax]            ; get $t19.val
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    sub     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-168]        ; load $t20
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t20.val
    ; $t7 <- $t20
    mov     rax, qword [rbp-168]        ; load $t20
    mov     qword [rbp-64], rax         ; store $t7
    ; $t21 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-176], rax        ; store $t21
    ; $t22 <- (String)$t3.substr($t7,$t21)
    mov     rax, qword [rbp-176]        ; load $t21
    push    rax                         ; arg0: $t21
    mov     rax, qword [rbp-64]         ; load $t7
    push    rax                         ; arg1: $t7
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-184], rax        ; store $t22
    add     rsp, 16                     ; free 2 args
    ; $t23 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-192], rax        ; store $t23
    ; $t24 <- (Byte)$t23.from_string($t22)
    push    0
    mov     rax, qword [rbp-184]        ; load $t22
    push    rax                         ; arg0: $t22
    mov     rax, qword [rbp-192]        ; load $t23
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-200], rax        ; store $t24
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t12 <- $t24
    mov     rax, qword [rbp-200]        ; load $t24
    mov     qword [rbp-104], rax        ; store $t12
    ; $t13 <- $t12
    mov     rax, qword [rbp-104]        ; load $t12
    mov     qword [rbp-112], rax        ; store $t13
    jmp     .L2
.L3:
    ; $t25 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-208], rax        ; store $t25
    ; $t26 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-216], rax        ; store $t26
    ; $t27 <- $t7 + $t26
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-224], rax        ; store $t27
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    mov     rdi, rax
    mov     rax, qword [rbp-216]        ; load $t26
    add     rax, 24
    mov     rax, qword [rax]            ; get $t26.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-224]        ; load $t27
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t27.val
    ; $t28 <- (String)$t3.substr($t25,$t27)
    mov     rax, qword [rbp-224]        ; load $t27
    push    rax                         ; arg0: $t27
    mov     rax, qword [rbp-208]        ; load $t25
    push    rax                         ; arg1: $t25
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-232], rax        ; store $t28
    add     rsp, 16                     ; free 2 args
    ; $t28
    mov     rax, qword [rbp-232]        ; load $t28
    pop     rbx
    add     rsp, 248
    pop     rbp
    ret
String.repeat:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 120                    ; allocate 15 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- self instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, rbx                    ; load self
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(self)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- self as String
    mov     rax, rbx                    ; load self
    mov     qword [rbp-24], rax         ; store $t2
    ; $t0 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t3 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- string 
    mov     rax, str_const38
    mov     qword [rbp-56], rax         ; store $t6
    ; $t7 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-64], rax         ; store $t7
.L2:
    ; $t9 <- $t5 <= n
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-80], rax         ; store $t9
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp+16]         ; load n
    add     rax, 24
    mov     rax, qword [rax]            ; get n.val
    cmp     rdi, rax
    setle   al
    and     al, 1
    movzx   rax, al                     ; $t5.val < n.val
    mov     rdi, rax
    mov     rax, qword [rbp-80]         ; load $t9
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t9.val
    ; $t10 <- not $t9
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-88], rax         ; store $t10
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-88]         ; load $t10
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t10.val
    ; bt $t10 L3
    mov     rax, qword [rbp-88]         ; load $t10
    add     rax, 24
    mov     rax, qword [rax]            ; get $t10.val
    test    rax, rax
    jnz     .L3
    ; $t11 <- (String)$t7.concat($t3)
    push    0
    mov     rax, qword [rbp-32]         ; load $t3
    push    rax                         ; arg0: $t3
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-96], rax         ; store $t11
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t7 <- $t11
    mov     rax, qword [rbp-96]         ; load $t11
    mov     qword [rbp-64], rax         ; store $t7
    ; $t12 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-104], rax        ; store $t12
    ; $t13 <- $t5 + $t12
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-112], rax        ; store $t13
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    add     rax, 24
    mov     rax, qword [rax]            ; get $t12.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-112]        ; load $t13
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t13.val
    ; $t5 <- $t13
    mov     rax, qword [rbp-112]        ; load $t13
    mov     qword [rbp-48], rax         ; store $t5
    ; $t8 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-72], rax         ; store $t8
    jmp     .L2
.L3:
    ; $t7
    mov     rax, qword [rbp-64]         ; load $t7
    pop     rbx
    add     rsp, 120
    pop     rbp
    ret
Tuple.equals:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 88                     ; allocate 11 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- x instanceof Tuple
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, qword [rbp+16]         ; load x
    add     rax, 0
    mov     rax, qword [rax]            ; get tag(x)
    mov     rdi, rax
    cmp     rdi, 9
    setge   al
    movzx   rsi, al
    cmp     rdi, 9
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L1
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t2 <- x as Tuple
    mov     rax, qword [rbp+16]         ; load x
    mov     qword [rbp-24], rax         ; store $t2
    ; $t0 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L0
.L0:
    ; $t3 <- $t0
    mov     rax, qword [rbp-8]          ; load $t0
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- (Tuple)$t3.snd()
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t5 <- (Object)snd.equals($t4)
    push    0
    mov     rax, qword [rbp-40]         ; load $t4
    push    rax                         ; arg0: $t4
    mov     rax, qword [rbx+32]         ; load snd
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+16]
    call    rdi
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t6 <- (Tuple)$t3.fst()
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-56], rax         ; store $t6
    add     rsp, 0                      ; free 0 args
    ; $t7 <- (Object)fst.equals($t6)
    push    0
    mov     rax, qword [rbp-56]         ; load $t6
    push    rax                         ; arg0: $t6
    mov     rax, qword [rbx+24]         ; load fst
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+16]
    call    rdi
    mov     qword [rbp-64], rax         ; store $t7
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t8 <- (Bool)$t7.and($t5)
    push    0
    mov     rax, qword [rbp-48]         ; load $t5
    push    rax                         ; arg0: $t5
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-72], rax         ; store $t8
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t8
    mov     rax, qword [rbp-72]         ; load $t8
    pop     rbx
    add     rsp, 88
    pop     rbp
    ret
Tuple.init:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 8                      ; allocate 1 locals
    push    rbx
    mov     rbx, rax
    ; fst <- f
    mov     rax, qword [rbp+16]         ; load f
    mov     qword [rbx+24], rax         ; store fst
    ; snd <- s
    mov     rax, qword [rbp+24]         ; load s
    mov     qword [rbx+32], rax         ; store snd
    ; self
    mov     rax, rbx                    ; load self
    pop     rbx
    add     rsp, 8
    pop     rbp
    ret
Tuple.fst:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 8                      ; allocate 1 locals
    push    rbx
    mov     rbx, rax
    ; fst
    mov     rax, qword [rbx+24]         ; load fst
    pop     rbx
    add     rsp, 8
    pop     rbp
    ret
Tuple.snd:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 8                      ; allocate 1 locals
    push    rbx
    mov     rbx, rax
    ; snd
    mov     rax, qword [rbx+32]         ; load snd
    pop     rbx
    add     rsp, 8
    pop     rbp
    ret
IO.out_string:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40                     ; allocate 5 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (String)x.length()
    mov     rax, qword [rbp+16]         ; load x
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 0                      ; free 0 args
    ; $t2 <- (Linux)linux.write($t0,x,$t1)
    push    0
    mov     rax, qword [rbp-16]         ; load $t1
    push    rax                         ; arg0: $t1
    mov     rax, qword [rbp+16]         ; load x
    push    rax                         ; arg1: x
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg2: $t0
    mov     rax, qword [rbx+24]         ; load linux
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 24                     ; free 3 args
    add     rsp, 8
    ; self
    mov     rax, rbx                    ; load self
    pop     rbx
    add     rsp, 40
    pop     rbp
    ret
IO.out_int:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- (Int)x.to_string()
    mov     rax, qword [rbp+16]         ; load x
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-8], rax          ; store $t0
    add     rsp, 0                      ; free 0 args
    ; $t1 <- (SELF_TYPE)self.out_string($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; self
    mov     rax, rbx                    ; load self
    pop     rbx
    add     rsp, 24
    pop     rbp
    ret
IO.in_string:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 152                    ; allocate 19 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- int 1024
    mov     rax, int_const52            ; load 1024
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- (Linux)linux.read1($t0,$t1)
    mov     rax, qword [rbp-16]         ; load $t1
    push    rax                         ; arg0: $t1
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg1: $t0
    mov     rax, qword [rbx+24]         ; load linux
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+112]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 16                     ; free 2 args
    ; $t3 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-40], rax         ; store $t4
.L0:
    ; $t6 <- (String)$t3.length()
    mov     rax, qword [rbp-32]         ; load $t3
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-56], rax         ; store $t6
    add     rsp, 0                      ; free 0 args
    ; $t7 <- int 1024
    mov     rax, int_const52            ; load 1024
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- $t6 = $t7
    push    0
    mov     rax, qword [rbp-64]         ; load $t7
    push    rax                         ; arg0: $t7
    mov     rax, qword [rbp-56]         ; load $t6
    call    Int.equals
    mov     qword [rbp-72], rax         ; store $t8
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t9 <- not $t8
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-80], rax         ; store $t9
    mov     rax, qword [rbp-72]         ; load $t8
    add     rax, 24
    mov     rax, qword [rax]            ; get $t8.val
    xor     rax, 1
    mov     rdi, rax
    mov     rax, qword [rbp-80]         ; load $t9
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t9.val
    ; bt $t9 L1
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    test    rax, rax
    jnz     .L1
    ; $t10 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-88], rax         ; store $t10
    ; $t11 <- int 1024
    mov     rax, int_const52            ; load 1024
    mov     qword [rbp-96], rax         ; store $t11
    ; $t12 <- (Linux)linux.read1($t10,$t11)
    mov     rax, qword [rbp-96]         ; load $t11
    push    rax                         ; arg0: $t11
    mov     rax, qword [rbp-88]         ; load $t10
    push    rax                         ; arg1: $t10
    mov     rax, qword [rbx+24]         ; load linux
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+112]
    call    rdi
    mov     qword [rbp-104], rax        ; store $t12
    add     rsp, 16                     ; free 2 args
    ; $t3 <- $t12
    mov     rax, qword [rbp-104]        ; load $t12
    mov     qword [rbp-32], rax         ; store $t3
    ; $t13 <- (String)$t4.concat($t3)
    push    0
    mov     rax, qword [rbp-32]         ; load $t3
    push    rax                         ; arg0: $t3
    mov     rax, qword [rbp-40]         ; load $t4
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-112], rax        ; store $t13
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t4 <- $t13
    mov     rax, qword [rbp-112]        ; load $t13
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-48], rax         ; store $t5
    jmp     .L0
.L1:
    ; $t14 <- string 10
    mov     rax, str_const31
    mov     qword [rbp-120], rax        ; store $t14
    ; $t15 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-128], rax        ; store $t15
    ; $t16 <- (Byte)$t15.from_string($t14)
    push    0
    mov     rax, qword [rbp-120]        ; load $t14
    push    rax                         ; arg0: $t14
    mov     rax, qword [rbp-128]        ; load $t15
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-136], rax        ; store $t16
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t17 <- (String)$t4.trim_right($t16)
    push    0
    mov     rax, qword [rbp-136]        ; load $t16
    push    rax                         ; arg0: $t16
    mov     rax, qword [rbp-40]         ; load $t4
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+80]
    call    rdi
    mov     qword [rbp-144], rax        ; store $t17
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t17
    mov     rax, qword [rbp-144]        ; load $t17
    pop     rbx
    add     rsp, 152
    pop     rbp
    ret
IO.in_int:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40                     ; allocate 5 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- (SELF_TYPE)self.in_string()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-8], rax          ; store $t0
    add     rsp, 0                      ; free 0 args
    ; $t1 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-16], rax         ; store $t1
    ; $t2 <- (Int)$t1.from_string($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp-16]         ; load $t1
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t2
    mov     rax, qword [rbp-24]         ; load $t2
    pop     rbx
    add     rsp, 40
    pop     rbp
    ret
InAddr.inaddr_any:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-8], rax          ; store $t0
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 24
    pop     rbp
    ret
SockAddr.len:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 16
    mov     rax, int_const53            ; load 16
    mov     qword [rbp-8], rax          ; store $t0
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 24
    pop     rbp
    ret
SockAddrIn.init:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 520                    ; allocate 65 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (Byte)$t0.from_int(sin_family)
    push    0
    mov     rax, qword [rbp+16]         ; load sin_family
    push    rax                         ; arg0: sin_family
    mov     rax, qword [rbp-8]          ; load $t0
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t2 <- $t1
    mov     rax, qword [rbp-16]         ; load $t1
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-32], rax         ; store $t3
    ; $t4 <- sin_family / $t3
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-40], rax         ; store $t4
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp+16]         ; load sin_family
    add     rax, 24
    mov     rax, qword [rax]            ; get sin_family.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-40]         ; load $t4
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t4.val
    ; $t5 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- (Byte)$t5.from_int($t4)
    push    0
    mov     rax, qword [rbp-40]         ; load $t4
    push    rax                         ; arg0: $t4
    mov     rax, qword [rbp-48]         ; load $t5
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-56], rax         ; store $t6
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t7 <- $t6
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-72], rax         ; store $t8
    ; $t9 <- (Byte)$t8.from_int(sin_port)
    push    0
    mov     rax, qword [rbp+24]         ; load sin_port
    push    rax                         ; arg0: sin_port
    mov     rax, qword [rbp-72]         ; load $t8
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-80], rax         ; store $t9
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t10 <- $t9
    mov     rax, qword [rbp-80]         ; load $t9
    mov     qword [rbp-88], rax         ; store $t10
    ; $t11 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-96], rax         ; store $t11
    ; $t12 <- sin_port / $t11
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-104], rax        ; store $t12
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp+24]         ; load sin_port
    add     rax, 24
    mov     rax, qword [rax]            ; get sin_port.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t12.val
    ; $t13 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-112], rax        ; store $t13
    ; $t14 <- (Byte)$t13.from_int($t12)
    push    0
    mov     rax, qword [rbp-104]        ; load $t12
    push    rax                         ; arg0: $t12
    mov     rax, qword [rbp-112]        ; load $t13
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-120], rax        ; store $t14
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t15 <- $t14
    mov     rax, qword [rbp-120]        ; load $t14
    mov     qword [rbp-128], rax        ; store $t15
    ; $t16 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-136], rax        ; store $t16
    ; $t17 <- (Byte)$t16.from_int(sin_addr)
    push    0
    mov     rax, qword [rbp+32]         ; load sin_addr
    push    rax                         ; arg0: sin_addr
    mov     rax, qword [rbp-136]        ; load $t16
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-144], rax        ; store $t17
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t18 <- $t17
    mov     rax, qword [rbp-144]        ; load $t17
    mov     qword [rbp-152], rax        ; store $t18
    ; $t19 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-160], rax        ; store $t19
    ; $t20 <- sin_addr / $t19
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-168], rax        ; store $t20
    mov     rax, qword [rbp-160]        ; load $t19
    add     rax, 24
    mov     rax, qword [rax]            ; get $t19.val
    mov     rdi, rax
    mov     rax, qword [rbp+32]         ; load sin_addr
    add     rax, 24
    mov     rax, qword [rax]            ; get sin_addr.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-168]        ; load $t20
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t20.val
    ; $t21 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-176], rax        ; store $t21
    ; $t22 <- (Byte)$t21.from_int($t20)
    push    0
    mov     rax, qword [rbp-168]        ; load $t20
    push    rax                         ; arg0: $t20
    mov     rax, qword [rbp-176]        ; load $t21
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-184], rax        ; store $t22
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t23 <- $t22
    mov     rax, qword [rbp-184]        ; load $t22
    mov     qword [rbp-192], rax        ; store $t23
    ; $t24 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-200], rax        ; store $t24
    ; $t25 <- sin_addr / $t24
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-208], rax        ; store $t25
    mov     rax, qword [rbp-200]        ; load $t24
    add     rax, 24
    mov     rax, qword [rax]            ; get $t24.val
    mov     rdi, rax
    mov     rax, qword [rbp+32]         ; load sin_addr
    add     rax, 24
    mov     rax, qword [rax]            ; get sin_addr.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-208]        ; load $t25
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t25.val
    ; $t26 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-216], rax        ; store $t26
    ; $t27 <- $t25 / $t26
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-224], rax        ; store $t27
    mov     rax, qword [rbp-216]        ; load $t26
    add     rax, 24
    mov     rax, qword [rax]            ; get $t26.val
    mov     rdi, rax
    mov     rax, qword [rbp-208]        ; load $t25
    add     rax, 24
    mov     rax, qword [rax]            ; get $t25.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-224]        ; load $t27
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t27.val
    ; $t28 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-232], rax        ; store $t28
    ; $t29 <- (Byte)$t28.from_int($t27)
    push    0
    mov     rax, qword [rbp-224]        ; load $t27
    push    rax                         ; arg0: $t27
    mov     rax, qword [rbp-232]        ; load $t28
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-240], rax        ; store $t29
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t30 <- $t29
    mov     rax, qword [rbp-240]        ; load $t29
    mov     qword [rbp-248], rax        ; store $t30
    ; $t31 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-256], rax        ; store $t31
    ; $t32 <- sin_addr / $t31
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-264], rax        ; store $t32
    mov     rax, qword [rbp-256]        ; load $t31
    add     rax, 24
    mov     rax, qword [rax]            ; get $t31.val
    mov     rdi, rax
    mov     rax, qword [rbp+32]         ; load sin_addr
    add     rax, 24
    mov     rax, qword [rax]            ; get sin_addr.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-264]        ; load $t32
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t32.val
    ; $t33 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-272], rax        ; store $t33
    ; $t34 <- $t32 / $t33
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-280], rax        ; store $t34
    mov     rax, qword [rbp-272]        ; load $t33
    add     rax, 24
    mov     rax, qword [rax]            ; get $t33.val
    mov     rdi, rax
    mov     rax, qword [rbp-264]        ; load $t32
    add     rax, 24
    mov     rax, qword [rax]            ; get $t32.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-280]        ; load $t34
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t34.val
    ; $t35 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-288], rax        ; store $t35
    ; $t36 <- $t34 / $t35
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-296], rax        ; store $t36
    mov     rax, qword [rbp-288]        ; load $t35
    add     rax, 24
    mov     rax, qword [rax]            ; get $t35.val
    mov     rdi, rax
    mov     rax, qword [rbp-280]        ; load $t34
    add     rax, 24
    mov     rax, qword [rax]            ; get $t34.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-296]        ; load $t36
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t36.val
    ; $t37 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-304], rax        ; store $t37
    ; $t38 <- (Byte)$t37.from_int($t36)
    push    0
    mov     rax, qword [rbp-296]        ; load $t36
    push    rax                         ; arg0: $t36
    mov     rax, qword [rbp-304]        ; load $t37
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-312], rax        ; store $t38
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t39 <- $t38
    mov     rax, qword [rbp-312]        ; load $t38
    mov     qword [rbp-320], rax        ; store $t39
    ; $t40 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-328], rax        ; store $t40
    ; $t41 <- new Byte
    mov     rax, Byte_protObj
    call    Object.copy
    call    Byte_init                   ; new Byte
    mov     qword [rbp-336], rax        ; store $t41
    ; $t42 <- (Byte)$t41.from_int($t40)
    push    0
    mov     rax, qword [rbp-328]        ; load $t40
    push    rax                         ; arg0: $t40
    mov     rax, qword [rbp-336]        ; load $t41
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-344], rax        ; store $t42
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t43 <- $t42
    mov     rax, qword [rbp-344]        ; load $t42
    mov     qword [rbp-352], rax        ; store $t43
    ; $t44 <- int 8
    mov     rax, int_const18            ; load 8
    mov     qword [rbp-360], rax        ; store $t44
    ; $t45 <- (Byte)$t43.to_string()
    mov     rax, qword [rbp-352]        ; load $t43
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-368], rax        ; store $t45
    add     rsp, 0                      ; free 0 args
    ; $t46 <- (String)$t45.repeat($t44)
    push    0
    mov     rax, qword [rbp-360]        ; load $t44
    push    rax                         ; arg0: $t44
    mov     rax, qword [rbp-368]        ; load $t45
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+88]
    call    rdi
    mov     qword [rbp-376], rax        ; store $t46
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t47 <- (Byte)$t39.to_string()
    mov     rax, qword [rbp-320]        ; load $t39
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-384], rax        ; store $t47
    add     rsp, 0                      ; free 0 args
    ; $t48 <- (Byte)$t30.to_string()
    mov     rax, qword [rbp-248]        ; load $t30
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-392], rax        ; store $t48
    add     rsp, 0                      ; free 0 args
    ; $t49 <- (Byte)$t23.to_string()
    mov     rax, qword [rbp-192]        ; load $t23
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-400], rax        ; store $t49
    add     rsp, 0                      ; free 0 args
    ; $t50 <- (Byte)$t18.to_string()
    mov     rax, qword [rbp-152]        ; load $t18
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-408], rax        ; store $t50
    add     rsp, 0                      ; free 0 args
    ; $t51 <- (Byte)$t15.to_string()
    mov     rax, qword [rbp-128]        ; load $t15
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-416], rax        ; store $t51
    add     rsp, 0                      ; free 0 args
    ; $t52 <- (Byte)$t10.to_string()
    mov     rax, qword [rbp-88]         ; load $t10
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-424], rax        ; store $t52
    add     rsp, 0                      ; free 0 args
    ; $t53 <- (Byte)$t7.to_string()
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-432], rax        ; store $t53
    add     rsp, 0                      ; free 0 args
    ; $t54 <- (Byte)$t2.to_string()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+32]
    call    rdi
    mov     qword [rbp-440], rax        ; store $t54
    add     rsp, 0                      ; free 0 args
    ; $t55 <- (String)$t54.concat($t53)
    push    0
    mov     rax, qword [rbp-432]        ; load $t53
    push    rax                         ; arg0: $t53
    mov     rax, qword [rbp-440]        ; load $t54
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-448], rax        ; store $t55
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t56 <- (String)$t55.concat($t52)
    push    0
    mov     rax, qword [rbp-424]        ; load $t52
    push    rax                         ; arg0: $t52
    mov     rax, qword [rbp-448]        ; load $t55
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-456], rax        ; store $t56
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t57 <- (String)$t56.concat($t51)
    push    0
    mov     rax, qword [rbp-416]        ; load $t51
    push    rax                         ; arg0: $t51
    mov     rax, qword [rbp-456]        ; load $t56
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-464], rax        ; store $t57
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t58 <- (String)$t57.concat($t50)
    push    0
    mov     rax, qword [rbp-408]        ; load $t50
    push    rax                         ; arg0: $t50
    mov     rax, qword [rbp-464]        ; load $t57
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-472], rax        ; store $t58
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t59 <- (String)$t58.concat($t49)
    push    0
    mov     rax, qword [rbp-400]        ; load $t49
    push    rax                         ; arg0: $t49
    mov     rax, qword [rbp-472]        ; load $t58
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-480], rax        ; store $t59
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t60 <- (String)$t59.concat($t48)
    push    0
    mov     rax, qword [rbp-392]        ; load $t48
    push    rax                         ; arg0: $t48
    mov     rax, qword [rbp-480]        ; load $t59
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-488], rax        ; store $t60
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t61 <- (String)$t60.concat($t47)
    push    0
    mov     rax, qword [rbp-384]        ; load $t47
    push    rax                         ; arg0: $t47
    mov     rax, qword [rbp-488]        ; load $t60
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-496], rax        ; store $t61
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t62 <- (String)$t61.concat($t46)
    push    0
    mov     rax, qword [rbp-376]        ; load $t46
    push    rax                         ; arg0: $t46
    mov     rax, qword [rbp-496]        ; load $t61
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-504], rax        ; store $t62
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t63 <- (SELF_TYPE)self.init_($t62)
    push    0
    mov     rax, qword [rbp-504]        ; load $t62
    push    rax                         ; arg0: $t62
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-512], rax        ; store $t63
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t63
    mov     rax, qword [rbp-512]        ; load $t63
    pop     rbx
    add     rsp, 520
    pop     rbp
    ret
SocketType.sock_stream:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 1
    mov     rax, int_const30            ; load 1
    mov     qword [rbp-8], rax          ; store $t0
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 24
    pop     rbp
    ret
SocketDomain.af_inet:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 24                     ; allocate 3 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 2
    mov     rax, int_const15            ; load 2
    mov     qword [rbp-8], rax          ; store $t0
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 24
    pop     rbp
    ret
InetHelper.af_inet_pton:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 488                    ; allocate 61 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- string 46
    mov     rax, str_const55
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (String)src.split($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp+16]         ; load src
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+72]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t2 <- $t1
    mov     rax, qword [rbp-16]         ; load $t1
    mov     qword [rbp-24], rax         ; store $t2
    ; $t4 <- (Tuple)$t2.fst()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t5 <- $t4 instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-48], rax         ; store $t5
    mov     rax, qword [rbp-40]         ; load $t4
    add     rax, 0
    mov     rax, qword [rax]            ; get tag($t4)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-48]         ; load $t5
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t5.val
    ; bt $t5 L1
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t6 <- $t4 as String
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-56], rax         ; store $t6
    ; $t7 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-64], rax         ; store $t7
    ; $t8 <- (Int)$t7.from_string($t6)
    push    0
    mov     rax, qword [rbp-56]         ; load $t6
    push    rax                         ; arg0: $t6
    mov     rax, qword [rbp-64]         ; load $t7
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-72], rax         ; store $t8
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t3 <- $t8
    mov     rax, qword [rbp-72]         ; load $t8
    mov     qword [rbp-32], rax         ; store $t3
    jmp     .L0
.L0:
    ; $t9 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-80], rax         ; store $t9
    ; $t11 <- (Tuple)$t2.snd()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-96], rax         ; store $t11
    add     rsp, 0                      ; free 0 args
    ; $t12 <- $t11 instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-104], rax        ; store $t12
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 0
    mov     rax, qword [rax]            ; get tag($t11)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t12.val
    ; bt $t12 L3
    mov     rax, qword [rbp-104]        ; load $t12
    add     rax, 24
    mov     rax, qword [rax]            ; get $t12.val
    test    rax, rax
    jnz     .L3
.L3:
    ; $t13 <- $t11 as String
    mov     rax, qword [rbp-96]         ; load $t11
    mov     qword [rbp-112], rax        ; store $t13
    ; $t14 <- string 46
    mov     rax, str_const55
    mov     qword [rbp-120], rax        ; store $t14
    ; $t15 <- (String)$t13.split($t14)
    push    0
    mov     rax, qword [rbp-120]        ; load $t14
    push    rax                         ; arg0: $t14
    mov     rax, qword [rbp-112]        ; load $t13
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+72]
    call    rdi
    mov     qword [rbp-128], rax        ; store $t15
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t10 <- $t15
    mov     rax, qword [rbp-128]        ; load $t15
    mov     qword [rbp-88], rax         ; store $t10
    jmp     .L2
.L2:
    ; $t16 <- $t10
    mov     rax, qword [rbp-88]         ; load $t10
    mov     qword [rbp-136], rax        ; store $t16
    ; $t18 <- (Tuple)$t16.fst()
    mov     rax, qword [rbp-136]        ; load $t16
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-152], rax        ; store $t18
    add     rsp, 0                      ; free 0 args
    ; $t19 <- $t18 instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-160], rax        ; store $t19
    mov     rax, qword [rbp-152]        ; load $t18
    add     rax, 0
    mov     rax, qword [rax]            ; get tag($t18)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-160]        ; load $t19
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t19.val
    ; bt $t19 L5
    mov     rax, qword [rbp-160]        ; load $t19
    add     rax, 24
    mov     rax, qword [rax]            ; get $t19.val
    test    rax, rax
    jnz     .L5
.L5:
    ; $t20 <- $t18 as String
    mov     rax, qword [rbp-152]        ; load $t18
    mov     qword [rbp-168], rax        ; store $t20
    ; $t21 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-176], rax        ; store $t21
    ; $t22 <- (Int)$t21.from_string($t20)
    push    0
    mov     rax, qword [rbp-168]        ; load $t20
    push    rax                         ; arg0: $t20
    mov     rax, qword [rbp-176]        ; load $t21
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-184], rax        ; store $t22
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t17 <- $t22
    mov     rax, qword [rbp-184]        ; load $t22
    mov     qword [rbp-144], rax        ; store $t17
    jmp     .L4
.L4:
    ; $t23 <- $t17
    mov     rax, qword [rbp-144]        ; load $t17
    mov     qword [rbp-192], rax        ; store $t23
    ; $t25 <- (Tuple)$t16.snd()
    mov     rax, qword [rbp-136]        ; load $t16
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-208], rax        ; store $t25
    add     rsp, 0                      ; free 0 args
    ; $t26 <- $t25 instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-216], rax        ; store $t26
    mov     rax, qword [rbp-208]        ; load $t25
    add     rax, 0
    mov     rax, qword [rax]            ; get tag($t25)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-216]        ; load $t26
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t26.val
    ; bt $t26 L7
    mov     rax, qword [rbp-216]        ; load $t26
    add     rax, 24
    mov     rax, qword [rax]            ; get $t26.val
    test    rax, rax
    jnz     .L7
.L7:
    ; $t27 <- $t25 as String
    mov     rax, qword [rbp-208]        ; load $t25
    mov     qword [rbp-224], rax        ; store $t27
    ; $t28 <- string 46
    mov     rax, str_const55
    mov     qword [rbp-232], rax        ; store $t28
    ; $t29 <- (String)$t27.split($t28)
    push    0
    mov     rax, qword [rbp-232]        ; load $t28
    push    rax                         ; arg0: $t28
    mov     rax, qword [rbp-224]        ; load $t27
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+72]
    call    rdi
    mov     qword [rbp-240], rax        ; store $t29
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t24 <- $t29
    mov     rax, qword [rbp-240]        ; load $t29
    mov     qword [rbp-200], rax        ; store $t24
    jmp     .L6
.L6:
    ; $t30 <- $t24
    mov     rax, qword [rbp-200]        ; load $t24
    mov     qword [rbp-248], rax        ; store $t30
    ; $t32 <- (Tuple)$t30.fst()
    mov     rax, qword [rbp-248]        ; load $t30
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-264], rax        ; store $t32
    add     rsp, 0                      ; free 0 args
    ; $t33 <- $t32 instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-272], rax        ; store $t33
    mov     rax, qword [rbp-264]        ; load $t32
    add     rax, 0
    mov     rax, qword [rax]            ; get tag($t32)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-272]        ; load $t33
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t33.val
    ; bt $t33 L9
    mov     rax, qword [rbp-272]        ; load $t33
    add     rax, 24
    mov     rax, qword [rax]            ; get $t33.val
    test    rax, rax
    jnz     .L9
.L9:
    ; $t34 <- $t32 as String
    mov     rax, qword [rbp-264]        ; load $t32
    mov     qword [rbp-280], rax        ; store $t34
    ; $t35 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-288], rax        ; store $t35
    ; $t36 <- (Int)$t35.from_string($t34)
    push    0
    mov     rax, qword [rbp-280]        ; load $t34
    push    rax                         ; arg0: $t34
    mov     rax, qword [rbp-288]        ; load $t35
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-296], rax        ; store $t36
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t31 <- $t36
    mov     rax, qword [rbp-296]        ; load $t36
    mov     qword [rbp-256], rax        ; store $t31
    jmp     .L8
.L8:
    ; $t37 <- $t31
    mov     rax, qword [rbp-256]        ; load $t31
    mov     qword [rbp-304], rax        ; store $t37
    ; $t39 <- (Tuple)$t30.snd()
    mov     rax, qword [rbp-248]        ; load $t30
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-320], rax        ; store $t39
    add     rsp, 0                      ; free 0 args
    ; $t40 <- $t39 instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-328], rax        ; store $t40
    mov     rax, qword [rbp-320]        ; load $t39
    add     rax, 0
    mov     rax, qword [rax]            ; get tag($t39)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-328]        ; load $t40
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t40.val
    ; bt $t40 L11
    mov     rax, qword [rbp-328]        ; load $t40
    add     rax, 24
    mov     rax, qword [rax]            ; get $t40.val
    test    rax, rax
    jnz     .L11
.L11:
    ; $t41 <- $t39 as String
    mov     rax, qword [rbp-320]        ; load $t39
    mov     qword [rbp-336], rax        ; store $t41
    ; $t42 <- new Int
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-344], rax        ; store $t42
    ; $t43 <- (Int)$t42.from_string($t41)
    push    0
    mov     rax, qword [rbp-336]        ; load $t41
    push    rax                         ; arg0: $t41
    mov     rax, qword [rbp-344]        ; load $t42
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-352], rax        ; store $t43
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t38 <- $t43
    mov     rax, qword [rbp-352]        ; load $t43
    mov     qword [rbp-312], rax        ; store $t38
    jmp     .L10
.L10:
    ; $t44 <- $t38
    mov     rax, qword [rbp-312]        ; load $t38
    mov     qword [rbp-360], rax        ; store $t44
    ; $t45 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-368], rax        ; store $t45
    ; $t46 <- $t23 * $t45
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-376], rax        ; store $t46
    mov     rax, qword [rbp-192]        ; load $t23
    add     rax, 24
    mov     rax, qword [rax]            ; get $t23.val
    mov     rdi, rax
    mov     rax, qword [rbp-368]        ; load $t45
    add     rax, 24
    mov     rax, qword [rax]            ; get $t45.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-376]        ; load $t46
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t46.val
    ; $t47 <- $t9 + $t46
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-384], rax        ; store $t47
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp-376]        ; load $t46
    add     rax, 24
    mov     rax, qword [rax]            ; get $t46.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-384]        ; load $t47
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t47.val
    ; $t48 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-392], rax        ; store $t48
    ; $t49 <- $t37 * $t48
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-400], rax        ; store $t49
    mov     rax, qword [rbp-304]        ; load $t37
    add     rax, 24
    mov     rax, qword [rax]            ; get $t37.val
    mov     rdi, rax
    mov     rax, qword [rbp-392]        ; load $t48
    add     rax, 24
    mov     rax, qword [rax]            ; get $t48.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-400]        ; load $t49
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t49.val
    ; $t50 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-408], rax        ; store $t50
    ; $t51 <- $t49 * $t50
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-416], rax        ; store $t51
    mov     rax, qword [rbp-400]        ; load $t49
    add     rax, 24
    mov     rax, qword [rax]            ; get $t49.val
    mov     rdi, rax
    mov     rax, qword [rbp-408]        ; load $t50
    add     rax, 24
    mov     rax, qword [rax]            ; get $t50.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-416]        ; load $t51
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t51.val
    ; $t52 <- $t47 + $t51
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-424], rax        ; store $t52
    mov     rax, qword [rbp-384]        ; load $t47
    add     rax, 24
    mov     rax, qword [rax]            ; get $t47.val
    mov     rdi, rax
    mov     rax, qword [rbp-416]        ; load $t51
    add     rax, 24
    mov     rax, qword [rax]            ; get $t51.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-424]        ; load $t52
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t52.val
    ; $t53 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-432], rax        ; store $t53
    ; $t54 <- $t44 * $t53
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-440], rax        ; store $t54
    mov     rax, qword [rbp-360]        ; load $t44
    add     rax, 24
    mov     rax, qword [rax]            ; get $t44.val
    mov     rdi, rax
    mov     rax, qword [rbp-432]        ; load $t53
    add     rax, 24
    mov     rax, qword [rax]            ; get $t53.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-440]        ; load $t54
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t54.val
    ; $t55 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-448], rax        ; store $t55
    ; $t56 <- $t54 * $t55
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-456], rax        ; store $t56
    mov     rax, qword [rbp-440]        ; load $t54
    add     rax, 24
    mov     rax, qword [rax]            ; get $t54.val
    mov     rdi, rax
    mov     rax, qword [rbp-448]        ; load $t55
    add     rax, 24
    mov     rax, qword [rax]            ; get $t55.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-456]        ; load $t56
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t56.val
    ; $t57 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-464], rax        ; store $t57
    ; $t58 <- $t56 * $t57
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-472], rax        ; store $t58
    mov     rax, qword [rbp-456]        ; load $t56
    add     rax, 24
    mov     rax, qword [rax]            ; get $t56.val
    mov     rdi, rax
    mov     rax, qword [rbp-464]        ; load $t57
    add     rax, 24
    mov     rax, qword [rax]            ; get $t57.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-472]        ; load $t58
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t58.val
    ; $t59 <- $t52 + $t58
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-480], rax        ; store $t59
    mov     rax, qword [rbp-424]        ; load $t52
    add     rax, 24
    mov     rax, qword [rax]            ; get $t52.val
    mov     rdi, rax
    mov     rax, qword [rbp-472]        ; load $t58
    add     rax, 24
    mov     rax, qword [rax]            ; get $t58.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-480]        ; load $t59
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t59.val
    ; $t59
    mov     rax, qword [rbp-480]        ; load $t59
    pop     rbx
    add     rsp, 488
    pop     rbp
    ret
HostToNetwork.htons:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 88                     ; allocate 11 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (Int)short.mod($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp+16]         ; load short
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t2 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- $t1 * $t2
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-32], rax         ; store $t3
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    mov     rdi, rax
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-32]         ; load $t3
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t3.val
    ; $t4 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-48], rax         ; store $t5
    ; $t6 <- short / $t5
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-56], rax         ; store $t6
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp+16]         ; load short
    add     rax, 24
    mov     rax, qword [rax]            ; get short.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-56]         ; load $t6
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t6.val
    ; $t7 <- (Int)$t6.mod($t4)
    push    0
    mov     rax, qword [rbp-40]         ; load $t4
    push    rax                         ; arg0: $t4
    mov     rax, qword [rbp-56]         ; load $t6
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-64], rax         ; store $t7
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t8 <- $t3 + $t7
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-72], rax         ; store $t8
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-72]         ; load $t8
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t8.val
    ; $t8
    mov     rax, qword [rbp-72]         ; load $t8
    pop     rbx
    add     rsp, 88
    pop     rbp
    ret
HostToNetwork.htonl:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 296                    ; allocate 37 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (Int)long.mod($t0)
    push    0
    mov     rax, qword [rbp-8]          ; load $t0
    push    rax                         ; arg0: $t0
    mov     rax, qword [rbp+16]         ; load long
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t2 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- $t1 * $t2
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-32], rax         ; store $t3
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    mov     rdi, rax
    mov     rax, qword [rbp-24]         ; load $t2
    add     rax, 24
    mov     rax, qword [rax]            ; get $t2.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-32]         ; load $t3
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t3.val
    ; $t4 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-40], rax         ; store $t4
    ; $t5 <- $t3 * $t4
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-48], rax         ; store $t5
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    mov     rdi, rax
    mov     rax, qword [rbp-40]         ; load $t4
    add     rax, 24
    mov     rax, qword [rax]            ; get $t4.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-48]         ; load $t5
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t5.val
    ; $t6 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-56], rax         ; store $t6
    ; $t7 <- $t5 * $t6
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-64], rax         ; store $t7
    mov     rax, qword [rbp-48]         ; load $t5
    add     rax, 24
    mov     rax, qword [rax]            ; get $t5.val
    mov     rdi, rax
    mov     rax, qword [rbp-56]         ; load $t6
    add     rax, 24
    mov     rax, qword [rax]            ; get $t6.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t7.val
    ; $t8 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-72], rax         ; store $t8
    ; $t9 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-80], rax         ; store $t9
    ; $t10 <- long / $t9
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-88], rax         ; store $t10
    mov     rax, qword [rbp-80]         ; load $t9
    add     rax, 24
    mov     rax, qword [rax]            ; get $t9.val
    mov     rdi, rax
    mov     rax, qword [rbp+16]         ; load long
    add     rax, 24
    mov     rax, qword [rax]            ; get long.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-88]         ; load $t10
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t10.val
    ; $t11 <- (Int)$t10.mod($t8)
    push    0
    mov     rax, qword [rbp-72]         ; load $t8
    push    rax                         ; arg0: $t8
    mov     rax, qword [rbp-88]         ; load $t10
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-96], rax         ; store $t11
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t12 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-104], rax        ; store $t12
    ; $t13 <- $t11 * $t12
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-112], rax        ; store $t13
    mov     rax, qword [rbp-96]         ; load $t11
    add     rax, 24
    mov     rax, qword [rax]            ; get $t11.val
    mov     rdi, rax
    mov     rax, qword [rbp-104]        ; load $t12
    add     rax, 24
    mov     rax, qword [rax]            ; get $t12.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-112]        ; load $t13
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t13.val
    ; $t14 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-120], rax        ; store $t14
    ; $t15 <- $t13 * $t14
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-128], rax        ; store $t15
    mov     rax, qword [rbp-112]        ; load $t13
    add     rax, 24
    mov     rax, qword [rax]            ; get $t13.val
    mov     rdi, rax
    mov     rax, qword [rbp-120]        ; load $t14
    add     rax, 24
    mov     rax, qword [rax]            ; get $t14.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-128]        ; load $t15
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t15.val
    ; $t16 <- $t7 + $t15
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-136], rax        ; store $t16
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    mov     rdi, rax
    mov     rax, qword [rbp-128]        ; load $t15
    add     rax, 24
    mov     rax, qword [rax]            ; get $t15.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-136]        ; load $t16
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t16.val
    ; $t17 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-144], rax        ; store $t17
    ; $t18 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-152], rax        ; store $t18
    ; $t19 <- long / $t18
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-160], rax        ; store $t19
    mov     rax, qword [rbp-152]        ; load $t18
    add     rax, 24
    mov     rax, qword [rax]            ; get $t18.val
    mov     rdi, rax
    mov     rax, qword [rbp+16]         ; load long
    add     rax, 24
    mov     rax, qword [rax]            ; get long.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-160]        ; load $t19
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t19.val
    ; $t20 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-168], rax        ; store $t20
    ; $t21 <- $t19 / $t20
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-176], rax        ; store $t21
    mov     rax, qword [rbp-168]        ; load $t20
    add     rax, 24
    mov     rax, qword [rax]            ; get $t20.val
    mov     rdi, rax
    mov     rax, qword [rbp-160]        ; load $t19
    add     rax, 24
    mov     rax, qword [rax]            ; get $t19.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-176]        ; load $t21
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t21.val
    ; $t22 <- (Int)$t21.mod($t17)
    push    0
    mov     rax, qword [rbp-144]        ; load $t17
    push    rax                         ; arg0: $t17
    mov     rax, qword [rbp-176]        ; load $t21
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-184], rax        ; store $t22
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t23 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-192], rax        ; store $t23
    ; $t24 <- $t22 * $t23
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-200], rax        ; store $t24
    mov     rax, qword [rbp-184]        ; load $t22
    add     rax, 24
    mov     rax, qword [rax]            ; get $t22.val
    mov     rdi, rax
    mov     rax, qword [rbp-192]        ; load $t23
    add     rax, 24
    mov     rax, qword [rax]            ; get $t23.val
    mul     rdi
    mov     rdi, rax
    mov     rax, qword [rbp-200]        ; load $t24
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t24.val
    ; $t25 <- $t16 + $t24
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-208], rax        ; store $t25
    mov     rax, qword [rbp-136]        ; load $t16
    add     rax, 24
    mov     rax, qword [rax]            ; get $t16.val
    mov     rdi, rax
    mov     rax, qword [rbp-200]        ; load $t24
    add     rax, 24
    mov     rax, qword [rax]            ; get $t24.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-208]        ; load $t25
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t25.val
    ; $t26 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-216], rax        ; store $t26
    ; $t27 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-224], rax        ; store $t27
    ; $t28 <- long / $t27
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-232], rax        ; store $t28
    mov     rax, qword [rbp-224]        ; load $t27
    add     rax, 24
    mov     rax, qword [rax]            ; get $t27.val
    mov     rdi, rax
    mov     rax, qword [rbp+16]         ; load long
    add     rax, 24
    mov     rax, qword [rax]            ; get long.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-232]        ; load $t28
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t28.val
    ; $t29 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-240], rax        ; store $t29
    ; $t30 <- $t28 / $t29
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-248], rax        ; store $t30
    mov     rax, qword [rbp-240]        ; load $t29
    add     rax, 24
    mov     rax, qword [rax]            ; get $t29.val
    mov     rdi, rax
    mov     rax, qword [rbp-232]        ; load $t28
    add     rax, 24
    mov     rax, qword [rax]            ; get $t28.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-248]        ; load $t30
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t30.val
    ; $t31 <- int 256
    mov     rax, int_const54            ; load 256
    mov     qword [rbp-256], rax        ; store $t31
    ; $t32 <- $t30 / $t31
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-264], rax        ; store $t32
    mov     rax, qword [rbp-256]        ; load $t31
    add     rax, 24
    mov     rax, qword [rax]            ; get $t31.val
    mov     rdi, rax
    mov     rax, qword [rbp-248]        ; load $t30
    add     rax, 24
    mov     rax, qword [rax]            ; get $t30.val
    cqo
    idiv    rdi
    mov     rdi, rax
    mov     rax, qword [rbp-264]        ; load $t32
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t32.val
    ; $t33 <- (Int)$t32.mod($t26)
    push    0
    mov     rax, qword [rbp-216]        ; load $t26
    push    rax                         ; arg0: $t26
    mov     rax, qword [rbp-264]        ; load $t32
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-272], rax        ; store $t33
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t34 <- $t25 + $t33
    mov     rax, Int_protObj
    call    Object.copy
    call    Int_init                    ; new Int
    mov     qword [rbp-280], rax        ; store $t34
    mov     rax, qword [rbp-208]        ; load $t25
    add     rax, 24
    mov     rax, qword [rax]            ; get $t25.val
    mov     rdi, rax
    mov     rax, qword [rbp-272]        ; load $t33
    add     rax, 24
    mov     rax, qword [rax]            ; get $t33.val
    add     rax, rdi
    mov     rdi, rax
    mov     rax, qword [rbp-280]        ; load $t34
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t34.val
    ; $t34
    mov     rax, qword [rbp-280]        ; load $t34
    pop     rbx
    add     rsp, 296
    pop     rbp
    ret
Ref.init:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40                     ; allocate 5 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- isvoid value
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-16], rax         ; store $t1
    mov     rax, qword [rbp+16]         ; load value
    test    rax, rax
    setz    al
    movzx   rax, al
    mov     rdi, rax
    mov     rax, qword [rbp-16]         ; load $t1
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t1.val
    ; bt $t1 L0
    mov     rax, qword [rbp-16]         ; load $t1
    add     rax, 24
    mov     rax, qword [rax]            ; get $t1.val
    test    rax, rax
    jnz     .L0
    ; $t2 <- (SELF_TYPE)self.init_(value)
    push    0
    mov     rax, qword [rbp+16]         ; load value
    push    rax                         ; arg0: value
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-24], rax         ; store $t2
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; $t0 <- $t2
    mov     rax, qword [rbp-24]         ; load $t2
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L1
.L0:
    ; $t3 <- (SELF_TYPE)self.null()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 0                      ; free 0 args
    ; $t0 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-8], rax          ; store $t0
.L1:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 40
    pop     rbp
    ret
Ref.deref:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                     ; allocate 7 locals
    push    rbx
    mov     rbx, rax
    ; $t1 <- (SELF_TYPE)self.addr()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+56]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 0                      ; free 0 args
    ; $t2 <- int 0
    mov     rax, int_const29            ; load 0
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- $t1 = $t2
    push    0
    mov     rax, qword [rbp-24]         ; load $t2
    push    rax                         ; arg0: $t2
    mov     rax, qword [rbp-16]         ; load $t1
    call    Int.equals
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 8                      ; free 1 args
    add     rsp, 8
    ; bt $t3 L0
    mov     rax, qword [rbp-32]         ; load $t3
    add     rax, 24
    mov     rax, qword [rax]            ; get $t3.val
    test    rax, rax
    jnz     .L0
    ; $t4 <- (SELF_TYPE)self.deref_()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+64]
    call    rdi
    mov     qword [rbp-40], rax         ; store $t4
    add     rsp, 0                      ; free 0 args
    ; $t0 <- $t4
    mov     rax, qword [rbp-40]         ; load $t4
    mov     qword [rbp-8], rax          ; store $t0
    jmp     .L1
.L0:
    ; $t5 <- (SELF_TYPE)self.abort()
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+24]
    call    rdi
    mov     qword [rbp-48], rax         ; store $t5
    add     rsp, 0                      ; free 0 args
    ; $t0 <- $t5
    mov     rax, qword [rbp-48]         ; load $t5
    mov     qword [rbp-8], rax          ; store $t0
.L1:
    ; $t0
    mov     rax, qword [rbp-8]          ; load $t0
    pop     rbx
    add     rsp, 56
    pop     rbp
    ret
Linux.read1:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 88                     ; allocate 11 locals
    push    rbx
    mov     rbx, rax
    ; $t0 <- new Ref
    mov     rax, Ref_protObj
    call    Object.copy
    call    Ref_init                    ; new Ref
    mov     qword [rbp-8], rax          ; store $t0
    ; $t1 <- (Ref)$t0.null()
    mov     rax, qword [rbp-8]          ; load $t0
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+48]
    call    rdi
    mov     qword [rbp-16], rax         ; store $t1
    add     rsp, 0                      ; free 0 args
    ; $t2 <- $t1
    mov     rax, qword [rbp-16]         ; load $t1
    mov     qword [rbp-24], rax         ; store $t2
    ; $t3 <- (SELF_TYPE)self.read(fd,$t2,count)
    push    0
    mov     rax, qword [rbp+24]         ; load count
    push    rax                         ; arg0: count
    mov     rax, qword [rbp-24]         ; load $t2
    push    rax                         ; arg1: $t2
    mov     rax, qword [rbp+16]         ; load fd
    push    rax                         ; arg2: fd
    mov     rax, rbx                    ; load self
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+40]
    call    rdi
    mov     qword [rbp-32], rax         ; store $t3
    add     rsp, 24                     ; free 3 args
    add     rsp, 8
    ; $t4 <- $t3
    mov     rax, qword [rbp-32]         ; load $t3
    mov     qword [rbp-40], rax         ; store $t4
    ; $t6 <- (Ref)$t2.deref()
    mov     rax, qword [rbp-24]         ; load $t2
    mov     rdi, qword [rax+16]
    mov     rdi, qword [rdi+80]
    call    rdi
    mov     qword [rbp-56], rax         ; store $t6
    add     rsp, 0                      ; free 0 args
    ; $t7 <- $t6 instanceof String
    mov     rax, Bool_protObj
    call    Object.copy
    call    Bool_init                   ; new Bool
    mov     qword [rbp-64], rax         ; store $t7
    mov     rax, qword [rbp-56]         ; load $t6
    add     rax, 0
    mov     rax, qword [rax]            ; get tag($t6)
    mov     rdi, rax
    cmp     rdi, 8
    setge   al
    movzx   rsi, al
    cmp     rdi, 8
    setle   al
    movzx   rax, al
    and     rax, rsi
    mov     rdi, rax
    mov     rax, qword [rbp-64]         ; load $t7
    xchg    rdi, rax
    add     rdi, 24
    mov     qword [rdi], rax            ; set $t7.val
    ; bt $t7 L1
    mov     rax, qword [rbp-64]         ; load $t7
    add     rax, 24
    mov     rax, qword [rax]            ; get $t7.val
    test    rax, rax
    jnz     .L1
.L1:
    ; $t8 <- $t6 as String
    mov     rax, qword [rbp-56]         ; load $t6
    mov     qword [rbp-72], rax         ; store $t8
    ; $t5 <- $t8
    mov     rax, qword [rbp-72]         ; load $t8
    mov     qword [rbp-48], rax         ; store $t5
    jmp     .L0
.L0:
    ; $t5
    mov     rax, qword [rbp-48]         ; load $t5
    pop     rbx
    add     rsp, 88
    pop     rbp
    ret
section '.data'
int_const0 dq 3                         ; type tag
           dq 4                         ; object size
           dq Int_dispTab               ; dispatch table
           dq 6                         ; integer value
str_const1 dq 8                         ; type tag
           dq 5                         ; object size
           dq String_dispTab            ; dispatch table
           dq int_const0                ; pointer to length
           db 79,98,106,101,99,116,0,0  ; string value
int_const2 dq 3                         ; type tag
           dq 4                         ; object size
           dq Int_dispTab               ; dispatch table
           dq 4                         ; integer value
str_const3 dq 8                         ; type tag
           dq 5                         ; object size
           dq String_dispTab            ; dispatch table
           dq int_const2                ; pointer to length
           db 77,97,105,110,0,0,0,0     ; string value
int_const4 dq 3                         ; type tag
           dq 4                         ; object size
           dq Int_dispTab               ; dispatch table
           dq 5                         ; integer value
str_const5 dq 8                         ; type tag
           dq 5                         ; object size
           dq String_dispTab            ; dispatch table
           dq int_const4                ; pointer to length
           db 70,108,111,97,116,0,0,0   ; string value
int_const6 dq 3                         ; type tag
           dq 4                         ; object size
           dq Int_dispTab               ; dispatch table
           dq 3                         ; integer value
str_const7 dq 8                         ; type tag
           dq 5                         ; object size
           dq String_dispTab            ; dispatch table
           dq int_const6                ; pointer to length
           db 73,110,116,0,0,0,0,0      ; string value
int_const8 dq 3                         ; type tag
           dq 4                         ; object size
           dq Int_dispTab               ; dispatch table
           dq 10                        ; integer value
str_const9 dq 8                         ; type tag
           dq 6                         ; object size
           dq String_dispTab            ; dispatch table
           dq int_const8                ; pointer to length
           db 68,111,117,98,108,101,87,111,114,100,0,0,0,0,0,0 ; string value
str_const10 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const2               ; pointer to length
            db 87,111,114,100,0,0,0,0   ; string value
str_const11 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const2               ; pointer to length
            db 66,121,116,101,0,0,0,0   ; string value
str_const12 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const2               ; pointer to length
            db 66,111,111,108,0,0,0,0   ; string value
str_const13 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const0               ; pointer to length
            db 83,116,114,105,110,103,0,0 ; string value
str_const14 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const4               ; pointer to length
            db 84,117,112,108,101,0,0,0 ; string value
int_const15 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 2                        ; integer value
str_const16 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const15              ; pointer to length
            db 73,79,0,0,0,0,0,0        ; string value
str_const17 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const0               ; pointer to length
            db 73,110,65,100,100,114,0,0; string value
int_const18 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 8                        ; integer value
str_const19 dq 8                        ; type tag
            dq 6                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const18              ; pointer to length
            db 83,111,99,107,65,100,100,114,0,0,0,0,0,0,0,0 ; string value
str_const20 dq 8                        ; type tag
            dq 6                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const8               ; pointer to length
            db 83,111,99,107,65,100,100,114,73,110,0,0,0,0,0,0 ; string value
str_const21 dq 8                        ; type tag
            dq 6                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const8               ; pointer to length
            db 83,111,99,107,101,116,84,121,112,101,0,0,0,0,0,0 ; string value
int_const22 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 12                       ; integer value
str_const23 dq 8                        ; type tag
            dq 6                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const22              ; pointer to length
            db 83,111,99,107,101,116,68,111,109,97,105,110,0,0,0,0 ; string value
str_const24 dq 8                        ; type tag
            dq 6                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const8               ; pointer to length
            db 73,110,101,116,72,101,108,112,101,114,0,0,0,0,0,0 ; string value
int_const25 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 13                       ; integer value
str_const26 dq 8                        ; type tag
            dq 6                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const25              ; pointer to length
            db 72,111,115,116,84,111,78,101,116,119,111,114,107,0,0,0 ; string value
str_const27 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const6               ; pointer to length
            db 82,101,102,0,0,0,0,0     ; string value
str_const28 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const4               ; pointer to length
            db 76,105,110,117,120,0,0,0 ; string value
int_const29 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 0                        ; integer value
int_const30 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 1                        ; integer value
str_const31 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 10,0,0,0,0,0,0,0         ; string value
int_const32 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 24                       ; integer value
str_const33 dq 8                        ; type tag
            dq 8                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const32              ; pointer to length
            db 65,98,111,114,116,32,99,97,108,108,101,100,32,102,114,111,109,32,99,108,97,115,115,32,0,0,0,0,0,0,0,0 ; string value
int_const34 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 7                        ; integer value
str_const35 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const34              ; pointer to length
            db 32,111,98,106,101,99,116,0 ; string value
int_const36 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 14                       ; integer value
str_const37 dq 8                        ; type tag
            dq 6                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const36              ; pointer to length
            db 72,101,108,108,111,44,32,87,111,114,108,100,33,10,0,0 ; string value
str_const38 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const29              ; pointer to length
            db 0,0,0,0,0,0,0,0          ; string value
str_const39 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 48,0,0,0,0,0,0,0         ; string value
str_const40 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 126,0,0,0,0,0,0,0        ; string value
str_const41 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 32,0,0,0,0,0,0,0         ; string value
str_const42 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 97,0,0,0,0,0,0,0         ; string value
str_const43 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 122,0,0,0,0,0,0,0        ; string value
str_const44 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 65,0,0,0,0,0,0,0         ; string value
str_const45 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 90,0,0,0,0,0,0,0         ; string value
str_const46 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 57,0,0,0,0,0,0,0         ; string value
str_const47 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 95,0,0,0,0,0,0,0         ; string value
str_const48 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const4               ; pointer to length
            db 102,97,108,115,101,0,0,0 ; string value
str_const49 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const2               ; pointer to length
            db 116,114,117,101,0,0,0,0  ; string value
bool_const50 dq 7                       ; type tag
             dq 4                       ; object size
             dq Bool_dispTab            ; dispatch table
             dq 0                       ; boolean value
bool_const51 dq 7                       ; type tag
             dq 4                       ; object size
             dq Bool_dispTab            ; dispatch table
             dq 1                       ; boolean value
int_const52 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 1024                     ; integer value
int_const53 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 16                       ; integer value
int_const54 dq 3                        ; type tag
            dq 4                        ; object size
            dq Int_dispTab              ; dispatch table
            dq 256                      ; integer value
str_const55 dq 8                        ; type tag
            dq 5                        ; object size
            dq String_dispTab           ; dispatch table
            dq int_const30              ; pointer to length
            db 46,0,0,0,0,0,0,0         ; string value
