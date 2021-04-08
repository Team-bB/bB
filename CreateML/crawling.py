import BASE
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager


driver = webdriver.Chrome(ChromeDriverManager().install())
query_list = ["공룡상 남자", "여우상 여자", "곰상 여자", "곰상 남자", "사슴상 여자", "토끼상 여자"]

for query in query_list:
    URL = f"https://www.google.com/search?q={query}+연예인&tbm=isch"
    driver.get(URL)

    BASE.scroll_down(driver)

    path = BASE.set_path(query)

    BASE.download_img(driver, path)

driver.quit()