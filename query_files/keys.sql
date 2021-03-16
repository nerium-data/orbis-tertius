select distinct tc.constraint_type
     , kcu.column_name
     , case when tc.constraint_type = 'FOREIGN KEY' 
            then ccu.table_schema ||'.'|| ccu.table_name
            else NULL
             end as foreign_table
     , case when tc.constraint_type = 'FOREIGN KEY'
            then tc.table_name ||'.'|| kcu.column_name ||' = '|| ccu.table_name ||'.'|| ccu.column_name
            else NULL
             end as "join"
     , tc.constraint_name
  from information_schema.table_constraints as tc
  join information_schema.key_column_usage as kcu
    on tc.constraint_name = kcu.constraint_name
   and tc.table_schema = kcu.table_schema
  join information_schema.constraint_column_usage as ccu
    on ccu.constraint_name = tc.constraint_name
   and ccu.table_schema = tc.table_schema
 where tc.table_schema = :schm
   and tc.table_name = :tbl
 order by constraint_type desc, foreign_table asc;
