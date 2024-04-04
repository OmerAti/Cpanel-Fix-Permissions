Cpanel-Fix-Permissions
CPanel hesapları için dosya ve dizinlerdeki izinleri ve sahipliği düzeltmeye yönelik bir komut dosyası.


Talimatlar
Fixperms - tek bir kullanıcı için
fixperms Komut dosyasını almak için wget dosyayı GitHub'dan almanız ve yürütülebilir olduğundan emin olmanız yeterlidir:
```
wget https://raw.githubusercontent.com/OmerAti/Cpanel-Fix-Permissions/master/fixperms.sh
chmod +x fixperms.sh
```
Daha sonra, belirli bir cPanel kullanıcısını belirtmek için 'a' bayrağını kullanırken bunu (KÖK izinleriyle) çalıştırın:
```
sudo sh ./fixperms.sh -a USER-NAME
```
Fixperms'i çalıştırdığınızda hangi dizinde olduğunuzun bir önemi yoktur. Kullanıcının ana dizininde, sunucu kökünde vs. olabilirsiniz. Komut dosyası, belirli bir kullanıcının ana klasörü dışındaki hiçbir şeyi etkilemeyecektir.

Fixperm'ler - tüm kullanıcılar için
CPanel sunucunuzdaki her kullanıcının izinlerini düzeltmek istiyorsanız '-all' seçeneğini kullanmanız yeterlidir:
```
sudo sh ./fixperms.sh -all
```
Tek bir hesap için
```
sudo sh ./fixperms.sh -v -a USER-NAME
```
Tüm hesaplar için
```
sudo sh ./fixperms.sh -v -all
```
Yardım almak
fixperms Yardım menüsünü görmek için '-h' veya '--help' bayraklarıyla çalıştırabilirsiniz .

Herhangi bir sorunla karşılaşırsanız GitHub'da da bir sorun açabilirsiniz.
