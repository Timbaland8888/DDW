#!/usr/bin/evn python
# -*- encoding:utf-8 -*-
# function: 通过ISBN号去查找当当自营数据
# date:2020-09-21
# Arthor:Timbaland
import time

import requests
import pysnooper
from lxml import html
from tools.console_cmd import *
from fake_useragent import UserAgent

requests.packages.urllib3.disable_warnings()
class DdwBooks():
    Date_Bug =  time.strftime('%Y-%m-%d',time.localtime(time.time()))
    def __init__(self,web_href,sql_cursor):
        self.web_href = web_href
        self.sql_cursor = sql_cursor
    """
        获取当当网自营数据
    """
    @pysnooper.snoop(f"{Date_Bug}.log")
    def get_ddw_key(self,*args,**kwargs):
        input_key = input("请输入查询的商品：")
        # input_key = '9787533255879'
        # input_key = '9787533258122'

        #过滤页码获取当当网自营的详情
        url = f"{self.web_href}/?key={input_key.strip()}&act=input"
        headers = {
            'User-Agent': UserAgent().random
        }
        page = requests.get(url=url, headers=headers)

        tree = html.fromstring(page.text)

        #过滤当当自营的数据提取当当自营的链接
        go_sort = ''.join(tree.xpath('//*[@id="go_sort"]/div/div[@class="bottom"]/ul//*[@dd_name="当当自营"]//@href'))
        go_sort_href = self.web_href + go_sort
        print(f'自营链接地址：{go_sort_href}')

        #如果有当当自营的书本信息，则写入数据库
        if go_sort:
            go_page = requests.get(url=go_sort_href, headers=headers)
            go_tree = html.fromstring(go_page.text)
            bigimge_li_list = go_tree.xpath('//*[@id="search_nature_rg"]/ul/li')

            #ul标签下的普通商品区域
            for n,li in enumerate(bigimge_li_list):
                 #书本详情链接href
                href = ''.join(li.xpath('./p[@class="name"]/a/@href'))

                printDarkBlue(f'{input_key}书本详情链接=====》：{href}\n',FOREGROUND_GREEN)

                #书本封面
                if len(li.xpath('./a/img/@data-original')) > 0:
                    src_imag = ''.join(li.xpath('./a/img/@data-original'))
                else:
                    src_imag = ''.join(li.xpath('./a/img/@src'))
                    print('封面图片====》’：', src_imag)


                book_inof_sql = f""" replace into book_info(id,src_imag,go_sort_href,href,update_date)
                     values(REPLACE(UUID(), '-', ''),'{src_imag}','{go_sort_href}','{href}',now())
                    """
                # print(book_inof_sql)
                self.sql_cursor.query(book_inof_sql)
                # time.sleep(1)
                print('获取详情地址完成！！')
        else:
            printDarkBlue(f'抱歉，没有找到与“{input_key}”相关的商品！\n',FOREGROUND_RED)
            self.get_ddw(self.web_href,self.sql_cursor)

if __name__ == '__main__':
    import codecs
    import configparser
    from con_db.con_mysql import Con_mysql
    cf = configparser.ConfigParser()
    cf.read_file(codecs.open('../conf/config.ini', "r", "utf-8-sig"))
    print(f"开始连接mysql数据库{cf.get('db_mysql', 'mydb')}")

    sql_cursor = Con_mysql(cf.get('db_mysql', 'db_host'), cf.get('db_mysql', 'db_user'), cf.get('db_mysql', 'db_pwd'),
                   cf.get('db_mysql', 'mydb'))

    ddw = DdwBooks(web_href = cf.get('web', 'web_href'),sql_cursor = sql_cursor)
    ddw.get_ddw_key()


