#!/usr/bin/evn python
# -*- encoding:utf-8 -*-
# function: get isbn detail
# date:2020-10-16
# Arthor:Timbaland
import codecs
import argparse
import configparser
from con_db.con_mysql import Con_mysql
from app.get_key_html import DdwBooks
from app.get_detail_html import DdwBooksDetail
from tools.console_cmd import *

#主程序进程
def main(*args):

    #获取当当自营数据
    while True:
        ddw_key.get_ddw_key()
        ddw_detail.get_field()


if __name__ == '__main__':
    cf = configparser.ConfigParser()
    cf.read_file(codecs.open('conf/config.ini', "r", "utf-8-sig"))
    sql_cursor = Con_mysql(cf.get('db_mysql', 'db_host'), cf.get('db_mysql', 'db_user'), cf.get('db_mysql', 'db_pwd'),
                  cf.get('db_mysql', 'mydb'))

    printDarkBlue(f"开始连接mysql数据库{cf.get('db_mysql', 'mydb')}\n",FOREGROUND_GREEN)

    ddw_key = DdwBooks(web_href=cf.get('web', 'web_href'), sql_cursor=sql_cursor)

    ddw_detail = DdwBooksDetail(sql_cursor=sql_cursor)
    main(ddw_key,ddw_detail)



