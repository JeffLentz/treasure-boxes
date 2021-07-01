SELECT CONCAT (
		array_join(array_agg(max_time_query), concat(';',chr(10)))
		,';'
		) AS queries
FROM (
	SELECT table_schema
		,table_name
		,CONCAT (
			table_schema
			,'.'
			,table_name
			) AS full_name
		,CONCAT (
			'insert into metadata.max_time_by_table select '''
			,table_schema
			,''' as table_schema, '''
			,table_name
			,''' as table_name, '''
			,table_schema
			,'.'
			,table_name
			,''' as full_name, max(time) as max_time_int, cast(FROM_UNIXTIME(max(time)) as varchar) as max_time_str_utc from "'
			,table_schema
			,'"."'
			,table_name
			,'"'
			) AS max_time_query
	FROM information_schema.tables
	WHERE table_schema IN (${table_schemas})
	) x
