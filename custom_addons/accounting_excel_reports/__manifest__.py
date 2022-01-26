# -*- coding: utf-8 -*-
# License: Odoo Proprietary License v1.0

{
    'name': 'Odoo 15 Accounting Excel Reports',
    'version': '2.0.0',
    'category': 'Invoicing Management',
    'summary': 'Accounting Reports In Excel For Odoo 15',
    'sequence': '5',
    'live_test_url': 'https://www.youtube.com/watch?v=pz83Q9dobOM',
    'author': 'Odoo Mates',
    'company': 'Odoo Mates',
    'maintainer': 'Odoo Mates',
    'support': 'odoomates@gmail.com',
    'license': "OPL-1",
    'price': 25.00,
    'currency': 'USD',
    'website': '',
    'depends': ['accounting_pdf_reports'],
    'images': ['static/description/banner.png'],
    'demo': [],
    'data': [
        'wizards/account_excel_reports.xml',
        'reports/report.xml',
    ],
    'installable': True,
    'application': True,
    'auto_install': False,
    'assets': {
        "web.assets_backend": [
            "accounting_excel_reports/static/src/js/action_manager_report.esm.js",
        ],
    },
}
