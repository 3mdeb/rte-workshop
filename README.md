Prerequisities
--------------

* laptop with WiFi connection

```
network ID: RTE-Workshop
password:   E4i94qUw4IHj
```

* installed Virtual Box environment with Extension Pack - [download](https://www.virtualbox.org/wiki/Downloads)
* enabled virtualization in BIOS settings for 64-bit VBox system image
* download our exported Debian OVA image (32-bit version doesn't require
virtualization, but it's without Docker installed):
    - x64 version - [download](https://cloud.3mdeb.com/index.php/s/zvolHh8l1UeKB9L)
    - x86 version - [download](https://cloud.3mdeb.com/index.php/s/Pnd7yjc9SnTR44F)

* import `Debian RTE Workshop x64.ova` to your Virtual Box - [instruction](https://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html)

* start imported OS and log in:
```
user:       rte-workshop
password:   rte-workshop
```
* all necessary files can be found in `~/RTE-Workshop/` directory including
`README`

Presentation
------------

RTE-Workshop presentation is created with Remark - in-browser, markdown-driven slideshow tool. To run such presentation, go to directory with all required
files and run:

```
sudo python -m SimpleHTTPServer 80
```
Now, open your favourite browser and type `0.0.0.0`. There should be listed
directory tree with `rte-workshop.html` file. Just click it and enjoy our
presentation.
