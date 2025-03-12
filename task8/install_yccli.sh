#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # any linux
    echo 'Installing for Linux'
    curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
    echo 'Installing for Mac OS'
    curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows (it's WSL)
        echo 'wsl in still in todo'
elif [[ "$OSTYPE" == "msys" ]]; then
        # mingw git-bash
    echo 'Installing for Windows'
    pwsh iex (New-Object System.Net.WebClient).DownloadString('https://storage.yandexcloud.net/yandexcloud-yc/install.ps1')

else
    echo 'Unknown'
fi
