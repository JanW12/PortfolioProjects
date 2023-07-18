# PortfolioProjects
Tools used: Excel, Power BI and Power Query, Python(jupyter) in VSCode, MySQL\
In free time I did some Data Analysis projects, some bigger, some smaller, the smaller ones i put in the "Learning_Projects" folder. I will briefly introduce every project. I divided everything into folders with raw datasets and code/file

# Dashboard_For_Company (Power Bi)
Data to this project I loaded to my localhost in MySQL and then connected through Power BI and linked the table relationships. I cleared data mainly in BI'Power Query. In MySQL using queries, while checking and analyzing the data and making sure how the cleaning should look like, I noticed that: there were negative values and zeros in the column with the amount of products sold, there were cities in the column market_name that belong to the market outside of India even though the company sells only in India, there was a currency USD that needs to be converted into INR additionally currencies for some reason duplicated giving as many as 4 currencies "INR", INR\r", "USD","USD\r", all these things need to be filtered out during cleaning and also add a column converting USD to INR (I did it statically but normally it should be done dynamically by referring to the table with the dates of the exchange rates). It turns out that most of the rows have "INR\r" so I assumed that this is the correct version, filtered out "INR" and "USD" because it would be very difficult to analyze (unfortunately I couldn't fix it with "find and replace so I deleted these rows"). After cleaning I made 3 pages of visual analysis what is visible in the file. This one project I did in polish but the rest is in english

# Survey_Breakdown_Dashboard (Power_Bi)
The data needed a lot of cleaning and adjustment to be ready for use, I did it in Power Query after I loaded the data into Power BI with an xlsx file. The main problem was the columns with answers where "other" appeared, it had to be separated to make filtering easier, all steps are visible and saved in Power BI and its Power Query. It was also necessary to take care of the column with annual salary, because its form was not useful so I changed the range to the average of earnings from this range. After cleaning I took care of visualization

# Performance_Dasboard (Excel)
Data did not need much cleaning, I focused on pivot tables and dashboard. I added a macro that refreshes the entire file whenever something is done

# Movies_Correlation (Notebook)
I tried to find correlations on movies dataset, more comments and steps are in the file. I used Anaconda, Jupyter, python. The biggest correlation has gross-budget

# COVID_Data_Exploration (MySQL)
Imported to MySQL, it's mainly analysis but only in MySQL Workbench by using queries, more comments and steps are in the script

# Web_Scraper (Notebook)
This code connects to the given product page (on amazon) and then reads the html and extracts the name of the product and its price to save it to excel in csv format, the background program is set to repeat every hour.

# NashvilleHousing_Data_Cleaning (MySQL)
Imported to MySQL and mainly cleaning in Workbench by using SQL, comments and steps are in script

# Learning_Projects
Description is in folder "Learning_Projects"
