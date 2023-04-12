{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "duplicate-tab-shortcut" = buildFirefoxXpiAddon {
      pname = "duplicate-tab-shortcut";
      version = "1.5.3";
      addonId = "duplicate-tab@firefox.stefansundin.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/3758531/duplicate_tab_shortcut-1.5.3.xpi";
      sha256 = "7f200f9effad825d772effc61ab7727d89beb552e6ae1ffcf181501a02f819e8";
      meta = with lib;
      {
        homepage = "https://github.com/stefansundin/duplicate-tab";
        description = "Press Alt+Shift+D to duplicate the current tab (Option+Shift+D on Mac).";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "istilldontcareaboutcookies" = buildFirefoxXpiAddon {
      pname = "istilldontcareaboutcookies";
      version = "1.1.1";
      addonId = "idcac-pub@guus.ninja";
      url = "https://addons.mozilla.org/firefox/downloads/file/4069651/istilldontcareaboutcookies-1.1.1.xpi";
      sha256 = "ff52ac5b1742b95e0cb778b301a5259b9b5c6ffef69bd7770acec9544c5f1287";
      meta = with lib;
      {
        homepage = "https://github.com/OhMyGuus/I-Dont-Care-About-Cookies";
        description = "Community version of the popular extension \"I don't care about cookies\"  \n\n<a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/d899243c3222e303a4ac90833f850da61cdf8f7779e2685f60f657254302216d/https%3A//github.com/OhMyGuus/I-Dont-Care-About-Cookies\" rel=\"nofollow\">https://github.com/OhMyGuus/I-Dont-Care-About-Cookies</a>";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "masterpassword-firefox" = buildFirefoxXpiAddon {
      pname = "masterpassword-firefox";
      version = "2.9.5";
      addonId = "jid1-pn4AFskf9WBAdA@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3924440/masterpassword_firefox-2.9.5.xpi";
      sha256 = "50366c4e41c7f7a8ab24a04dd48bdfebd6b24e0ebcb09a3f9446ddbd0f793f91";
      meta = with lib;
      {
        homepage = "https://github.com/ttyridal/masterpassword-firefox/wiki";
        description = "Keep different passwords for every site you log into without having to remember anything but a single master password. And without the risk of your getting your password list stolen. \n\nMasterPassword is available for all your devices!";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    }