# ACL-Backup

Позволяет сделать полный backup списка прав доступа (ACL) файловой системы NTFS в txt-файл с возможностью восстановления из этого списка. В скрипте приведено описание всех ключей с примерами.

1 строка используется для выбора локальной директории или вставки скопированного пути источника. Если файл не выбран программа об этом сообщит: directory is not selected

2 строка (Backup) используется для указания места назначения сохранения ALC-списка в файл txt с подстановкой имени файла из названия директории источника.

3 строка (Restore) используется для выбора txt-файла ACL-списка (источник) для восстановления/копирования в директорию назначения указанной в первой строке.

![Image alt](https://github.com/Lifailon/ACL-Backup/blob/rsa/Interface.jpg)
