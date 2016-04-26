# Reset SELinux context:

ROOT_PATH_FOR_RESET_CONTEXT=/etc/ 
for el in $( cat /etc/selinux/targeted/contexts/files/file_contexts.local | grep $ROOT_PATH_FOR_RESET_CONTEXT | awk '{print $1}' ); do
        semanage fcontext -d $el;
done;

restorecon -Rvvv .
