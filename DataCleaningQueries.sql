/*

Data Cleaning Queries

*/

Select *
From [Portfolio Project]..NashvilleHousing

------------------------------------------------------------------------------------------------------------------

-------------------- Format SaleDate Column --------------------

Select SaleDate
From [Portfolio Project]..NashvilleHousing

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing 
SET SaleDateConverted = Convert(Date,SaleDate)

Select SaleDateConverted
From [Portfolio Project]..NashvilleHousing

------------------------------------------------------------------------------------------------------------------

-------------------- Populate Property Address Data --------------------

-- Determine null values

Select  a.ParcelID as ap, a.PropertyAddress as apa,  b.ParcelID as bp, b.PropertyAddress as bpa, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


---- Repopulate null values of Property address column

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

------------------------------------------------------------------------------------------------------------------

-------------------- Formatting Property Address into indiviual columns (Address, City, State) --------------------

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) as City
From [Portfolio Project]..NashvilleHousing

Alter Table NashvilleHousing
ADD PropertyAddressOnly nvarchar(255);

Update NashvilleHousing
SET PropertyAddressOnly = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1);

Alter Table NashvilleHousing
ADD PropertyCityOnly nvarchar(255);

Update NashvilleHousing
SET PropertyCityOnly = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress));

Select PropertyAddressOnly, PropertyCityOnly
From [Portfolio Project]..NashvilleHousing


------------------------------------------------------------------------------------------------------------------

-------------------- Formatting Property Address into indiviual columns (Address, City, State) --------------------

Select 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
From [Portfolio Project]..NashvilleHousing

Alter Table NashvilleHousing
ADD OwnerAddressOnly nvarchar(255);

Update NashvilleHousing
SET OwnerAddressOnly = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

Alter Table NashvilleHousing
ADD OwnerCityOnly nvarchar(255);

Update NashvilleHousing
SET OwnerCityOnly = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

Alter Table NashvilleHousing
ADD OwnerStateOnly nvarchar(255);

Update NashvilleHousing
SET OwnerStateOnly = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

Select OwnerAddressOnly, OwnerCityOnly, OwnerStateOnly
From [Portfolio Project]..NashvilleHousing

------------------------------------------------------------------------------------------------------------------


-------------------- Change Y and N to Yes and No	in "Sold as Vacant" field --------------------

Select Distinct(SoldAsVacant), Count(SoldAsVacant) as valueCount
From [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant ,
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
End
From [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant =  Case When SoldAsVacant = 'Y' Then 'Yes'
						 When SoldAsVacant = 'N' Then 'No'
						 Else SoldAsVacant
					End



------------------------------------------------------------------------------------------------------------------

-------------------- Remove Duplicate Values --------------------

-- Find Duplicate Data with CTE

WITH ROWNUMCTE AS(
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
Order by UniqueID
) row_num
From [Portfolio Project]..NashvilleHousing
--Order by ParcelID 
)
Select *
From ROWNUMCTE
Where row_num > 1

-- Delete Data from CTE

WITH ROWNUMCTE AS(
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
Order by UniqueID
) row_num
From [Portfolio Project]..NashvilleHousing
--Order by ParcelID 
)
DELETE
From ROWNUMCTE
Where row_num > 1


------------------------------------------------------------------------------------------------------------------

-------------------- Delete Unused Columns --------------------

Alter table NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
