## aptly.con

[aptly.conf Belgelendirme](https://www.aptly.info/doc/configuration/) bağlantısı.

Aptly'nin kök dizini (rootDir), Aptly tarafından kullanılan tüm verilerin saklandığı dizindir. Bu dizin, Aptly'nin depolarını, yayınlarını, anlık görüntülerini ve diğer yapılandırma dosyalarını içerir.

Aptly'nin kök dizini genellikle `/var/lib/aptly` veya `/srv/aptly` gibi bir dizin olarak ayarlanır. Ancak, bu dizin yapılandırma dosyasında (`aptly.conf`) `rootDir` parametresi ile belirtilir ve kullanıcı tarafından özelleştirilebilir.

`aptly`'nin config dosyası JSON formatındadır ve yapılandırma için temel bilgileri içerir. Varsayılan olarak `/root/.aptly.conf` veya `/etc/aptly.conf` gibi yerlerde oluşturulabilir. Aşağıda tipik bir `aptly` config dosyasının örneği bulunmaktadır:

---

### Örnek Config Dosyası
```json
{
  "rootDir": "/opt/aptly",
  "downloadConcurrency": 4,
  "architectures": [],
  "dependencyFollowSuggests": false,
  "dependencyFollowRecommends": false,
  "dependencyFollowAllVariants": false,
  "dependencyFollowSource": false,
  "gpgDisableSign": true,
  "gpgDisableVerify": true,
  "gpgProvider": "gpg",
  "downloadSourcePackages": false,
  "ppaDistributorID": "",
  "ppaCodename": "",
  "skipLegacyPool": false,
  "enableMetrics": false,
  "S3PublishEndpoints": {},
  "SwiftPublishEndpoints": {},
  "AzurePublishEndpoints": {},
  "FileSystemPublishEndpoints": {}
}
```


---

### Parametreler ve Anlamları

1. **`rootDir`:**  
   - Aptly'nin veri deposu için kullanılan dizin. Depo bilgileri, yayınlanan veriler ve meta veriler burada saklanır.  
   - Varsayılan: `/opt/aptly`  

2. **`downloadConcurrency`:**  
   - Aynı anda indirilecek paketlerin sayısını belirler.  
   - Önerilen değer: 4 veya daha fazla.

3. **`architectures`:**  
   - Desteklenecek mimariler (örneğin, `["amd64", "i386"]`). Boş bırakılırsa tüm mimariler kabul edilir.  

4. **`dependencyFollowSuggests`:**  
   - Bağımlılık çözümlemede `Suggests` önerilerini takip etmek için `true`.  

5. **`dependencyFollowRecommends`:**  
   - Bağımlılık çözümlemede `Recommends` önerilerini takip etmek için `true`.  

6. **`gpgDisableSign`:**  
   - Depo yayınlarken GPG imzalamayı devre dışı bırakır.  
   - Eğer GPG kullanıyorsanız `false` yapın.
   
   Aptly paket yönetim sisteminin GPG (GNU Privacy Guard) imzalama ve doğrulama davranışını kontrol eder:

   `gpgDisableSign`: False olarak ayarlandığında, GPG imzalama etkinleştirilir. Bu, Aptly'nin paketleri ve depoları doğruluklarını doğrulamak için GPG anahtarları ile imzalayacağı anlamına gelir. True olarak ayarlanırsa imzalama devre dışı kalır.

   `gpgDisableVerify`: False olarak ayarlandığında, GPG doğrulaması etkinleştirilir. Bu, Aptly'nin paketleri indirirken veya içe aktarırken GPG imzalarını doğrulayacağı anlamına gelir. True olarak ayarlanırsa imza doğrulaması atlanır.

   Güvenlik için her iki değeri de false olarak tutmak önerilir, çünkü bu sayede paketlerin düzgün şekilde imzalandığından ve doğrulandığından emin olunur. Bu, paketlerin kurcalanmasını önlemeye ve güvenilir kaynaklardan geldiğinden emin olmaya yardımcı olur.

7. **`gpgDisableVerify`:**  
   - İndirilen paketlerin GPG imzalarını doğrulamayı devre dışı bırakır.  

8. **`gpgProvider`:**  
   - Kullanılacak GPG sağlayıcısı (`gpg`, `gpg1`, `gpg2`, `internal`).  

9. **`downloadSourcePackages`:**  
   - Kaynak paketleri indirmek için `true`.  

10. **`S3PublishEndpoints`:**  
    - Eğer Amazon S3 üzerinden depolar yayınlanıyorsa, bu alan kullanılır.  

11. **`SwiftPublishEndpoints`:**  
    - OpenStack Swift kullanımı için ayarlar.  

12. **`AzurePublishEndpoints`:**  
    - Azure Blob Storage kullanımı için ayarlar.  

13. **`FileSystemPublishEndpoints`:**  
    - Dosya sistemi üzerinden yayınlama yapmak için dizin ayarları.

---

### GPG Olmadan Repo Ayarları

Eğer sadece `amd64` mimarisini desteklemek ve GPG imzalarını devre dışı bırakmak istiyorsanız:

```json
{
  "rootDir": "/var/lib/aptly",
  "architectures": ["amd64"],
  "gpgDisableSign": true,
  "gpgDisableVerify": true
}
```

yerine 

```json
{
  "rootDir": "/var/lib/aptly",
  "architectures": ["amd64"],
  "gpgDisableSign": false,
  "gpgDisableVerify": false
}
```

İstemcide repo için yazılacak hedef sunucuya `[trusted=yes]` demeniz gerekir.

```conf
deb [trusted=yes] http://aptly/ stable main
```

---

### Config Dosyasını Manuel Olarak Oluşturma
Eğer config dosyanız yoksa şu komutla varsayılan bir tane oluşturabilirsiniz:
```bash
aptly config create
```

Varsayılan olarak `/root/.aptly.conf` yolunda oluşacaktır. İçeriği gerektiği gibi düzenleyebilirsiniz.  

---

Bu bilgiler doğrultusunda kendi ihtiyaçlarınıza göre bir `aptly` config dosyası oluşturabilirsiniz. Daha fazla detay gerekiyorsa, örnek kullanımınıza göre özelleştirelim. 😊

### İstemci Ayarları 

```conf
deb [trusted=yes] http://aptly/ stable main
```


```shell
cemt@PC-CEM-TOPKAYA:~/_REPOSITORIES/_DEB_REPO/aptly$ docker exec -it client apt update
Ign:1 http://aptly stable InRelease
Get:2 http://archive.ubuntu.com/ubuntu jammy InRelease [270 kB]
Get:3 http://security.ubuntu.com/ubuntu jammy-security InRelease [129 kB]
Ign:1 http://aptly stable InRelease
Ign:1 http://aptly stable InRelease
Get:4 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [3448 kB]
Err:1 http://aptly stable InRelease
  Could not connect to aptly:80 (172.22.0.3). - connect (111: Connection refused)
Get:5 http://archive.ubuntu.com/ubuntu jammy-updates InRelease [128 kB]
Get:6 http://archive.ubuntu.com/ubuntu jammy-backports InRelease [127 kB]
Get:7 http://archive.ubuntu.com/ubuntu jammy/restricted amd64 Packages [164 kB]
Get:8 http://archive.ubuntu.com/ubuntu jammy/multiverse amd64 Packages [266 kB]
15% [8 Packages 60.5 kB/266 kB 23%] [4 Packages 430 kB/3448 kB 12%]                                                                                                       164 kB/s 3min 29s^Ccemt@PC-CEM-TOPKAYA:~/_REPOSITORIES/_DEB_REPO/aptly$ docker exec -it client bash
root@48b820cd1669:/# apt update
Ign:1 http://aptly stable InRelease
Get:2 http://aptly stable Release [3424 B]
Ign:3 http://aptly stable Release.gpg
Get:4 http://security.ubuntu.com/ubuntu jammy-security InRelease [129 kB]
Get:5 http://archive.ubuntu.com/ubuntu jammy InRelease [270 kB]
0% [5 InRelease 55.2 kB/270 kB 20%] [4 InRelease 24.7 kB/129 kB 19%]^C
root@48b820cd1669:/# rm -rf /etc/apt/sources.list
root@48b820cd1669:/# apt update
Ign:1 http://aptly stable InRelease
Get:2 http://aptly stable Release [3424 B]
Ign:3 http://aptly stable Release.gpg
Reading package lists... Done
E: The repository 'http://aptly stable Release' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
root@48b820cd1669:/# cemt@PC-CEM-TOPKAYA:~/_REPOSITORIES/_DEB_REPO/aptly$ docker exec -it client bash
root@a2dbdaffdb11:/# apt update
Ign:1 http://aptly stable InRelease
Ign:1 http://aptly stable InRelease
Ign:1 http://aptly stable InRelease
Err:1 http://aptly stable InRelease
  Could not connect to aptly:80 (172.22.0.2). - connect (111: Connection refused)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
All packages are up to date.
W: Failed to fetch http://aptly/dists/stable/InRelease  Could not connect to aptly:80 (172.22.0.2). - connect (111: Connection refused)
W: Some index files failed to download. They have been ignored, or old ones used instead.
root@a2dbdaffdb11:/#
root@a2dbdaffdb11:/#
root@a2dbdaffdb11:/#
root@a2dbdaffdb11:/# apt update
Ign:1 http://aptly stable InRelease
Get:2 http://aptly stable Release [3424 B]
Ign:3 http://aptly stable Release.gpg
Get:4 http://aptly stable/main amd64 Packages [856 B]
Fetched 4280 B in 0s (230 kB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
All packages are up to date.
root@a2dbdaffdb11:/#
root@a2dbdaffdb11:/# apt list iproute2
Listing... Done
iproute2/stable 6.1.0-3 amd64
root@a2dbdaffdb11:/#
root@a2dbdaffdb11:/#
root@a2dbdaffdb11:/# apt show iproute2
Package: iproute2
Version: 6.1.0-3
Priority: important
Section: net
Maintainer: Debian Kernel Team <debian-kernel@lists.debian.org>
Installed-Size: 3600 kB
Provides: arpd
Depends: debconf (>= 0.5) | debconf-2.0, libbpf1 (>= 1:0.6.0), libbsd0 (>= 0.0), libc6 (>= 2.34), libcap2 (>= 1:2.10), libdb5.3, libelf1 (>= 0.131), libmnl0 (>= 1.0.3-4~), libselinux1 (>= 3.1~), libtirpc3 (>= 1.0.2), libxtables12 (>= 1.6.0+snapshot20161117), libcap2-bin
Recommends: libatm1 (>= 2.4.1-17~)
Suggests: iproute2-doc, python3:any
Conflicts: arpd, iproute (<< 20130000-1)
Replaces: iproute
Homepage: https://wiki.linuxfoundation.org/networking/iproute2
Download-Size: 1046 kB
APT-Sources: http://aptly stable/main amd64 Packages
Description: networking and traffic control tools
 The iproute2 suite is a collection of utilities for networking and
 traffic control.
 .
 These tools communicate with the Linux kernel via the (rt)netlink
 interface, providing advanced features not available through the
 legacy net-tools commands 'ifconfig' and 'route'.

root@a2dbdaffdb11:/#
```
