select table_schema
     , table_name
  from information_schema.tables 
 where table_schema = any(%(schemas)s) 
 order by 1;
