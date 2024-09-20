create or replace table vegetable_details_soil_type
( plant_name varchar(25)
 ,soil_type number(1,0)
);

create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW 
    type = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = '|' --pipes as column separators
    skip_header = 1 --one header row to skip
    ;

copy into vegetable_details_soil_type
from @util_db.public.my_internal_stage
files = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW );


-- create another file format for LU_SOIL_TYPE.tsv
create file format garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW 
    TYPE = 'CSV'--csv for comma separated files
    FIELD_DELIMITER = ',' --commas as column separators
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' --this means that some values will be wrapped in double-quotes bc they have commas in them
    ;

create file format garden_plants.veggies.L9_CHALLENGE_FF
    TYPE = 'CSV'--csv for comma separated files
    FIELD_DELIMITER = '\t' --tab as column separators
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'

-- check
--The data in the file, with no FILE FORMAT specified
select $1
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv;

--Same file but with one of the file formats we created earlier  
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

--Same file but with the other file format we created earlier
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW );

--Same file but with the other file format we created earlier
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.L9_CHALLENGE_FF);

-- -------------------------------------------
-- create table LU_SOIL_TYPE
use database GARDEN_PLANTS
use schema VEGGIES;
use role SYSADMIN;

create or replace table LU_SOIL_TYPE(
SOIL_TYPE_ID number,	
SOIL_TYPE varchar(15),
SOIL_DESCRIPTION varchar(75)
 );

use role ACCOUNTADMIN;
copy into LU_SOIL_TYPE
from @util_db.public.my_internal_stage
files = ( 'LU_SOIL_TYPE.tsv')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF);

SELECT * FROM LU_SOIL_TYPE;
-- -------------------------------------------

CREATE OR REPLACE table VEGETABLE_DETAILS_PLANT_HEIGHT (
plant_name varchar(50),
UOM varchar(2),
Low_End_of_Range INTEGER,
High_End_of_Range INTEGER
);

--check the file format
--Same file but with one of the file formats we created earlier  
select $1, $2, $3 , $4
from @util_db.public.my_internal_stage/veg_plant_height.csv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

--Load the data
COPY INTO VEGETABLE_DETAILS_PLANT_HEIGHT
FROM @util_db.public.my_internal_stage
files = ('veg_plant_height.csv')
file_format = ( format_name=garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

SELECT COUNT(*) FROM VEGETABLE_DETAILS_PLANT_HEIGHT;
 