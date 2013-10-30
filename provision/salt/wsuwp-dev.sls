# Setup the WSUWP Platform for local development in Vagrant.
wp-cli:
  cmd.run:
    - name: curl https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash
    - unless: which wp
    - user: vagrant
    - require:
      - pkg: php-fpm
      - pkg: git
  file.symlink:
    - name: /usr/bin/wp
    - target: /home/vagrant/.wp-cli/bin/wp

wsuwp-dev-initial:
  cmd.run:
    - name: cd /var/www/; git clone https://github.com/washingtonstateuniversity/WSUWP-Platform.git wsuwp-platform; cd wsuwp-platform; git submodule init
    - unless: cd /var/www/wsuwp-platform
    - require:
      - pkg: git

wsuwp-dev-update:
  cmd.run:
    - name: cd /var/www/wsuwp-platform; git pull origin master; git submodule update
    - require:
      - pkg: git

wsuwp-db:
  mysql_user.present:
    - name: wp
    - password: wp
    - host: localhost
    - require:
      - service: mysql
      - pkg: mysql
  mysql_database.present:
    - name: wsuwp
    - require:
      - service: mysql
      - pkg: mysql
  mysql_grants.present:
    - grant: all privileges
    - database: wsuwp.*
    - user: wp
    - require:
      - service: mysql
      - pkg: mysql

# After the operations in /var/www/ are complete, the mapped directory needs to be
# unmounted and then mounted again with www-data:www-data ownership.
wsuwp-www-umount-initial:
  cmd.run:
    - name: sudo umount /var/www/
    - require:
      - cmd: wsuwp-dev-initial
    - require_in:
      - cmd: wsuwp-www-mount-initial

wsuwp-www-umount-update:
  cmd.run:
    - name: sudo umount /var/www/
    - require:
      - cmd: wsuwp-dev-update
    - require_in:
      - cmd: wsuwp-www-mount-update

wsuwp-www-mount-initial:
  cmd.run:
    - name: sudo mount -t vboxsf -o uid=`id -u www-data`,gid=`id -g www-data` /var/www/ /var/www/

wsuwp-www-mount-update:
  cmd.run:
    - name: sudo mount -t vboxsf -o uid=`id -u www-data`,gid=`id -g www-data` /var/www/ /var/www/