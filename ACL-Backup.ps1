# RunAs Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb RunAs -ArgumentList $arguments
  Break
}

# Права доступа:
# F – полный доступ
# M – изменение
# RX – чтение и выполнение
# R – только чтение
# W – запись
# D – удаление

# Права наследования (только каталоги):
# (OI)— наследование объектами
# (CI)— наследование контейнерами
# (IO)— только наследование
# (I)– разрешение унаследовано от родительского объекта

# icacls 'C:\Share\' /grant ts.sys\test-group:RX # выдать права RX на группу
# icacls 'C:\Share\' /remove ts.sys\test-group # удалить группу из ACL-списка каталога
# icacls 'C:\Share\' /inheritance:e # включить наследование NTFS прав доступа с родительского каталога
# icacls 'C:\Share\' /inheritance:r # отключить наследование с удалением всех наследованных ACEs
# icacls 'C:\Share\' /setowner ts.sys\support4 /T /C /L /Q # изменить владельца

Add-Type -AssemblyName System.Windows.Forms

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='ACL Backup'
$main_form.Font = "Arial,14"
$main_form.ForeColor = "Black"
$main_form.BackColor = "Silver"
$main_form.Width = 1000
$main_form.Height = 400
$main_form.AutoSize = $true

$button1 = New-Object System.Windows.Forms.Button
$button1.Text = 'Directory'
$button1.Location = New-Object System.Drawing.Point(120,80)
$button1.Size = New-Object System.Drawing.Size(120,40) 
$button1.AutoSize = $true
$main_form.Controls.Add($button1)

$button1.Add_Click({
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowser.ShowDialog()
$source = @($FolderBrowser.SelectedPath)
if ($source -ne $null) {$outputBox1.text = "$source"} else {$outputBox1.text = "directory is not selected"}
})

$outputBox1 = New-Object System.Windows.Forms.TextBox 
$outputBox1.Location = New-Object System.Drawing.Size(255,83) 
$outputBox1.Size = New-Object System.Drawing.Size(500,35)
$outputBox1.MultiLine = $True
$main_form.Controls.Add($outputBox1)

$button2 = New-Object System.Windows.Forms.Button
$button2.Text = 'Destination'
$button2.Location = New-Object System.Drawing.Point(120,130)
$button2.Size = New-Object System.Drawing.Size(120,40) 
$button2.AutoSize = $true
$main_form.Controls.Add($button2)

$button2.Add_Click({
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowser.ShowDialog()
$dest = @($FolderBrowser.SelectedPath)
if ($dest -ne $null) {$out = "$dest"}
# Парсинг вывода первой строки для генирации имени и последующей подстановки в конце второй строки
if ($dest -ne $null) {$path = $outputBox1.text}
if ($dest -ne $null) {$path = $path -split "\\"}
if ($dest -ne $null) {$path = $path = $path[-1]}
if ($dest -ne $null) {$name = $path + ".txt"}
if ($dest -ne $null) {$outputBox2.text = $out + "\" + $name} else {$outputBox2.text = "directory is not selected"}
})

$outputBox2 = New-Object System.Windows.Forms.TextBox 
$outputBox2.Location = New-Object System.Drawing.Size(255,133) 
$outputBox2.Size = New-Object System.Drawing.Size(500,35)
$outputBox2.MultiLine = $True
$main_form.Controls.Add($outputBox2)

$button3 = New-Object System.Windows.Forms.Button
$button3.Text = 'Backup'
$button3.Location = New-Object System.Drawing.Point(770,130)
$button3.Size = New-Object System.Drawing.Size(120,40) 
$button3.AutoSize = $true
$main_form.Controls.Add($button3)

$button3.Add_Click({
icacls $outputBox1.text /save $outputBox2.text /t /c /q
# /t - указывает, что нужно получить ACL для всех дочерних подкаталогов и файлов
# /c – позволяет игнорировать ошибки доступа.
# /q - отключить вывод на экран информации об успешных действиях при доступе к объектам файловой системы
})

$button4 = New-Object System.Windows.Forms.Button
$button4.Text = 'Source'
$button4.Location = New-Object System.Drawing.Point(120,180)
$button4.Size = New-Object System.Drawing.Size(120,40) 
$button4.AutoSize = $true
$main_form.Controls.Add($button4)

$button4.Add_Click({
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
$FileBrowser.Multiselect = $false
$FileBrowser.Filter = 'ACL Backup (*.txt)|*.txt'
$FileBrowser.ShowDialog()
$outputBox3.Text = @($FileBrowser.FileNames)
})

$outputBox3 = New-Object System.Windows.Forms.TextBox 
$outputBox3.Location = New-Object System.Drawing.Size(255,183) 
$outputBox3.Size = New-Object System.Drawing.Size(500,35)
$outputBox3.MultiLine = $True
$main_form.Controls.Add($outputBox3)

$button5 = New-Object System.Windows.Forms.Button
$button5.Text = 'Restore'
$button5.Location = New-Object System.Drawing.Point(770,181)
$button5.Size = New-Object System.Drawing.Size(120,40) 
$button5.AutoSize = $true
$main_form.Controls.Add($button5)

$button5.Add_Click({
icacls $outputBox1.text /restore $outputBox3.Text /t /c /q
# Если нужно восстановить для директории C:\Install, то путь нужно указывать C:\
# Для копирования списка доступов на другую директорию, нужно изаменить (Replace) в txt-файле имя директории
})

$main_form.ShowDialog()