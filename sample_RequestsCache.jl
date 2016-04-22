include("src/RequestsCache.jl")

import RequestsCache: create_query, execute, CachedSession, Session
import URIParser: URI
import Requests: get

session = Session()
#session = CachedSession()
session = CachedSession(cache_name="cache.jld", backend="jld", expire_after=Base.Dates.Day(1))
#println(session)

prepared_query = create_query(get, URI("http://httpbin.org/get"), query = Dict("title" => "page1"), data = "Hello World")
response = execute(prepared_query; session=session)

#function get(uri; query=Dict(), session=Session())
#    prepared_query = create_query(get, URI(uri), query = query, data)
#    response = execute(prepared_query; session=session)
#end
#response = get("http://httpbin.org/get", query = Dict("title" => "page1"), session=session)

println(readall(response))