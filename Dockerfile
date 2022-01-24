FROM bitnami/odoo:15
RUN /opt/bitnami/python/bin/python3 -m pip install dropbox paramiko --upgrade
RUN /opt/bitnami/python/bin/python3 -m pip install --upgrade pip; /opt/bitnami/python/bin/python3 -m pip install paramiko dropbox 