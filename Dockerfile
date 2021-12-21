FROM bitnami/odoo:15
COPY ./custom_addons /opt/bitnami/odoo/custom_addons
RUN /opt/bitnami/python/bin/python3 -m pip install --upgrade pip; /opt/bitnami/python/bin/python3 -m pip install paramiko dropbox 