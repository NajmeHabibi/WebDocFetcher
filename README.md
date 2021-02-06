# WebDocFetcher

Here are the steps to run the project:
1. Install XAMPP (version: 5.6.40) and start it
2. Open http://localhost/phpmyadmin in your browser
3. Create Sadaf database by importing simple_sadaf_database.sql
4. Then import docdb.sql over the base database (This will create 'sites' and 'docs' tables)
5. Login through http://localhost/sadaf-master/www/sadaf/login.php page
6. Now you can use the website

In case of having trouble crawling websites:
* try turning off your VPN connection before crawling
* copy "config/curl-ca-bundle.crt" file under the project's directory into "xampp/apache/bin" path in your computer
* make sure that you see these two lines in php.ini in xampp's config section, referring to the appropriate path:
  - curl.cainfo="C:\xampp\apache\bin\curl-ca-bundle.crt"
  - openssl.cafile="C:\xampp\apache\bin\curl-ca-bundle.crt"