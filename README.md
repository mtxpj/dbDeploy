# dbDeploy
This is gradle database update version control.

## How to configure:

1. Create `[name].profile` file in `/profiles` folder containing parameters for following keys:
```
dbDriver = com.mysql.jdbc.Driver
dbUrl = jdbc:mysql://localhost/
dbName = db_depl
dbUsername = db_depl
dbPassword = db_depl
dbDir = profiles/[name]/patches
dbms = mysql
patchUrl = http://github.com/mtxpj/dbDeploy/profiles/[name]/patches/
patchDir = profiles/[name]/patches/
useDbFile = profiles/[name]/use_database.sql
undooutputfile = profiles/[name]/undo_last_change.sql
changelogFile = profiles/[name]/create_changelog_table.sql
dropdatabasefile = profiles/[name]/drop_database.sql
createdatabasefile = profiles/[name]/create_database.sql
dumpdatabasetofile = profiles/[name]/dump_to_file.sql
restoredumpfromfile = profiles/[name]/restore_from_dump_file.sql
```

2. In `build.gradle` file __add property__ pointing to your `profiles/[name].profile` file:
```groovy
project.ext {
..[name] = `profiles/[name].properties`
...
```
3. Add `if else` block to `build.gradle` in task `chooseProfile`, to set location of your property file as value to the key `file`:
```groovy
task chooseProfile << {
  if (db=="[name]") {
    project.ext.set("file", [name])
    tasks.loadProperties.execute()
  println "Profile: " +db +"\nProperty file: "+ file
  } else if
  ...
}
chooseProfile.group = PARTIAL_GROUP
```
4. Create files defined in `[name].properties`:

* useDbFile = 'profiles/[name]/`use_database.sql`'
* undooutputfile = 'profiles/[name]/`undo_last_change.sql`'
* changelogFile = 'profiles/[name]/`create_changelog_table.sql`'
* dropdatabasefile = 'profiles/[name]/`drop_database.sql`'
* createdatabasefile = 'profiles/[name]/`create_database.sql`'
* dumpdatabasetofile = 'profiles/[name]/`dump_to_file.sql`'
* restoredumpfromfile = 'profiles/[name]/`restore_from_dump_file.sql`'

5. Run app:
+ `gradle -Pdb=[name] createDb` - this task will create database `dbName` in `dbUrl`.
+ `gradle -Pdb=[name] createChangelog` - this task will create changelog sql table defined in `create_changelog_table.sql` in `dbName` database.
+ `gradle -Pdb=[name] downloadPatches` - this task downloads all files from `patchUrl` to `dbDir` folder.
+ `gradle -Pdb=[name] updateDb` - this task will execute not logged before updates from `dbDir` folder.
+ `gradle -Pdb=[name] undo` - this task will turn `dbName` to state from previous run of `updateDb` task.
+ `gradle -Pdb=[name] dropDb` - this task will delete `dbName` database.
+ `gradle -Pdb=[name] dumpDb` - this task will create database dump file.
+ `gradle -Pdb=[name] recreateDb` - this task will `DROP`, `CREATE` database.
+ `gradle -Pdb=[name] restoreDump` - this task will  `recreateAndUpdateDb`, and restore `dbName` database from `DUMP` file.

__All statements should be in .sql files starting from 001.sql, 002.sql,...__

## You can create and use your own tasks to run sql files:
create `myFile.sql`
put it in `profiles/[name]/` folder
add parameter `myCommands = profiles/[name]/myFile.sql` in `/profiles/[name].profile` file
create 2 tasks in `build.gradle` file:
```groovy
task runMyCommands << {
  tasks.chooseProfile.execute()
  tasks.useDatabase.execute()
  tasks.myCommand.execute()
}
runMyCommands.group = '>>myTasks<<'
```
and
```groovy
task myCommand << {
  ant.sql(driver: dbDriver,
          url: dbUrl + dbName,
          userid: dbUsername,
          password: dbPassword,
          encoding: 'UTF-8',
          classpath: project.buildscript.configurations.classpath.asPath) {
      fileset(file: myCommands)
  }
}
myCommand.group = '>>myTasks<<'
```
