select * from onlineretail 
where CustomerID is not null and Description is not null;

select * from onlineretail
where Quantity>0;

/*top 10 most purchased products*/

select Description, sum(Quantity) as TotalSold
from onlineretail
group by Description
order by TotalSold desc
limit 10;

/* Top customers by purchase volume*/
select CustomerID, sum(Quantity) as TotalUnits
from onlineretail
group by CustomerID
order by TotalUnits desc
limit 10;

/* Total Revenue per product */
select Description, sum(Quantity * UnitPrice) as Revenue
from onlineretail
group by Description
order by Revenue desc
limit 10;

/* PRODUCT RECOMMENDATION */
/* Frequently bought Together products <basic> */

select A.Description as ProductA, B.description as ProductB, count(*) as Frequency
from onlineretail A
join onlineretail B
on A.InvoiceNo = B.InvoiceNo
and A.StockCode <> B.StockCode
group by A.Description, B.Description
order by Frequency desc
limit 20;

/* Frequently Brought together - View */
create view FrequentlyBoughtTogether as 
select A.Description as ProductA, B.Description as ProductB , count(*) as Frequency
from onlineretail A
join onlineretail B
on A.InvoiceNo =B.InvoiceNo
and A.StockCode <> B.StockCode
group by A.Description, B.Description
having count(*) > 50 
order by Frequency desc;

select * from FrequentlyBoughtTogether 
where ProductA= 'WHITE HANGING HEART T-LIGHT HOLDER';

/* Product Recommendations for a Customer */
select f.ProductB as RecommendedProduct, sum(f.Frequency) as Strength
from (
select distinct Description
from onlineretail
where CustomerID=17850
) as c
join FrequentlyBoughtTogether f
on c.Description = f.ProductA
group by f.ProductB
order by Strength desc
limit 5;