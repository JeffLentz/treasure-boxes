SELECT CONCAT (
		array_join(array_agg(row_count_query), concat(';',chr(10)))
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
			'insert into metadata.row_count_by_table select '''
			,table_schema
			,''' as table_schema, '''
			,table_name
			,''' as table_name, '''
			,table_schema
			,'.'
			,table_name
			,''' as full_name, COUNT(*) AS row_count from "'
			,table_schema
			,'"."'
			,table_name
			,'"'
			) AS row_count_query
	FROM information_schema.tables
	WHERE table_schema IN (${table_schemas})
	) x
