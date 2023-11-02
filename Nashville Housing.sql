Select *
From PortfolioProject. dbo.[NashvilleHousing ]

--Standardize Date Format
Select SaleDate2, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.[NashvilleHousing ]

Update PortfolioProject.dbo.[NashvilleHousing ]
SET SaleDate = CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDate2 Date;

Update PortfolioProject.dbo.[NashvilleHousing ]
SET SaleDate2 = CONVERT(Date,SaleDate)


--Populate Property Address Data
Select *
From PortfolioProject.dbo.[NashvilleHousing ]
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[NashvilleHousing ] a
Join PortfolioProject.dbo.[NashvilleHousing ] b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET Propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[NashvilleHousing ] a
Join PortfolioProject.dbo.[NashvilleHousing ] b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out address into Individual Columns (Address, City, State)
Select PropertyAddress
From PortfolioProject.dbo.[NashvilleHousing ]
--Where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.[NashvilleHousing ]



Alter Table PortfolioProject.dbo.[NashvilleHousing ]
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.[NashvilleHousing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table PortfolioProject.dbo.[NashvilleHousing ]
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.[NashvilleHousing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select *
From PortfolioProject.dbo.[NashvilleHousing ]



Select OwnerAddress
From PortfolioProject.dbo.[NashvilleHousing ]

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.[NashvilleHousing ]



Alter Table PortfolioProject.dbo.[NashvilleHousing ]
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.[NashvilleHousing ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table PortfolioProject.dbo.[NashvilleHousing ]
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.[NashvilleHousing ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table PortfolioProject.dbo.[NashvilleHousing ]
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.[NashvilleHousing ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.[NashvilleHousing ]
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From PortfolioProject.dbo.[NashvilleHousing ]


Update PortfolioProject.dbo.[NashvilleHousing ]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End


-- Remove Duplicates

WITH RowNumCTE AS(
Select*,
    ROW_NUMBER() Over(
	Partition By ParcelID,
	             PropertyAddress,
				 SalePrice,
				 LegalReference
				 Order by 
				       UniqueID
				 ) row_num
From PortfolioProject.dbo.[NashvilleHousing ]
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
order by PropertyAddress


WITH RowNumCTE AS(
Select*,
    ROW_NUMBER() Over(
	Partition By ParcelID,
	             PropertyAddress,
				 SalePrice,
				 LegalReference
				 Order by 
				       UniqueID
				 ) row_num
From PortfolioProject.dbo.[NashvilleHousing ]
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1



-- Delete Unused Columns

Select *
From PortfolioProject.dbo.[NashvilleHousing ]

Alter Table PortfolioProject.dbo.[NashvilleHousing ]
Drop Column OwnerAddress, TaxDistrict, SaleDate