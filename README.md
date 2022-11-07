<h1>Erlang File reader server based on OTP 24. Handles client's HTTP request and reads test_file.txt during a timer. Return 200 OK in successfull case and 503 other.<h1>

<h1>Build and run instruction:<h1>
<p>make clean<p>
make <p>
make run<p>

<h1>Static analysis tool:<h1>
<p>make clean<p>
make plt<p>
make dialyze<p>

<h1>Unit tests:<h1>
<p>make ct_clean<p>
make ct<p>
report will be stored in _build folder<p>

<h1>Code coverage:<h1>
<p>make ct_clean<p>
make coverage<p>
link with index file will be provided in console output. Current coverage 66%<p>

<h1>How to test the server localy:<h1>
<p>install OPT 24<p>
build and run web server<p>
run test.sh script<p>
The script performes 3 test cases - two negative and one positive.<p>
The first negative tc generates 10G file and emulate out of memory (file can not be read). 503 is expected<p>
The second negative tc generates 1G file and emulate out of time (file can be read, but timer is expired). 503 is expected<p>
The third positive tc generates 1M file and emulate file can be read successfilly. 200 is expected<p>

<h1>How to test and run the server in Docker:<h1>
docker build .<p>
docker run -v <pwd:/Webserver> -it --rm -p8080:8080 <Image><p>
Start test.sh script or send request http:8080//localhost/file/read via browser<p>
docker exec -it <Image> - go inside the image.<p>
