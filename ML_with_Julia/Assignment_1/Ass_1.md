# Overthewire Bandit

## Level 0

> Password: boJ9jbbUNNfktd78OOpsqOltutMc3MY1

This level is simply connecting to overthewire server via ssh.  
The password in the only file at home directory.

## Level 1

> Password: CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9

The file name is the tricky part in this level.  
Cleared by specifying the path as ./-

## Level 2

> Password: UmHadQclWmgdLOKQ3YNgjWxGoRMb5luK

Again, the file name was to be handled carefully.  
Used `cat 'spaces in this filename'`

## Level 3

> Password: pIwrPrtPN36QITSp3EQaw936yaFoFgAB

The password is in a hidden file `.hidden`.

## Level 4

> Password: koReBOKuIDDepwhWk7jZC0RTdopnAYKh

Used the `file *` to know which file is human-readable.

## Level 5

> Password: DXjZPULLxYr17uwoI01bNLQbtFemEgo7

Given that file size is 1033 bytes,  
running `find . -size 1033` does the trick.

## Level 6

> Password: HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs

Given that password is hidden in the server,  
navigating to root and using `find . -size 33c` is enough.

## Level 7

> Password: cvX2JJa4CFALtqS87jk27qwqGhBM9plV

Given that password is in data.txt  
Next to the word "millionth", did this manually.

## Level 8

> Password: UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR

Given that password is the only unique line.  
Too long to do manually, used `cat data.txt | uniq -u`

## Level 9

> Password: truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk

Password is next to 'a lot of "="'.  
Thus used `cat data.txt | grep =`

## Level 10

> Password: IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR

The password string is encrypted by base64.  
Used `cat data.txt | base64 --decode`

## Level 11

> Password: 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu

Given that password has been encrypted by rot13.  
A Google search explained how to do so..  
with `cat data.txt | tr a-zA-Z n-za-mN-ZA-M`

## Level 12

> Password: 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL

Hex dump level...yay.. ;-; Took me long enough.  
First making a temporary directory as `mkdir /tmp/banshuman20`  
Copying the data.txt file there.  
Now to reverse the hexdump, `xxd -r data.txt mdata`  
mdata.txt is found to be gzip compressed.  
Changing the name to mdata.gz  
De-gzip (gunzip) with `gzip -d mdata.gz`  
`file` shows that it's a bzip2 file.
Redoing above steps in similar fashion with `mv mdata mdata.bz2` `bzip2 -d mdata.bz2`  
Again a gzip file. Do the above.  
This yields a tar. Untar with `tar -xvfg mdata`  
Again untar 'data5.bin' obtained to get 'data6.bin'  
file now shows a bzip2 again. Unzip to get 'data8.bin'  
Another check shows this as a gzip file. `gunzip data8.gz` after renaming ofc.  
We finally obtain `data9.bin`, which contains what we were after.

## Level 13

> Password: 4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e

Entering the server shows a private key to the next server.  
Use that as `ssh bandit14@localhost -i sshkey private`.  
The password mentioned is found in the next step.

## Level 14

> Password: BfMYroe26WYalil77FoDi9qh59eK5xNr

The above procedure leaves us as bandit14.  
I do remember all host details were accessible at /etc (/etc/bandit_pass)  
found during reading about root directories.  
Used it for above password, and to submit to port 30000 of localhost.  
Used `nc localhost 30000` and entered this level's password.

## Level 15

> Password: cluFn7wTiGryunymYOu4RcffSxQluehd

The hint was using SSL connection, so searching a bit gave the exact solution  
Using `openssl s_client localhost:30001` and entering the password...did it.
