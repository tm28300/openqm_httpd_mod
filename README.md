# Description

openqm_hhpd_mod is an Apache 2.4 httpd module allowing you to execute an OpenQM routine to process a request. The routine receives the information from the request and can return an error code, which will generate a standard error page or return the response contents, and the http header. The response can be in any format as defined in the Content-Type header.

# Installation

The module must be compiled and requires the following dependencies:
- gcc
- apache2-dev
- libpcre3-dev
- makefile

Then you must execute the command **make** then **make install**, then copy the file **openqm.load** into the directory **/etc/apache2/mods-available/** and activate it via the command **a2enmod openqm**.

# Use

In the Apache httpd virtual host configuration file, you must add the **OpenQMLocalAccount** directive to define the name of the OpenQM account containing the routines to call and add the following directives:
- <Location /openqm>
- SetHandler openqm
- \</Location>

After that any http request to the first level subdirectory **openqm** will execute the routine whose name is in the second part of the path. For example the request **http://localhost/openqm/my_routine** will call the routine **my_routine** which must be cataloged in the configured account.

The called routine must have 18 parameters. The first 15 parameters are input:
- auth_type: The authentication type of the request.
- document_root: The document_root of the virtual host.
- gateway_interface: Not defined in this version.
- hostname: The hostname of the request.
- headers_in: The request header in a dynamic array with two attributes linked in multi-value. The first attribute contains the header parameter name and the second its value.
- path_info: The path_info of the request. That is to say the part of the uri which was not used to find the executed file.
- path_translated: Path of the file on the server corresponding to the request.
- query_string: The query parameters either in the url (GET) or in POST mode. The parameters are stored in a dynamic array with two attributes linked in multi-value. The first attribute contains the header variable name and the second its value.
- remote_info: Client IP address and port separated by ":".
- remote_user: User identified according to the virtual host configuration.
- request_method: Call method (GET, POST, PUT, PATH or DELETE).
- request_uri: URI to access to this page.
- script_filename: Name of the script file indicated in the URI with its absolute path.
- script_name: Name of the script file indicated in the URI without path.
- server_info: All environment variables of the httpd server in a dynamic array with two attributes linked in multi-value. The first attribute contains the header variable name and the second its value.

The last 3 parameters are used for the return. In accordance with the OpenQM client library these variables are initialized during the call and the routine must not affect a string longer than the initialized buffer. These variables are:
- http_output: The content of the query result (the page or file). This output is not modified by the module, the routine should generate the line breaks following the response format. In case of error status the content of the response is ignored.
- http_status: The status of the response that must be modified by the response. Status 0 or 200 indicates success. There is no check that the status is valid, it is up to the routine to generate a status respecting web standards.
- headers_out: The response header in a dynamic array with two attributes linked in multi-value. The first attribute contains the header variable name and the second its value. The Content-Type is used to indicate the format of the response.

When called, the content of these variables is the maximum length preceded by a star character. Respectively 65535, 3 and 16383.

# Limitation

I haven't found how to return a custom error message. In order to overcome this limitation I developed a micro httpd server (openqm_httpd_server) with libmicrohttpd.

The Apache httpd server and the OpenQM server must be installed on the same server and the httpd execution user must be able to connect to OpenQM via the client library.
