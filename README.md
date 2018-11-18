# Development Install (Ubuntu)

## Base install
1. Clone repository
	```

	```
1. Change to directory:
	```
	cd propertyGuru
	```
1. Install required gems
	```
	bundle install
	```
1. 

## Database
1. Install Postgres
1. Edit /etc/postgresql/10/main/pg_hba.conf to have this line 
	```
	local   all             all                                     trust
	```
1. Restart postgres: 
	```
	sudo service postgresql restart
	```
1. Install PostGis
	```
	sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
	sudo apt-get install postgis
	```	
1. Add "mhb" user to postgres, and "superuser" for pg extensions
	```
	sudo su - postgres
	createuser -dP mhb
	createuser -dP superuser
	psql
	alter user superuser with superuser;
	```
1. Enable PostGis
	```
	CREATE EXTENSION postgis;
	```	
1. Create databases: 
	```
	rake db:create
	```
1. Run migrations:
	```
	rake db:migrate
	```


# 



# CI Suite

# Running unit tests


# Deploying

