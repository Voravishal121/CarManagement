-- SQLINES LICENSE FOR EVALUATION USE ONLY
select Salesman,CarBrand,CarClass,Price,FixedCommission,Commission,previousYearAmount as 'Previous Year Amount',
case when previousyearssalesCommission!=0 then (((Price+FixedCommission+Commission)*2)/100) else 0 end  as 'Previous Years Sales Commission',
(Price+FixedCommission+Commission+(case when previousyearssalesCommission!=0 then (((Price+FixedCommission+Commission)*2)/100) else 0 end)) as 'Price + Fixed Commission + Commission + Previous Years Sales Commission'
from (
SELECT carsalesmonthly.Salesman,carbrand.CarBrand,carbrand.CarClass,caprices.Price,previousyearssales.Amount  as PreviousYearAmount,

case when carbrand.CarBrand='Audi' and caprices.Price>25000 then  carcommision.FixedCommission 
else Case when carbrand.CarBrand='Jaguar' and caprices.Price>35000 then  carcommision.FixedCommission 
else Case when carbrand.CarBrand='Land Rover' and caprices.Price>30000 then  carcommision.FixedCommission 
else Case when carbrand.CarBrand='Renault' and caprices.Price>20000 then  carcommision.FixedCommission 
else 0
end
end
end
end as FixedCommission,

case when carbrand.CarBrand='Audi' and caprices.Price>25000 then  ((caprices.Price * carcommision.Commission)/100)
else Case when carbrand.CarBrand='Jaguar' and caprices.Price>35000 then  ((caprices.Price * carcommision.Commission)/100)
else Case when carbrand.CarBrand='Land Rover' and caprices.Price>30000 then  ((caprices.Price * carcommision.Commission)/100)
else Case when carbrand.CarBrand='Renault' and caprices.Price>20000 then  ((caprices.Price * carcommision.Commission)/100)
else 0
end
end
end
end as Commission,

case when carbrand.CarBrand='Audi' and  carbrand.CarClass='A' and previousyearssales.CarClass='A' and previousyearssales.Amount!=0  then  ((caprices.Price * 2)/100)
else Case when carbrand.CarBrand='Jaguar' And carbrand.CarClass='A' and previousyearssales.CarClass='A' and previousyearssales.Amount!=0 then  ((caprices.Price * 2)/100)
else Case when carbrand.CarBrand='Land Rover' And carbrand.CarClass='A' and previousyearssales.CarClass='A' and previousyearssales.Amount!=0 then  ((caprices.Price * 2)/100)
else Case when carbrand.CarBrand='Renault' And carbrand.CarClass='A' and previousyearssales.CarClass='A' and previousyearssales.Amount!=0 then  ((caprices.Price * 2)/100)
else 0
end
end
end
end as previousyearssalesCommission

FROM carsbrand as carbrand
join carprices as caprices on caprices.CarBrand=carbrand.CarBrand and caprices.Class=carbrand.CarClass
join carcommision as carcommision on carcommision.Brand=carbrand.CarBrand and carcommision.Class=carbrand.CarClass
join carsalesmonthly as carsalesmonthly on carsalesmonthly.Brand=carbrand.CarBrand and carsalesmonthly.Class=carbrand.CarClass
left join (Select SalesmanName,CarClass,case when Amount is null then 0 else Amount end as Amount from previous_years_sales 
where Amount>500000 and CarClass='A') as previousyearssales on previousyearssales.CarClass=carbrand.CarClass
and previousyearssales.SalesmanName=carsalesmonthly.Salesman
Group by carsalesmonthly.Salesman,carbrand.CarBrand,carbrand.CarClass,Price,previousyearssales.Amount,carcommision.FixedCommission,carcommision.Commission,previousyearssales.CarClass
) as final
;