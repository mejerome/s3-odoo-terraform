FROM bitnami/odoo:15
COPY ./custom_addons/* /opt/bitnami/odoo/addons/
RUN /opt/bitnami/python/bin/python3 -m pip install dropbox paramiko --upgrade
RUN /opt/bitnami/python/bin/python3 -m pip install --upgrade pip; /opt/bitnami/python/bin/python3 -m pip install paramiko dropbox 