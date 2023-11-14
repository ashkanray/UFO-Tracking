import requests
import pandas as pd
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import html5lib

base_url = "https://nuforc.org"

# Make a request to the event index page
response = requests.get(base_url + "/ndx/?id=event")
soup = BeautifulSoup(response.text, 'html.parser')

# Find all links to monthly report tables
event_links = [urljoin(base_url, a['href']) for a in soup.select("tr > td > u > a")]

def scrape_table(url):
    
    try:
        res = requests.get(url)  

        if res.status_code == 200:
            soup = BeautifulSoup(res.text, 'lxml')
            table = soup.find(lambda tag: tag.name=='table' and tag.has_attr('id') and tag['id']=="table_1") 
            
            # Obtain every title of columns with tag <th>
            headers = []
            for i in table.find_all(lambda tag: tag.name=='th'):
                title = i.text
                headers.append(title)
            
            # Create a dataframe
            ufo_data = pd.DataFrame(columns = headers)
            
            # Create a for loop to fill mydata
            for j in table.find_all(lambda tag: tag.name=='tr')[1:]:
                row_data = j.find_all(lambda tag: tag.name=='td')
                row = [i.text for i in row_data]
                
                length = len(ufo_data)
                ufo_data.loc[length] = row

            ufo_data.drop(ufo_data.tail(1).index,inplace=True)

            return ufo_data
        
        else:
            print(f"Failed to fetch page: {url} (Status code: {res.status_code})")
    
    except Exception as e:
        print(f"An error occurred: {e}")
    
    return None


monthly_data = [df for df in (scrape_table(url) for url in event_links) if df is not None]

if monthly_data:
    all_data = pd.concat(monthly_data, ignore_index=True)
    
    all_data.to_csv("nuforc_events_all.csv", index=False)

else:
    print("No data was collected.")
