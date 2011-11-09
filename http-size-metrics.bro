@load base/frameworks/metrics
@load base/protocols/http
@load base/utils/site

redef enum Metrics::ID += {
	HTTP_REQUEST_SIZE_BY_HOST_HEADER,
};

event bro_init()
{
    Metrics::add_filter(HTTP_REQUEST_SIZE_BY_HOST_HEADER,
                [$name="all",
                 $break_interval=3600secs
                ]);

}

event HTTP::log_http(rec: HTTP::Info)
{
	if ( rec?$host && rec?$response_body_len)
		Metrics::add_data(HTTP_REQUEST_SIZE_BY_HOST_HEADER, [$str=rec$host], rec$response_body_len);
}
