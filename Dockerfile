# DOCKER-VERSION 1.2.0
# TO tinyerp/ubuntu-openerp:7.0
FROM docker.io/ubuntu:14.04

# Install "openerp.deb"
# Create PostgreSQL user "openerp"
# Untar configuration "/etc/supervisor/conf.d/openerp.conf"
RUN apt-key adv --keyserver pool.sks-keyservers.net \
    --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 \
 && /bin/mv /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.list \
 && echo deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.4 \
    > /etc/apt/sources.list.d/pgdg.list \
 && mv /usr/bin/ischroot /usr/bin/chroot.orig \
 && ln -s /bin/true /usr/bin/ischroot \
 && export DEBIAN_FRONTEND=noninteractive LANG && apt-get update \
 && apt-get install -y --no-install-recommends dropbear language-pack-en \
    rsync supervisor && echo "root:password" | chpasswd \
 && update-locale LANG=en_US.UTF-8 && . /etc/default/locale \
 && apt-get install -y postgresql-9.4 postgresql-contrib-9.4 \
 && echo H4sIADcyi1MCA+3UXWqEMBAHcJ89hRdYEzUILexbb1GK+JGVgBp3kiz09o12Xbu20Iey \
 BeH/ewmZBAfJzDSkx0qWFNd6OAWPwb1ciHn1tivPeBokaSbSPBEizQKecMHzIAr2ZPtzO/E6km6p \
 7J+bayG8hbXu+3JoomPEpK3ZcsDIDWGjSNZW0/v2NHRGkg+S1jYsndXGlmR9wJKTc4DkXYjk57cK \
 YxtJtIT9TjtbdLo9qU5OWS4+td8y40ZJF2U03ZLGPh4G8Aejf6jWP825e9wE+K3/RZat/T/dSxLu \
 xwD6/z/7fy2EuwngjO8+VbH1mD3FglVquIWiw8u1S7/f60s1RIc6mmpLtcXU08d5bvxwj21qcRkp \
 S/jhY+VLfgwWAAAAAAAAAAAAAAAAAAAA2I0Pl2OMiAAoAAA=                             \
  | base64 -di | tar xz -C /etc/supervisor/conf.d \
 && echo deb http://nightly.odoo.com/7.0/nightly/deb/ ./ \
    > /etc/apt/sources.list.d/openerp-70.list \
 && export DEBIAN_FRONTEND=noninteractive LANG=en_US.UTF-8 \
 && apt-get update && apt-get install -y --allow-unauthenticated openerp \
 && chown openerp:openerp /var/lib/openerp \
 && service postgresql start && su - postgres -c "createuser -d openerp" \
 && echo H4sIACx6i1MCA+3SwUrDQBAG4JzzFHkA66ZN2oLQg4eiB7WgeBIpMZnWQLMTZnfz/E5j \
 Ipi7YOH/Lsv8P1kysNySJWmvS7aH6I+kapXn/ammZ5pnaTRfZPlitc7Xy2WUztNM6yS6JNPlLsRb \
 K3yUornh74fwHpfcNIWtkk1ighPzUVszdDNH0pEkszIx5MsxntT9U4qDDnrFUMVku1rYNmS9pq8v \
 2+fNUF097O6ebh+3P/P9TgfzyQ2NF8dF8Ox8IedvvQTqA6FfkVBVC5V+73xFImOsEwe/P/HxUJ/o \
 vFRXiNHRuNDq/9aOZbqAtnEEAAAAAAAAAAAAAAAAAAAAAADwz30BmbMKRgAoAAA=             \
  | base64 -di | tar xz -C /etc/supervisor/conf.d \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Declare volumes for data
VOLUME ["/var/log/supervisor","/var/lib/openerp", "/var/lib/postgresql"]

# Expose HTTP port
EXPOSE 8069

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
