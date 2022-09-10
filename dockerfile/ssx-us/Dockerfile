FROM odoo:15
RUN echo "proxy-mode = True \n\ xmlrpc_interface = 127.0.0.1 \n\ netrpc_interface = 127.0.0.1" >> /etc/odoo/odoo.conf
RUN echo "dbfilter = ^dev-uscorp$" >> /etc/odoo/odoo.conf
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install paramiko dropbox
