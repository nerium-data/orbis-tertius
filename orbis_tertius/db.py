#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
from pathlib import Path

import psycopg2
import psycopg2.pool

_DBURL = os.getenv("DATABASE_URL", "postgres://postgres@localhost:5432/thomas")
DBURL = f"{_DBURL}?application_name=orbis"
POOL = pool = psycopg2.pool.SimpleConnectionPool(1, 20, DBURL)


def query(sql, params={}, db_url=DBURL, as_dict=False, auto=False):
    """
    Connect to database at `db_url`, create a context-managed cursor and execute
    `sql` against it, returning the status and any results.

    `params` takes a dict or tuple to pass to any bind parameters in the query
    `auto` = boolean value sets the `autocommit` property of the psycopg2 connection
    """
    conn = pool.getconn()
    with conn.cursor() as cur:
        conn.autocommit = auto
        cur.execute(sql, params)
        status = cur.statusmessage
        result = []
        if cur.description is not None:
            result = cur.fetchall()
            if as_dict:
                cols = [desc[0] for desc in cur.description]
                result = [dict(zip(cols, row)) for row in result]
    pool.putconn(conn)
    return (status, result)


def query_from_file(path, params={}, as_dict=False, auto=False):
    """Read SQL from file at `path` and submit via `query()` method"""
    # If path doesn't exist
    if not os.path.exists(path):
        result = ("ERROR", [{"error": f"File '{path}' not found!"}])
        return result

    # If it's a directory
    if os.path.isdir(path):
        result = ("ERROR", [{"error": f"'{path}' is a directory!"}])
        return result

    # Read the given .sql file into memory.
    with open(path) as f:
        sql = f.read()
        result = query(sql=sql, params=params, as_dict=as_dict, auto=auto)
        return result


def path_by_name(query_name):
    """Find file matching query_name and return Path object"""
    flat_queries = list(Path(os.getenv("QUERY_PATH", "query_files")).glob("**/*"))
    query_file = None
    query_file_match = list(filter(lambda i: query_name == i.stem, flat_queries))
    if query_file_match:
        # TODO: Warn if more than one match
        query_file = query_file_match[0]
    return query_file


def query_by_name(query_name, params={}, as_dict=False, auto=False):
    path = path_by_name(query_name)
    result = query_from_file(path=path, params=params, as_dict=as_dict, auto=auto)
    return result


if __name__ == "__main__":
    # simple test that should cover everything as query_by_name calls the rest
    r = query_by_name("test", {"ls": [1, 9]})
    print(r)
