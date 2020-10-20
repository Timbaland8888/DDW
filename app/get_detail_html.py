#!/usr/bin/evn python
# -*- encoding:utf-8 -*-
# function: get isbn detail
# date:2020-10-16
# Arthor:Timbaland

import time

import pysnooper
import re
import requests
from lxml import html
from selenium import webdriver
from con_db.con_mysql import Con_mysql
from tools.console_cmd import *

requests.packages.urllib3.disable_warnings()

class DdwBooksDetail():
    Date_Bug = time.strftime('%Y-%m-%d',time.localtime(time.time()))
    def __init__(self,sql_cursor):
        self.sql_cursor = sql_cursor

    @pysnooper.snoop(f"{Date_Bug}.log")
    def get_field(sefl,*args,**kwargs):

        #查询详情书本的链接
        href_sql = """ select id,href,src_imag from book_info"""
        hrefs = sefl.sql_cursor.query(href_sql)
        print(hrefs)
        for link in hrefs:
            # print(link[0],link[1],link[2])
            print('')
            printDarkBlue(f"开始读取详情数据，加载缓存。。。。。\n",FOREGROUND_BLUE)
            url = f'{link[1]}'
            try:
                # 隐藏浏览器
                chrome_opts = webdriver.ChromeOptions()
                chrome_opts.add_argument("--headless")

                browser = webdriver.Chrome(options=chrome_opts)
                # wait = WebDriverWait(browser, 15)
                browser.get(url)
                out_html = browser.page_source
                # print(browser.page_source)
                tree = html.fromstring(out_html)

                """
                获取书名#product_title
                """
                product_title_xpath = tree.xpath('//*[@id="product_info"]/div/h1/text()')
                product_title = ''.join(product_title_xpath).strip()
                print('书本名称：',product_title)


                """
                获取书名作者#product_author
                """
                product_author_xpath = tree.xpath('//*[@id="product_info"]/div/span[@dd_name="作者"]/a//text()')

                if product_author_xpath:
                        product_author = ' '.join(product_author_xpath)
                        print('作者：',product_author)

                """
                获取书名出版社#publishing_company_name
                """
                publishing_company_name_xpath = tree.xpath('//*[@id="product_info"]/div/span[@dd_name="出版社"]/a//text()')
                if publishing_company_name_xpath:
                    publishing_company_name = ''.join(publishing_company_name_xpath)
                    print('出版社：',publishing_company_name)

                """
                获取书名出版社#publish_date
                """
                publish_date_xpath = tree.xpath('//*[@id="product_info"]/div/span//text()')
                # print(publish_date_xpath)
                if publish_date_xpath:
                    for pub_list in publish_date_xpath:
                        if "出版时间" in pub_list:
                            publish_date = pub_list.split('出版时间:')[-1].split('\xa0')[0]
                            print('出版时间:',publish_date)

                """
                获取书名出版社#price
                """
                price_xpath = tree.xpath('//*[@id="pc-price"]/div/div/p/text()')
                if price_xpath:
                    price = price_xpath[-1]
                    print('价格：',price)

                """
                获取书名出版社#ISBN
                """
                isbn_no_xpath = tree.xpath('//*[@id="detail_all"]/div/ul/li/text()')
                if isbn_no_xpath:
                    for isbn_no_li in isbn_no_xpath:
                        if "ISBN" in isbn_no_li:
                            isbn_new_no = isbn_no_li.split('国际标准书号ISBN：')[-1]
                            print('ISBN号:',isbn_new_no)

                """
                获取书名内容简介introduce
                """
                # p标签下面的内容
                introduce_str = ''.join(tree.xpath('//*[@id="detail"]/div[@id="content"]/div[@class="descrip"]//text()'))

                pre = re.compile('>(.*)<')
                retouve_str = ''.join(pre.findall(introduce_str))

                if retouve_str:
                    content_introduce = retouve_str.strip()
                else:
                    content_introduce = introduce_str.strip()
                print('内容简介:', content_introduce)


                """
                书名作者简介
                """
                author_introduce_str = ''.join(
                    tree.xpath('//*[@id="detail"]/div[@id="authorIntroduction"]/div[@class="descrip"]//text()'))

                retouve_str = ''.join(pre.findall(author_introduce_str))
                if retouve_str:
                    author_introduce = retouve_str.strip()
                else:
                    author_introduce = author_introduce_str.strip()
                print('书名作者简介:', author_introduce)

                """
                编辑推荐介绍 和 编辑推荐介长图
                """
                abstract_info_span = tree.xpath('//*[@id="detail"]/div[@id="abstract"]/div[@class="descrip"]//text()')
                abstract_info = ''.join(abstract_info_span).strip()
                print('编辑推荐：',abstract_info)

                abstract_info_pic = ''.join(tree.xpath('//*[@id="detail"]/div[@id="abstract"]/div[@class="descrip"]//*/@src'))
                print('编辑推荐长图：', abstract_info_pic)

                """
                产品特色长图 
                """
                feature_pic = ''.join(tree.xpath('//*[@id="detail"]/div[@id="feature"]/div[@class="descrip"]//*/@src'))
                if not feature_pic:
                    feature_pic = ''.join(
                        tree.xpath('//*[@id="detail"]/div[@id="feature"]/div[@class="descrip"]//*/@data-original'))
                print('产品特色长图：', feature_pic)

                """
                书摘插画
                """
                attachImage = ''.join(tree.xpath('//*[@id="detail"]/div[@id="attachImage"]/div[@class="descrip"]//*/img/@data-original'))
                if not attachImage:
                    attachImage = ''.join(tree.xpath(
                    '//*[@id="detail"]/div[@id="attachImage"]/div[@class="descrip"]//*/img/@src'))

                print('书摘插画：', attachImage)


                """
                    提取字段sql语句到mysql数据库
                """
                tbook_sql = f""" REPLACE INTO `t_book` 
                        VALUES (REPLACE(UUID(), '-', ''), '{link[0]}','{product_title}','{product_author}','{publishing_company_name}','{isbn_new_no}','{publish_date}','{content_introduce}','{price}','{author_introduce}','{abstract_info}','{abstract_info_pic}','{feature_pic}','{attachImage}','{link[2]}',now())
            
                """
                # print(tbook_sql)
                sefl.sql_cursor.query(tbook_sql)
            except Exception as e:
                print(e)
        print('详情数据已加载到数据库。。。')
        flag =True
        return flag
if __name__ == '__main__':
    import codecs
    import configparser
    print('开始连接mysql数据库ddw')
    cf = configparser.ConfigParser()
    cf.read_file(codecs.open('../conf/config.ini', "r", "utf-8-sig"))
    sql_cursor = Con_mysql(cf.get('db_mysql', 'db_host'), cf.get('db_mysql', 'db_user'), cf.get('db_mysql', 'db_pwd'),
                  cf.get('db_mysql', 'mydb'))
    print('数据库连接成功！！')
    ddw = DdwBooksDetail(sql_cursor = sql_cursor)
    ddw.get_field()

























