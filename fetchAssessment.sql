
USE fetchassessment;
# Explore the Data

/* 
1. Are there any data quality issues present?
     Yes, there are a couple of data quality issues. For instance, within the products csv on the categories column, there are some categories that have a square root
     symbol, which if importing to SQL could cause issues as that character is not ASCII compliant. There are also multiple instances of fields that are essentially the same but are labeled different. For instance,
     in the users table for the gender column, there are two fields 'Prefer Not To Say' and 'Prefer_Not_To_Say'. Those two are saying essentially the same thing but are not labeled as such due to the underlying
     in between the spaces. Within the transaction table in the final_quantity table, instead of a int number 0, there are 'zero' instead, which is not consistent with the other fields in the
     table.
     
2. Are there any fields that are challenging to understand?
     Yes, within the transaction table, there are two columns specifically that are confusing on how they relate to each other, the Final_Quantity and Final_Sale. Whenever Final_Quantity = 'Zero', there is always
     a Final_Sale number attached to it and vice versa. I am assuming that when aggregated based on the receipt ID and the User ID that it will make more sense but on inital viewing of the data, it looks confusing
     to understand since there are some fields when aggregated that have multiple quantities but no sale amount and vice versa.
*/

# Provide SQL queries

## 1. What are top 5 brands by receipts scanned among users 21 and over

select
	p.brand,
	count(distinct t.receipt_id) as receipts
from transactions t
inner join users u on t.user_id = u.id
inner join products p on t.barcode = p.barcode
where 
	year(curdate()) - year(u.birth_date) and
	date_format(curdate(), '%m-%d') >= date_format(u.birth_date, '%m_%d')
group by 
     p.brand
order by 
     receipts desc
limit 5; 

## 2. What are the top 5 brands by sales among users taht have had their account for at least 6 months?

select
     p.brand,
     sum(t.final_sale) as sales
from transactions t
inner join users u on t.user_id = u.id
inner join products p on t.barcode = p.barcode
where     
     datediff(curdate(), u.created_date) >= 180
group by 
     p.Brand
order by
     sum(t.final_sale) desc
limit 5;


/*
## 3. Which is the leading brand in the Dips & Salsa category
     Check excel spreadsheet
     
## Construct an email or slack message that is understandable to a product or business leader who is not familiar
with your day-to-day work. Summarize the results of your investigation

     Hello Manager,
          I have found some interesting information relating to the dataasets that you provided. There are some things that I would like to address before getting into the analysis. For starters, there are some quality issues regarding the data, such as in the transaction dataset, the final_quantity column has 'zero' instead of 0 for values.
          Another instance is in the users table for the gender section, there are multiple cases where there are values that are practically the same but are labeled differently (ex. Prefer_not_to_say & prefer not to say) but could alter my analysis. In the future, these need to be addressed
          for quality assurance so that the analysis could be more accurate.
          
          Despite these hurdles, I found an interesting trend in the data. For instance, when looking at the top 5 brands by receipts scanned by customers who are 21 and over, the top brands are ___, ___, ___, ___, and ___. Because of this insight, we should
          look at these brands and see what products they are advertising to see why they are resonating with this audience. Did these brands run any campaigns that resonated with this audience? I believe that would be a good starting place as to why they are receiving
          so many transactions. To further my analysis, I am going to need data engineering to provide QA on the data to ensure that the data is coming in as expected and to fix the issues of columns be structurally defined and resolving empty or null values. We should be working
          to ensure we gather as much data as possible and if not possible, assign values to those empty values.
          
          I look forward to hearing from you about my analysis.
     Much appreciated,
     Jelani Watkins
*/

