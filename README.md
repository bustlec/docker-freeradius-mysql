# Docker FreeRadius + MySQL Container
This is a FreeRADIUS server based on Alpine Linux (a lightweight Linux distribution) with MySQL support


## Supported tags
| Tag | Alpine Version | FreeRadius Version | Date | Changes |
| --- | :---: | :---: | :---: | :---: |
| Latest | 3.15.0 | 3.0.25 | 2022-01-21 | X |

Images size: 14MB

# Get this image
	
	$ git clone https://github.com/bustlec/docker-freeradius-mysql.git
	$ cd docker-freeradius-mysql
	$ docker build -t bustlec/freeradius:latest . --no-cache

## Environment Variables

* `DB_HOST`: Default to `0.0.0.0`.
* `ACS_HTTP_PORT`: Default to `3306`.
* `DB_DATABASE`: Default to `radius`.
* `DB_USERNAME`: Default to `radius`.
* `DB_PASSWORD`: Default to `radpass`.
* `RADIUS_CLIENT`: Default to `0.0.0.0`.
* `RADIUS_SECRET`: Default to `testing123`.
* `RADIUS_LOG_AUTH`: Default to `no`.


# Usage

Launch the FreeRadius container

	$ docker run -d --name freeradius \
		-p 1812-1813:1812-1813/udp \
		-e DB_HOST=<MYSQL_SERVER> \
		bustlec/freeradius:latest

Launch the FreeRadius and MySQL container

	$ docker-compose up -d

## Using Docker Compose


	version: '3'
	
	services:
	    freeradius:
	        image: 'bustlec/freeradius:1.0'
	        container_name: FreeRadius
	        restart: always
	        privileged: true
	        ports:
	          - 1812-1813:1812-1813/udp
	        environment:
	          - DB_HOST=db
	          - RADIUS_CLIENT=0.0.0.0
	          - RADIUS_SECRET=testing123
	        depends_on:
	          - "db"
	    db:
	        image: 'mysql'
	        container_name: MySQL
	        restart: always
	        command: --default-authentication-plugin=mysql_native_password
	        environment:
	          - MYSQL_ROOT_PASSWORD=dbpassword
	          - MYSQL_DATABASE=radius
	          - MYSQL_USER=radius
	          - MYSQL_PASSWORD=radpass
	        privileged: true
	        ports:
	          - 3306:3306
	        volumes:
	          #- ./db/data:/var/lib/mysql
	          - ./initdb/init.sql:/docker-entrypoint-initdb.d/init.sql
	          - ./initdb/sql:/opt/sql

## Create FreeRADIUS User

	# Run a command in a running container
	$ docker exec -it MySQL mysql -uroot -p<MYSQL_ROOT_PASSWORD>

	# Create user
	mysql> use radius;
	mysql> INSERT INTO radcheck (username,attribute,op,value) values("im_bustlec", "Cleartext-Password", ":=", "password");

	# Check
	mysql> select * from radcheck;
	+----+----------+--------------------+----+----------+
	| id | username | attribute          | op | value    |
	+----+----------+--------------------+----+----------+
	|  1 | im_bustlec  | Cleartext-Password | := | password |
	+----+----------+--------------------+----+----------+

## Simple test
	
	// test for default user 
	$ radtest im_bustlec password 127.0.0.1 0 testing123

You should see output like:

	Sent Access-Request Id 152 from 0.0.0.0:34182 to 127.0.0.1:1812 length 74
	        User-Name = "im_bustlec"
	        User-Password = "password"
	        NAS-IP-Address = 172.24.0.3
	        NAS-Port = 0
	        Message-Authenticator = 0x00
	        Cleartext-Password = "password"
	Received Access-Accept Id 152 from 127.0.0.1:1812 to 127.0.0.1:34182 length 20


## Logs

	$ docker logs -f FreeRadius


