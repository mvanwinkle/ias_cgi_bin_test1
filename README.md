# ias_cgi_bin_test1

Here is an introduction to this project.

# License

copyright (C) 2017 Author, Institution

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

See 

* http://www.gnu.org/licenses/

## Description

* some_script.sh - does something.

# Supplemental Documentation

Supplemental documentation for this project can be found here:

* [Supplemental Documentation](./doc/index.md)

# Installation

Ideally stuff should run if you clone the git repo, and install the deps specified
in either "deb_control" or "rpm_specific"

Optionally, you can build a package which will install the binaries in

* /opt/IAS/bin/ias-cgi-bin-test1/.

# Building a Package

## Requirements

### All Systems

* fakeroot

### Debian

* build-essential

### RHEL based systems

* rpm-build

## Export a specific tag (or just the source directory)

## Supported Systems

### Debian packages

```
  fakeroot make package-deb
```

### RHEL Based Systems

```
fakeroot make package-rpm
```

# New-ish notes
## Ubuntu

```
sudo apt-get install libapache2-mod-authnz-pam pwauth
sudo a2enmod authnz_external
sudo a2enmod cgi

```

Apache config:

```
# Use this if you have an ldap server
<Directory "/opt/IAS/cgi-bin-dev/">

	# this requires mod_ldap package
	# getsebool -a | grep ldap
	# httpd_can_connect_ldap --> off
	# setsebool httpd_can_connect_ldap 1
	# getsebool -a | grep ldap
	# httpd_can_connect_ldap --> on

    Options -Indexes +SymLinksIfOwnerMatch +ExecCGI
    SetHandler cgi-script
    AllowOverride None
    Require all denied
    AuthType Basic
    AuthName "IAS Admins Only"
    AuthBasicProvider ldap file
      <RequireAny>    
    <RequireAll>    
      AuthLDAPURL ldaps://ldap.ias.edu/dc=ias,dc=edu?uid    
      Require ldap-group cn=computing,ou=group,dc=net,dc=ias,dc=edu    
    </Requireall>    
    <RequireAll>    
      Require valid-user    
      AuthUserFile /etc/nagios/passwd    
    </Requireall>    
  </RequireAny>

# Use this if you just want to do local pam authentication
AddExternalAuth pwauth /usr/sbin/pwauth
SetExternalAuthMethod pwauth pipe

ScriptAlias "/ias-infra/cgi-bin-dev/" "/opt/IAS/cgi-bin-dev/"
# Alias "/ias-infra/cgi-bin-dev/" "/opt/IAS/cgi-bin-dev/"

<Directory "/opt/IAS/cgi-bin-dev/">

    Options -Indexes +SymLinksIfOwnerMatch +ExecCGI
    SetHandler cgi-script
#	AddHandler cgi-script .cgi .pl

    # SSLRequireSSL - enable this if you're not visiting localhost...
    AuthType Basic
    AuthName "PAM Authentication"
    AuthBasicProvider external
    AuthExternal pwauth
    require valid-user
</Directory>

```

```
/ias-infra/cgi-bin/artifact-name
/ias-infra/public-html/artifact-name


localhost/~mvanwinkle/cgi-bin/artifact-dir/ -> project_dir/src/cgi-bin/
localhost/~mvanwinkle/public-html/artifact-dir/ -> project_dir/src/public-html/

```

```
sudo a2enmod userdir

```

```
AddExternalAuth pwauth /usr/sbin/pwauth
SetExternalAuthMethod pwauth pipe

<Directory "/home/*/public_html/cgi-bin">
    Options +ExecCGI
    SetHandler cgi-script
</Directory>
```

# Old Notes

Ubuntu:

Setting up apache for cgi-bin user development:

```
a2enmod cgi
a2enmod userdir
mkdir -p ~/public_html/cgi-bin
chmod a+rx ~/public_html
chmod a+rx ~/public_html/cgi-bin

/etc/apache2/mods-available/userdir.conf
Add this at the bottom:
    <Directory "/home/*/public_html/cgi-bin">
        Options ExecCGI SymLinksIfOwnerMatch 
        SetHandler cgi-script
    </Directory>

restart apache2

######  ~/public_html/cgi-bin/hello.cgi
#!/usr/bin/perl

use strict;
use warnings;

print "Content-type:text/html\r\n\r\n";
print '<html>',$/;
print '<head>',$/;
print '<title>Hello, CGI Program</title>',$/;
print '</head>',$/;
print '<body>',$/;
print '<h2>Hello, CGI</h2>',$/;
print '</body>',$/;
print '</html>',$/;

```
