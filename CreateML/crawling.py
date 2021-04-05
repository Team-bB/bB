import os
from selenium import webdriver

driver = webdriver.Chrome("./chromedriver")

query_list = ["공룡상", "강아지상", "고양이상", "사막여우상", "곰돌이상", "늑대상", "개구리상", "사슴상", "토끼상"]

for query in query_list:
    path = f'./{query}'
    os.mkdir(path)

    URL = f"https://www.google.com/search?q={query}+연예인&tbm=isch"
    driver.get(URL)

    for idx, element in enumerate(driver.find_elements_by_class_name("rg_i")):
        element.screenshot(path + "/"+ str(idx) + ".png")

