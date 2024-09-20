USE ROLE SYSADMIN;


CREATE OR REPLACE TABLE GARDEN_PLANTS.VEGGIES.ROOT_DEPTH (
ROOT_DEPTH_ID number(1),
ROOT_DEPTH_CODE text(1),
ROOT_DEPTH_NAME text(7),
UNIT_OF_MEASURE text(2),
RANGE_MIN number(2),
RANGE_MAX number(2)
);


USE WAREHOUSE COMPUTE_WH;

INSERT INTO ROOT_DEPTH (
	ROOT_DEPTH_ID ,
	ROOT_DEPTH_CODE ,
	ROOT_DEPTH_NAME ,
	UNIT_OF_MEASURE ,
	RANGE_MIN ,
	RANGE_MAX 
)

VALUES
(
    3,
    'D',
    'Deep',
    'cm',
    60,
    90
)
;

SELECT * FROM ROOT_DEPTH;

SELECT *
FROM ROOT_DEPTH
LIMIT 1;


-- create table
CREATE TABLE garden_plants.veggies.vegetable_details
(
plant_name varchar(25)
, root_depth_code varchar(1)    
);



select * FROM vegetable_details
where plant_name ='Spinach' 
and root_depth_code ='D';

--delete
DELETE FROM vegetable_details
where plant_name ='Spinach' 
and root_depth_code ='D';