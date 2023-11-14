import pandas as pd

#Read csv and create df
df = pd.read_csv('nuforc_events_all.csv')

#Drop columns that are irrelevant
df = df.drop(['Link', 'Image'], axis=1)

# Convert the 'Occurred' column to datetime
df['Occurred'] = pd.to_datetime(df['Occurred'], format='%m/%d/%Y %H:%M', errors='coerce')

#Remove rows that fall before this daterange
start_date = pd.to_datetime('01/01/1678', format='%m/%d/%Y')
df = df[(df['Occurred'] >= start_date)]

# Extract Year, Month, and Day
df['Year'] = df['Occurred'].dt.year
df['Month'] = df['Occurred'].dt.month
df['Day'] = df['Occurred'].dt.day


df.to_csv("nuforc_clean.csv", index=False)
