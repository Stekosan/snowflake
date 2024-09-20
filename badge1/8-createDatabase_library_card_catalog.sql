use role sysadmin;

// Create a new database and set the context to use the new database
create database library_card_catalog comment = 'DWW Lesson 10 ';

//Set the worksheet context to use the new database
use database library_card_catalog;

// Create Author table
create or replace table author (
   author_uid number 
  ,first_name varchar(50)
  ,middle_name varchar(50)
  ,last_name varchar(50)
);

// Insert the first two authors into the Author table
insert into author(author_uid, first_name, middle_name, last_name)  
values
(1, 'Fiona', '','Macdonald')
,(2, 'Gian','Paulo','Faleschini');

// Look at your table with it's new rows
select * 
from author;

-- JSON table

// JSON DDL Scripts
use database library_card_catalog;
use role sysadmin;

// Create an Ingestion Table for JSON Data
create table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);

//Create File Format for JSON Data 
create file format library_card_catalog.public.json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = FALSE
allow_duplicate = FALSE 
strip_outer_array = TRUE
strip_null_values = FALSE
ignore_utf8_errors = FALSE; 

--check the fileformat
use role accountadmin;
select $1
from @util_db.public.my_internal_stage/author_with_header.json
(file_format => library_card_catalog.public.JSON_FILE_FORMAT);


--Load the data
COPY INTO AUTHOR_INGEST_JSON
FROM @util_db.public.my_internal_stage
files = ('author_with_header.json')
file_format = (format_name=library_card_catalog.public.JSON_FILE_FORMAT);

SELECT * FROM AUTHOR_INGEST_JSON;

select raw_author:AUTHOR_UID
from author_ingest_json;

SELECT 
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;

-- -----------------------------------------------------------------

--lesson 12
--Create new table

// Create an Ingestion Table for the NESTED JSON Data
CREATE OR REPLACE TABLE LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON 
(
  "RAW_NESTED_BOOK" VARIANT
);

--check the fileformat
use role accountadmin;
select $1
from @util_db.public.my_internal_stage/json_book_author_nested.txt
(file_format => library_card_catalog.public.JSON_FILE_FORMAT);

--Load the data
COPY INTO NESTED_INGEST_JSON
FROM @util_db.public.my_internal_stage
files = ('json_book_author_nested.txt')
file_format = (format_name=library_card_catalog.public.JSON_FILE_FORMAT);
-- -------------------------------------------------------------------
-- check
//a few simple queries
SELECT RAW_NESTED_BOOK
FROM NESTED_INGEST_JSON;

SELECT RAW_NESTED_BOOK:year_published
FROM NESTED_INGEST_JSON;

SELECT RAW_NESTED_BOOK:authors
FROM NESTED_INGEST_JSON;

//Use these example flatten commands to explore flattening the nested book and author data
SELECT value:first_name
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN(input => RAW_NESTED_BOOK:authors);

SELECT value:first_name
FROM NESTED_INGEST_JSON
,table(flatten(RAW_NESTED_BOOK:authors));

//Add a CAST command to the fields returned
SELECT value:first_name::VARCHAR, value:last_name::VARCHAR
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN(input => RAW_NESTED_BOOK:authors);

//Assign new column  names to the columns using "AS"
SELECT value:first_name::VARCHAR AS FIRST_NM
, value:last_name::VARCHAR AS LAST_NM
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN(input => RAW_NESTED_BOOK:authors);
