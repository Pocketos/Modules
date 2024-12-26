#Title: rClone
#Description: Uses rClone to sync directories
#WIP
function useRclone {
$logFile="C:\$(get-date -format d.M.yyyy).log"
rclone copy -v --log-file $logFile E:/FTP/wp-backup/korkscrewgaming remote:wp-backups/korkscrewgaming
rclone copy -v --log-file $logFile E:/FTP/wp-backup/tylermalcarne remote:wp-backups/tylermalcarne
rclone copy -v --log-file $logFile E:/FTP/vCenterBackup remote:vCenterBackups
#Send status email
#$logContent = [IO.File]::ReadAllText($logFile)
#send-mailmessage -from notifications@yourdomain.com -to you@yourdomain.com -subject 'rClone ran successfully' -body "$logContent" -Attachments $logFile -smtpserver smtp.yourdomain.com
[Environment]::Exit(0)
}