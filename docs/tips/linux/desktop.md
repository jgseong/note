# Install system tray icon on elementary OS Juno

**Juno**는 **elementary OS 5.0** 의 GUI. 

기본적으로 system tray icon을 지원하지 않음

> About system tray icons. In [release-juno](https://elementaryos.stackexchange.com/questions/tagged/release-juno), elementaryOS dropped the support of the old Ayatana Indicators   \(refer to [StackExchange](https://elementaryos.stackexchange.com/questions/17452/how-to-display-system-tray-icons-in-elementary-os-juno?rq=1)\)

* Ayanata Indicators 설치 및 설정

```bash
sudo add-apt-repository -y ppa:yunnxx/elementary
sudo apt update
sudo apt install -y indicator-application wingpanel-indicator-ayatana

sudo sed -i 's/OnlyShowIn=.*;/OnlyShowIn=Pantheon;/' /etc/xdg/autostart/indicator-application.desktop
# Alternatively, run 'sudo vim /etc/xdg/autostart/indicator-application.desktop' to edit file

sudo systemctl restart lightdm.service  # Or restart system.
```


