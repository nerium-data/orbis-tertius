select column_name 
     , data_type 
     , is_nullable 
     , column_default 
     , (select pg_catalog.col_description(oid, ordinal_position::int)
          from pg_catalog.pg_class 
         where oid = (table_schema ||'.'|| table_name)::regclass
       ) as column_comment
  from information_schema.columns
 where table_schema = :schm
   and table_name = :tbl
 order by table_name 
        , ordinal_position;
