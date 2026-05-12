CREATE TABLE "Cleaned_CountryMetaData"(
    "Country Code"                   VARCHAR(3) NOT NULL,
    "Country Name"                   TEXT,
    "Long Name"                      TEXT,
    "Short Name"                     TEXT,
    "Region"                         TEXT,
    "Income Group"                   TEXT,
    "Lending category"               TEXT,
    "External debt Reporting status" TEXT,
    "2-alpha code"                   VARCHAR(2),
    "WB-2 code"                      VARCHAR(2),
    PRIMARY KEY ("Country Code")
);


CREATE TABLE "Cleaned_IDS_SeriesMetaData"(
    "Series Code"      VARCHAR(50) PRIMARY KEY,
    "Series Name"      TEXT,
    "Short definition" TEXT,
    "Topic"            TEXT
);


CREATE TABLE "Cleaned_International_Debt_Analysis"(
    "Country Name"     VARCHAR(100),
    "Country Code"     VARCHAR(3)  NOT NULL,
    "Series Name"      TEXT,
    "Series Code"      VARCHAR(50) NOT NULL,
    "Year"             INTEGER     NOT NULL CHECK ("Year" BETWEEN 2000 AND 2024),
    "Debt"             NUMERIC(20,2),
    "Region"           VARCHAR(100),
    "Income Group"     VARCHAR(100),
    "Lending category" VARCHAR(100),
    "System of trade"  VARCHAR(100),
    PRIMARY KEY ("Country Code", "Series Code", "Year"),
    FOREIGN KEY ("Country Code") REFERENCES "Cleaned_CountryMetaData"("Country Code")
        ON DELETE CASCADE ON UPDATE CASCADE

);

SELECT * FROM "Cleaned_International_Debt_Analysis";
SELECT * FROM "Cleaned_IDS_SeriesMetaData";
SELECT * FROM "Cleaned_CountryMetaData";

