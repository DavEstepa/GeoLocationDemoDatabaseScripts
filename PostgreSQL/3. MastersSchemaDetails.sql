--TABLE DEFINITIONS

CREATE TABLE IF NOT EXISTS masters.TypeOfLists (
  Id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  TypeOfListValue VARCHAR(50) NOT NULL,
  Code VARCHAR(50) NOT NULL,
  DateCreated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS masters.Lists (
  Id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  MessageToShow VARCHAR(50) NOT NULL,
  Code INTEGER NOT NULL,
  IdTypeOfList UUID,
  DateCreated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  FOREIGN KEY (IdTypeOfList) REFERENCES masters.TypeOfLists (Id)
);

--VIEWS DEFINITIONS

CREATE VIEW masters.ListsView AS
SELECT ML.Id,
       ML.MessageToShow,
       ML.Code,
       MTOL.Code AS TypeOfListCode,
       MTOL.TypeOfListValue,
       ML.DateCreated
FROM masters.Lists AS ML
INNER JOIN masters.TypeOfLists AS MTOL
ON ML.IdTypeOfList = MTOL.Id;


--STORED PROCEDURES DEFINITIONS

CREATE OR REPLACE PROCEDURE masters.sp_get_list_by_typelistcode(
  TypeOfListCodeValue VARCHAR(50),
  OUT p_result refcursor
  )
LANGUAGE plpgsql
AS $$
--Store Procedure name: masters.GetListByTypeListCode
--Author: David.Estepa
--DateCreated: 29.06.23
BEGIN
  open result_p FOR
  SELECT * FROM masters.ListsView
  WHERE TypeOfListCode = TypeOfListCodeValue;
END;
$$;


--INSERT VALUES

--TypeOfLists
--Type of Tours
DO $$
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM masters.TypeOfLists
      WHERE Code = '100'
    )
  THEN
    INSERT INTO masters.TypeOfLists (TypeOfListValue, Code)
    VALUES ('Type of Tours', '100');
  END IF;
END $$;

--Lists

DO $$
DECLARE
  IdTypeOfLists UUID = (SELECT Id FROM masters.TypeOfLists WHERE Code = '100');
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM masters.Lists
      WHERE Code = '100'
    )
  THEN
    INSERT INTO masters.Lists (MessageToShow, Code, IdTypeOfList)
    VALUES ('Type 1 Tour', '100', IdTypeOfLists);
  END IF;

  IF NOT EXISTS (
      SELECT 1
      FROM masters.Lists
      WHERE Code = '200'
    )
  THEN
    INSERT INTO masters.Lists (MessageToShow, Code, IdTypeOfList)
    VALUES ('Type 2 Tour', '200', IdTypeOfLists);
  END IF;

  IF NOT EXISTS (
      SELECT 1
      FROM masters.Lists
      WHERE Code = '300'
    )
  THEN
    INSERT INTO masters.Lists (MessageToShow, Code, IdTypeOfList)
    VALUES ('Type 3 Tour', '300', IdTypeOfLists);
  END IF;
END $$;