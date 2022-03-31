SET SEARCH_PATH = PUBLIC, SANDBOX, RAW, PROC, CLEAN;

-- Accounts Parcels data
COPY RAW.ACCOUNTS FROM PROGRAM 'curl "https://assessor.boco.solutions/ASR_PublicDataFiles/Account_Parcels.csv"' DELIMITER ',' CSV HEADER;

-- Values data
COPY RAW.VALUES FROM PROGRAM 'curl "https://assessor.boco.solutions/ASR_PublicDataFiles/Values.csv"' DELIMITER ',' CSV HEADER;

-- Owner Address data
COPY RAW.OWNERS FROM PROGRAM 'curl "https://assessor.boco.solutions/ASR_PublicDataFiles/Owner_Address.csv"' DELIMITER ',' CSV HEADER;
