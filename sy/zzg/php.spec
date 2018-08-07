Name:		php
Version:	7.2
Release:	2
Summary:	PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.

Group:		luck
License:	GPLv2
URL:		http://www.php.net/
Source0:	%{name}-%{version}.%{release}.tar.bz2
Source1:	php-fpm.conf
Source2:	www.conf
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

%define         debug_package %{nil}
%define 	__check_files %{nil}
BuildRequires:	glibc gcc perl pkgconfig curl-devel gd-devel libXpm-devel zlib-devel readline-devel libxml2-devel
Requires:	nss-tools nss-util bash pcre openssl libXpm gd
Packager:	luck
%description
	PHP is a widely-used general-purpose scripting language.

%prep
%setup -q -c -n %{name}-%{version}.%{release}

%build
cd %{name}-%{version}.%{release}
./configure --prefix=/usr/local/php --with-config-file-path=/etc --enable-fd-setsize=65535 --enable-fpm --disable-ipv6 --without-sqlite3 --without-pdo-sqlite --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg --enable-shmop --enable-mbstring --enable-zip --enable-bcmath --enable-ftp --enable-soap --with-mhash --with-pcre-regex --with-pcre-dir --with-readline --with-zlib --with-curl --with-openssl --with-iconv --with-gd --with-png-dir --with-jpeg-dir --with-freetype-dir --with-xpm-dir --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd
make

%install
cd %{name}-%{version}.%{release}
make INSTALL_ROOT=${RPM_BUILD_ROOT} install
mkdir -p %{buildroot}/{etc,var/log/weblog,usr/lib/systemd/system}
cp php.ini-production %{buildroot}/etc/php.ini
cp sapi/fpm/php-fpm.service %{buildroot}/usr/lib/systemd/system/
cp %{S:1} %{buildroot}/usr/local/php/etc/
cp %{S:2} %{buildroot}/usr/local/php/etc/php-fpm.d/

%clean
rm -rf %{buildroot} %{_builddir}

%files
%defattr(-,root,root,-)
/usr/local/php
/etc/php.ini
/usr/lib/systemd/system/php-fpm.service

%pre
if  ! $(id web &>/dev/null);then
    groupadd -g 1000 web
    useradd -u 1000 -g 1000 web -s /sbin/nologin
fi

%post
for _F in php php-config phpize;do
    ln -s /usr/local/php/bin/$_F /usr/local/bin
done

%preun
systemctl stop php-fpm>/dev/null
rm -f /usr/local/bin/{php,php-config,phpize} /var/log/weblog/php*log

%postun

%changelog

