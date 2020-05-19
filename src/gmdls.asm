%ifdef INCLUDE_GMDLS

%define SAMPLE_TABLE_SIZE 3440660 ; size of gmdls

extern _OpenFile@12 ; requires windows
extern _ReadFile@20 ; requires windows

SECT_TEXT(sugmdls)

su_gmdls_load:
    mov     edi, MANGLE_DATA(su_sample_table)      
    mov     esi, su_gmdls_path1   
    su_gmdls_pathloop:            
        push    0                   ; OF_READ
        push    edi                 ; &ofstruct, blatantly reuse the sample table
        push    esi                 ; path
        call    _OpenFile@12        ; eax = OpenFile(path,&ofstruct,OF_READ)
        add     esi, su_gmdls_path2 - su_gmdls_path1 ; if we ever get to third, then crash
        cmp     eax, -1             ; eax == INVALID? 
        je      su_gmdls_pathloop
    push    0                       ; NULL
    push    edi                     ; &bytes_read, reusing sample table again; it does not matter that the first four bytes are trashed
    push    SAMPLE_TABLE_SIZE       ; number of bytes to read
    push    edi                     ; here we actually pass the sample table to readfile
    push    eax                     ; handle to file
    call    _ReadFile@20            ; Readfile(handle,&su_sample_table,SAMPLE_TABLE_SIZE,&bytes_read,NULL)
    ret

SECT_DATA(sugmpath)

su_gmdls_path1:
    db 'drivers/gm.dls',0
su_gmdls_path2:
    db 'drivers/etc/gm.dls',0    

SECT_DATA(suconst)
    c_samplefreq_scaling    dd      84.28074964676522       ; o = 0.000092696138, n = 72, f = 44100*o*2**(n/12), scaling = 22050/f <- so note 72 plays at the "normal rate"

SECT_BSS(susamtbl)
    EXPORT MANGLE_DATA(su_sample_table)    resb    SAMPLE_TABLE_SIZE    ; size of gmdls.

%endif