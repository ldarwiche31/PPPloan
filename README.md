# PPPloan
Analysis of SBA's Paycheck Protection Program loans during the early pandemic.

As someone passionate about business and finance reporting, I wanted to use a dataset that aligned with such interests. Taking into account the current pandemic we are living through, I thought it would be interesting to examine the relief given to businesses through the Small Business Administration’s Paycheck Protection Program (PPP) loans. My final article can be found here: https://storymaps.arcgis.com/stories/6969b1d86cd84ec29d26cccdf5f7b09d.

## Data Cleaning

The dataset I used can be located here: https://data.sba.gov/dataset/ppp-foia. The dataset consists of 200,000 entries of PPP loan approvals in the state of Illinois from early April to early August. The dataset includes information on city, zip code, loan amount, loan approval date, jobs reported, gender, race/ethnicity, lender, non-profit status, veteran status, business type, and NAISC code. As the dataset was incredibly large, I decided focusing on specifically Chicago would allow for more concentrated insight and interview material. The following code shows the manipulation I did to reduce the dataset into just Chicago. As data not included was filled as “Unanswered,” I needed to not only refine the dataset but also put it in a form that would recognize “Unanswered” as NA data.

After looking at some graphs in Tableau, I realized that some that were labeled Chicago in fact were not in the Chicago area as the zip placed them in other parts of Illinois. Thus, I decided to instead filter by zip code. In viewing this data in R, I realized that there was some error on the part of the SBA as two observations had congressional districts that were not in IL. I decided to remove these two observations. This dataset has 49,611 observations which was a little less intimidating than the original amount.

I then added information from the NAICS code, which is a government distinction between different types of businesses. I decided to trim down the NAICS code into the two-digit industry code and use that for additional context to the businesses being provided the PPP loans.

## Questions

I had a few guiding questions that I wanted to think about going in:
1. Are certain groups of individuals likely to get more money from the Paycheck Protection Program?
2. Are certain lenders more prevalent in certain areas? Which banks handled the most money? Did more local lenders seem to prefer to lend to certain demographics or areas? How did this differ from the US population?
3. How did the type of business affect the money received?

## Exploratory Data Analysis

I was curious about a few observations about loans over time. (1) How many loans were being approved over time (2) How much was being given out in loans over time. The shapes tell us that no particular day seemed to have a greater amount of higher loans than others as the shapes are generally similar.

![](images/loanovertime.png)

![](images/loandollaramount.png)

I also wanted to look at the average loan amount per area. What was very interesting about this graph was that the North Side of Chicago had a significantly higher average than those in the south side.

![](images/averageloanzip.png)

I wanted to do some preliminary analysis into some distributions (numerically) of different variables to try and answer my first question. The ones I thought would be very interesting, gender and race/ethnicity, unfortunately caused a bit of trouble. Some initial tables showed me that most observations did not include such data. Only 5% of observations included race/ethnicity data and 12% included gender. Thus, while I can use other data and compare to demographic data of Chicago in general (i.e. what are average loan amounts by zip code in comparison to the zip codes average income or in comparison to the Black and Brown population proportions), the specific data in this set would not be useful. This is something I considered as I decided how to build my final visualizations and how much inference I wanted to apply. For that reason, I decided not to use demographic data.

After some brief looks into those criteria, I began to look at some of the information that was more complete: lender, jobs reported, business type, and industry codes. 

![](images/nationallenders.png)

Though some of the big actors were also big in Chicago, there were a few notable differences. For instance, the second largest number of loans came from Kabbage, Inc. in Chicago, while it did not break the top 15 nationally. Additionally,  it appears that some of the larger lenders on the national list had even more authority in the Chicago area. While JPMorgan Chase loaned 4.4% of loans nationally, they handled almost 12% of all PPP loans from this first round in the Chicago area. Some of the banks with bigger shares of total authority that did not appear on the national list appear to be Chicago/Midwest based: Byline Bank, First Midwest Bank, TCF National Bank (more Midwest base), Lakeside Bank, and International Bank of Chicago. I was interested to see if these banks seemed to lend to certain areas more than the other larger banks. Businesses in the north side seemed to have access to more lenders than those on the south side, in general. 

![](images/countlender.png)

In comparison, here is a map of how many loans were dispersed throughout Chicago:

![](images/numloans.png)

What was very interesting was that though there were a large amount of loans dispersed 60620, 60619, and 60628, there was less diversity in lenders. This led me to another question: who was dominating lending in these areas?

I was interested in seeing how this broke up by the Chicago/Midwest based big lenders versus the big 15 that nationally had a lot of the total loan authority. I realized after looking at the visualizations that one of the reasons why these maps might look so similar was because the number of lenders in the smaller percentage areas had more lenders that probably diluted the authority of these two groups I looked at.

![](images/locallend.png)

![](images/nationallend.png)

I decided to go back to my original question of how lenders by individual lender vary by zip code. I needed to do some maneuvering to obtain a dataset that gave me for each zip code the lender with the most loans. I thought this might provide some insight that the previous two visualizations couldn't offer.

![](images/Lendermax.png)

This graphic was so interesting to me, and I knew I wanted to use it in my story. The divide between the North and South is fairly stark as the lenders seem segregated to certain areas. I decided I wanted to look at this in my story and do some research into the marketing tactics of specifically Kabbage, Inc. and Cross River Bank. I also wanted to see if they had any programs that were focused on these areas.

With this in mind, I shifted my attention to business type. I created the following visualization to try and gain some insight. I first created a box plot that showed each business type and the loan distributions.

![](images/bustypebox.png)

I was aware that size of the company might be a factor among why certain groups (sole proprietors, individual contractors, and self-employed people) may have lower loan averages/medians. Thus, I decided to look at some regression lines on scatterplots of job size and loan amount, grouped by business type. I removed any extreme outliers from the data to avoid any values that would vastly change the regression. I also removed to categories that had very few points: non-profit childcare center and joint venture.

![](images/loanjobbus.png)

The regression trend lines are much flatter for independent contractors, sole proprietors, and self-employed individuals. Thus, even when additional jobs were added in those business types, the impact of another person on payroll increased the average loan amount received by much less than corporations and LLCs. I was interested in this question particularly: what made these groups less likely to receive more money. In my story, I explore this using visualizations as well as outside reporting context through Lotika Pai, managing director at the Women's Business Development Center Access to Capital group.

I decided to make a similar box plot to the business types box plot to again look at the distribution.

![](images/industryboxplot.png)

The transportation and warehousing industry seemed to have the lowest median loan amount while still having a vast array of outliers. The industries were also something I wanted to explore in my story. I made to bar charts whose information I wanted to combine into one:

![](images/avgindustry.png)

![](images/totindustry.png)

Looking at the two, the information is valuable in each. However, layering the average loans over the total will be difficult because of how much higher the sum of all loans is in comparison to the individual. As a result, I was deciding how to display such information and realized that perhaps average loan amount and count gives a lot of valuable information. In addition, having a median line to show median as there are so many outliers may also be helpful.

I decided that a separate graph that perhaps shows the makeup of all the PPP loans would perhaps fit better. Since some portions are incredible small or were not given, I decided to create an other category that encompassed those categories: null, management of companies, mining, public administration, and utilities. Though pie charts make it difficult to detect small differences, I wanted some way to show the composition of PPP loans by industry as a part of the whole. 

## Building the Maps
Because we were encouraged to host the final piece on a website, I decided to use ArcGIS's StoryMap software to host both my story and to enable me to add interactivity to my visualization. A lot of the most interesting data I found was through looking at maps; thus, I decided to use the ArcGIS interface to create interactive maps alongside my narrative.

The first challenge was seeing how to combine existing data from ArcGIS online into my dataset as unlike Tableau, ArcGIS requires shapefiles in order to draw zip code boundaries. I played around, attempting to merge layers which proved unsuccessful but through use of a join features command, I was able to add my data to existing shapefile data.

Using this technique, I was able to add my information I wanted. However, because the dataset was quite large, I had to create individual datasets that included the map data I was interested in.

I then created choropleth maps that looked at this data across the zip codes: average loan amount, total number of loans, and total number of unique lenders. I chose the color scheme that seemed the most similar to Tableau's default since Tableau has done a lot of research into what color schemes are best for those who are color blind as well as what colors can be perceived well.

Unfortunately, the online ArcGIS software does not give you the option to choose colors so for the other graphs I made that were of categorical data (the largest lender in each area and the industry that dominated each area), I decided to go with the default which seemed when I put it through Chromatic Vision Simulator to check to see the differences, and all the colors were fairly easy to perceive as different. I used the dataset I made earlier (MaxLender) to make the largest lender choropleth map and did an industry map as well.

While these graphs did have a bit of chart junk (having the rest of the map rather than just the area if interest and some labels that you can not control), I think having the interactive piece makes the trade-off worth it. Being able to annotate as well as include some summary data that does not clutter the map but instead is available through selection gives nice additional context. Unfortunately, legends have to be clicked on which is a tad annoying but hard to work around.

I decided in addition to the maps in Arc GIS, I created two charts to include as well. The first shows the distribution of loans for businesses that are independent contractors, sole proprietors, and self-employed individuals through a boxplot. I added some annotations because not everyone knows how to read a boxplot thus adding some chart-junk for the sake of understanding. The visualization is very expressive as it shows the raw data incredibly well, a reason why I chose the boxplot. I used Tableau to build the plot and decided to put annotations in afterward in Preview.

![](images/boxplot.png)

I then decided to build upon the visualization I included in the exploratory analysis. I decided in the end that the more interesting thing to see was the share of the total loans given as most of the story deals with averages, I thought a more holistic approach to the industry question would be better suited. I sorted by total loan amount and added labels for the counts in preview. The visualization is fairly effective as the position/length encodings of the bars are easily perceived in comparison to each other. It also fairly expressive as it includes data without imposing untrue conclusions. The only excess data-ink are a result of using bars, but I thought using points would cause someone to think about linear relationships rather than amount of a whole.

![](images/total_loan_indus.png) 
