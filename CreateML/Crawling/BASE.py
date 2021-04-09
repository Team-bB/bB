import os, time, urllib.request

def set_path(query):
    path = f'./{query}'
    os.mkdir(path)
    return path

def scroll_down(driver):
    last_height = driver.execute_script("return document.body.scrollHeight")

    SCROLL_PAUSE_TIME = 1

    while True:
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        print("scroll")

        time.sleep(SCROLL_PAUSE_TIME)

        new_height = driver.execute_script("return document.body.scrollHeight")
        if new_height == last_height:
            print("스크롤 완료")
            break
        last_height = new_height


def download_img(driver, path):
       for idx, img in enumerate(driver.find_elements_by_css_selector(".rg_i.Q4LuWd")):
            try:
                img.click()
                img_url = driver.find_element_by_xpath(f"//*[@id=\"Sva75c\"]/div/div/div[3]/div[2]/c-wiz/div/div[1]/div[1]/div/div[2]/a/img").get_attribute("src")
                opener = urllib.request.build_opener()
                opener.addheaders = [('User-Agent','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1941.0 Safari/537.36')]
                urllib.request.install_opener(opener)
                urllib.request.urlretrieve(img_url, path + '/' + str(idx) + ".jpg")
            except:
                print(f"{idx} error")
                pass