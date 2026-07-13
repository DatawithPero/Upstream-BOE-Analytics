-- 1. Create Dim_field first (no dependencies)
CREATE TABLE Dim_field (
    FieldID VARCHAR(50) PRIMARY KEY,
    FieldName VARCHAR(100),
    Basin VARCHAR(100),
    Region VARCHAR(100),
    Operator VARCHAR(100),
    Country VARCHAR(100)
);

-- 2. Create Dim_Date (no dependencies)
CREATE TABLE Dim_Date (
    Date DATE PRIMARY KEY,
    Year INT,
    Quarter VARCHAR(10),
    MonthNumber INT,
    MonthName VARCHAR(20),
    MonthYear VARCHAR(50),
    DayOfMonth INT,
    IsMonthEnd VARCHAR(5)
);

-- 3. Create Dim_Well (depends on Dim_field)
CREATE TABLE Dim_Well (
    WellID VARCHAR(50) PRIMARY KEY,
    WellName VARCHAR(100),
    Clean_Well_Code VARCHAR(100),
    WellType VARCHAR(100),
    Status VARCHAR(50),
    FieldID VARCHAR(50) REFERENCES Dim_field(FieldID),
    SpudDate DATE,
    CompletionDate DATE,
    FirstProductionDate DATE
);

-- 4. Create Fact_Production last (depends on Dim_Well and Dim_Date)
CREATE TABLE Fact_Production (
    ProductionID INT PRIMARY KEY,
    WellID VARCHAR(50) REFERENCES Dim_Well(WellID),
    ProductionDate DATE REFERENCES Dim_Date(Date),
    OilVolumeBBL NUMERIC,
    GasVolumeMCF NUMERIC,
    WaterVolumeBBL NUMERIC,
    RealizedOilPrice NUMERIC,
    OperatingCostUSD NUMERIC
);
--Viewing each tables
select * from dim_date;
select *from dim_field;
select * from dim_well;
select * from fact_production;

--Joining Tables
SELECT
    fp.productionid,
    fp.productiondate,
    fp.wellid,
    dw.wellname,
    dw.welltype,
    dw.status,
    df.fieldname,
    df.basin,
    df.region,
    df.operator,
    dd.year,
    dd.quarter,
    dd.monthnumber,
    dd.monthname,
	
    fp.oilvolumebbl,
    fp.gasvolumemcf,
    fp.watervolumebbl,
    fp.realizedoilprice,
    fp.operatingcostusd

FROM fact_production fp

LEFT JOIN dim_well dw
    ON fp.wellid = dw.wellid

LEFT JOIN dim_field df
    ON dw.fieldid = df.fieldid

LEFT JOIN dim_date dd
    ON fp.productiondate = dd.date;
