CREATE TABLE IF NOT EXISTS masters.TypeOfLists (
  Id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  TypeOfListValue VARCHAR(50) NOT NULL,
  Code VARCHAR(50) NOT NULL,
  DateCreated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
)

CREATE TABLE IF NOT EXISTS masters.Lists (
  Id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  MessageToShow VARCHAR(50) NOT NULL,
  Code INTEGER NOT NULL,
  IdTypeOfList UUID,
  DateCreated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  FOREIGN KEY (IdTypeOfList) REFERENCES masters.TypeOfLists (Id)
)