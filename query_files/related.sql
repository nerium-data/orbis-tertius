select kcu.table_schema || '.' || kcu.table_name as table_name
     , kcu.table_name ||'.'|| kcu.column_name ||' = '|| ccu.table_name ||'.'|| ccu.column_name as
  join
     , tc.constraint_name as fk_name
  from information_schema.table_constraints as tc
  join information_schema.key_column_usage as kcu
    on tc.constraint_name = kcu.constraint_name
   and tc.table_schema = kcu.table_schema
  join information_schema.constraint_column_usage as ccu
    on ccu.constraint_name = tc.constraint_name
   and ccu.table_schema = tc.table_schema
 where constraint_type = 'FOREIGN KEY'
   and ccu.table_schema = :schm
   and ccu.table_name = :tbl
 order by 1
;
