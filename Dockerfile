FROM bitnami/odoo:15
RUN /opt/bitnami/python/bin/python3 -m pip install --upgrade pip
RUN /opt/bitnami/python/bin/python3 -m pip install paramiko dropbox
VOLUME /custom