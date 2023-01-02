# Windows Services Watcher Script

🚦 This is a simple PowerShell script that allows you to watch and control windows services.

## 🚀 Usage

* Download the last released version from the [releases tab](https://github.com/AmraniCh/windows-services-watcher/releases).
* Open the `services.txt` file and change the content with the services names you want to track.
* Open your PowerShell terminal **as an administrator**, navigate to the script directory and type:

```console
.\main.ps1 services.txt 'stop' 3
```

## ⚙️ Script Parameters

```console
.\main.ps1 [ServicesFilePath] [Action] [Interval=1]
```

| Parameter        | Description |
| ---------------- | ----------- |
| ServicesFilePath | Indicates the path of the file with your services list |
| Action           | The action you want to operate on the services, it can be one of the following [start, stop, restart] |
| Interval         | The interval time in seconds between each loop, default is **1 second**. |

## ©️ License

This script is published under the open source MIT license, please read the license file included with the project for more information.
