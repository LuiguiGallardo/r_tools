from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

from selenium import webdriver   # for webdriver
from selenium.webdriver.support.ui import WebDriverWait  # for implicit and explict waits
from selenium.webdriver.chrome.options import Options  # for suppressing the browser

option = webdriver.ChromeOptions()
option.add_argument('headless')
driver = webdriver.Chrome('/Users/luigui/Desktop/tmp_61/chromedriver', options=option)

#driver = webdriver.Chrome('./chromedriver')
form_url = "https://egov.uscis.gov/casestatus/landing.do"

driver.get(form_url)

element = driver.find_element(By.ID, "receipt_number")

# I-765
element.send_keys("IOE0915938841")
print(element)

submit = driver.find_element(By.NAME, "initCaseSearch")
submit.click()

status = driver.find_elements(By.TAG_NAME, 'p')

for item in status:
    if "Jul" in item.text:
        print(item.text)
        f = open("/Users/luigui/Desktop/status_uscis_update.txt", "x")
        f.write(item.text)
        f.close()

driver.close()
driver.quit()
