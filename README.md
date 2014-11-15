# Bookmark Manager: Week 4 Project at Makers Academy

The task: build a website that has the following options:
```
  - Show a list of links from the database
  - Add new links
  - Add tags to the links
  - Filter links by a tag
```

## Languages and Tools
```
 - Ruby
 - Rspec
 - Capybara
 - Sinatra
 - DataMapper
 - PostgreSQL
 - BCrypt
 - Rack-Flash
```

### How to Open
Clone this repository.
```
  $ git clone git@github.com:barr-code/bookmark_manager.git
```
Change into the directory.
```
  $ cd bookmark_manager
```
Install the gems.
```
  $ bundle install
```
Make the database.
```
  $ psql
  =# create database bookmark_manager_test;
  =# create database bookmark_manager_development;
```
Run the tests.
```
  $ rspec
```

### Fire It Up
```
  $ rackup
```
Type the following into your browser address bar:
```
http://localhost:9292
```
Sign up and add some bookmarks.

### Still to Come
  My list of features to finish/include:
  ```
    - Get the password token working so users can reset forgotten passwords
    - Incorporate MailGun to send emails with password tokens
    - Pretty it all up with CSS
  ```

### What I Learned
Bookmark Manager was my first introduction to creating and using databases. I learned how to interact with an SQL database both directly through PSQL and using the DataMapper gem as an intermediary. I learned how to use the BCrypt gem to help create more secure passwords for users, and I learned to create users without the assistance of a gem like Devise. 
