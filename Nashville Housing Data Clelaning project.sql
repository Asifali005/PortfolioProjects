--cleaning Data in SQL Queries
SELECT *
  FROM [Projects].[dbo].[NashhvilleHousing]

  -- Standardize Date and Format

  SELECT Saledate, CONVERT(Date,Saledate)
  FROM [Projects].[dbo].[NashhvilleHousing]

  Update [Projects].[dbo].[NashhvilleHousing]
  Set Saledate = CONVERT(Date,Saledate)

  Alter table [Projects].[dbo].[NashhvilleHousing]
  Add SaleDateconverted Date
  
  Update [Projects].[dbo].[NashhvilleHousing]
  Set SaleDateconverted = CONVERT(Date,Saledate)



  -- Populate Property Address data

  Select *
  From [Projects].[dbo].[NashhvilleHousing]
  --Where PropertyAddress is null
  order by ParcelID


  Select a.ParcelID, a.propertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
  from  [Projects].[dbo].[NashhvilleHousing] a
  Join [Projects].[dbo].[NashhvilleHousing] b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null

 
 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from  [Projects].[dbo].[NashhvilleHousing] a
  Join [Projects].[dbo].[NashhvilleHousing] b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State )



  Select PropertyAddress
  From [Projects].[dbo].[NashhvilleHousing]
  --Where PropertyAddress is null
 -- order by ParcelID

 Select
 SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
 ,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))as Address

 From [Projects].[dbo].[NashhvilleHousing]



Alter table [Projects].[dbo].[NashhvilleHousing]
  Add PropertySplitAddress Nvarchar(255);
  
  Update [Projects].[dbo].[NashhvilleHousing]
  Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

  
Alter table [Projects].[dbo].[NashhvilleHousing]
  Add Prope
  Alter table [Projects].[dbo].[NashhvilleHousing]
  Add OwnerSplitCity Nvarchar(255);
  rtySplitCity Nvarchar(255);
  
  Update [Projects].[dbo].[NashhvilleHousing]
  Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


  Select *
  from  [Projects].[dbo].[NashhvilleHousing]



  select OwnerAddress 
    from  [Projects].[dbo].[NashhvilleHousing]

select 
PARSENAME (REPlACE(OwnerAddress,',','.'),3),
PARSENAME (REPlACE(OwnerAddress,',','.'),2),
PARSENAME (REPlACE(OwnerAddress,',','.'),1)
from  [Projects].[dbo].[NashhvilleHousing]



Alter table [Projects].[dbo].[NashhvilleHousing]
  Add OwnerSplitAddress Nvarchar(255);
  
  Update [Projects].[dbo].[NashhvilleHousing]
  Set OwnerSplitAddress = PARSENAME (REPlACE(OwnerAddress,',','.'),3)

  Update [Projects].[dbo].[NashhvilleHousing]
  Set OwnerSplitCity = PARSENAME (REPlACE(OwnerAddress,',','.'),2)
  
 Alter table [Projects].[dbo].[NashhvilleHousing]
  Add OwnerSplitState Nvarchar(255);
  
  Update [Projects].[dbo].[NashhvilleHousing]
  Set OwnerSplitState = PARSENAME (REPlACE(OwnerAddress,',','.'),1)

 

 Select * 
 from  [Projects].[dbo].[NashhvilleHousing]



 -- Change Y and N to Yesa and No in "Sold as Vacant" field


 Select Distinct(SoldAsVacant), Count(SoldAsVacant)
 from  [Projects].[dbo].[NashhvilleHousing] 
 Group By SoldAsVacant
order by 2





select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
       END
 from  [Projects].[dbo].[NashhvilleHousing] 


 Update NashhvilleHousing
 SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
       END



-- Remove Duplicates

WITH RowNumCTE As(
Select *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                PropertyAddress,    
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				   UniqueID
				   ) row_num

from  [Projects].[dbo].[NashhvilleHousing] 
--order by ParcelID
)

select *
FROM RowNumCTE
Where row_num > 1
--Order by PropertyAddress

select *
from  [Projects].[dbo].[NashhvilleHousing] 




--Delete Unused Columns



select *
from  [Projects].[dbo].[NashhvilleHousing] 
 



ALTER TABLE [Projects].[dbo].[NashhvilleHousing] 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Projects].[dbo].[NashhvilleHousing] 
DROP COLUMN SaleDate